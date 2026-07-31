---
name: fargate-handoff
description: Hand off the current coding task from the laptop agent to a remote Fargate pi-web session. Detects the active repo and branch, launches an ephemeral Fargate container via the Hermes host, and returns the Tailscale URL so work can continue in the browser or on a phone.
---

# Fargate Handoff

Use this skill when the user wants to move work from their laptop/local agent to a remote Fargate coding session.

## What this does

1. Detects the current git repository and branch (or uses the repo/branch the user provides).
2. Uses AWS SSM to run the launcher on the Hermes host (`i-0328fd8001432219f` in `af-south-1`).
3. Waits for the Fargate task to become READY.
4. Returns the pi-web Tailscale URL, task short ID, and kill command.

## Prerequisites on the laptop

- `aws` CLI installed and authenticated with permission to run `ssm:SendCommand` and `ssm:GetCommandInvocation` on instance `i-0328fd8001432219f`.
- The current working directory is inside a git repo that has a remote matching `github.com/<owner>/<repo>` and a `.devcontainer/docker-compose.yml`.

## Invocation

User says something like:
- "hand this off to fargate"
- "continue this on fargate"
- "fargate handoff"
- "run this on the remote pi session"

## Steps

1. Resolve the repository and branch:
   ```bash
   REPO_URL=$(git remote get-url origin 2>/dev/null | sed -E 's#^https://##; s#^git@##; s#:#/#' | sed -E 's/\.git$//')
   REF=$(git branch --show-current)
   ```
   If the user supplied a repo/branch, use those instead.

2. Send the launch command via SSM:
   ```bash
   aws ssm send-command \
     --region af-south-1 \
     --instance-ids i-0328fd8001432219f \
     --document-name AWS-RunShellScript \
     --parameters "commands=[\"/opt/fargate-agent-harness/bin/launch-task $REPO_URL $REF\"]" \
     --output text --query 'Command.CommandId'
   ```

3. Poll `aws ssm get-command-invocation` until the status is `Success` or `Failed`.

4. Parse the output:
   - `task: arn:aws:ecs:af-south-1:.../coding-agents/<uuid>`
   - `READY: https://fargate-<short-id>.<tailnet>.ts.net`

5. Report back to the user:
   - The READY URL (open in browser/Tailscale phone). It uses HTTP because the Tailnet tunnel is already encrypted by WireGuard.
   - The task short ID.
   - The kill command: `/kill <short-id>` in Telegram, or `aws ecs stop-task --region af-south-1 --cluster coding-agents --task <arn>`.
   - Reminder that the session log will be uploaded to `s3://coding-agent-session-logs-526094459325-af-south-1/sessions/<short-id>/session.log` on kill.

## Optional follow-ups

If the user asks, list active sessions with:
```bash
aws ssm send-command --region af-south-1 --instance-ids i-0328fd8001432219f \
  --document-name AWS-RunShellScript \
  --parameters 'commands=["/opt/fargate-agent-harness/bin/hermes-fargate sessions"]' \
  --output text --query 'Command.CommandId'
```
