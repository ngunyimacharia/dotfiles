---
name: fargate-handoff
description: Hand off the current coding task from the laptop agent to a remote Fargate pi-web session. Detects the active repo and branch, launches an ephemeral Fargate container via the Hermes host, and returns the Tailscale URL so work can continue in the browser or on a phone.
---

# Fargate Handoff

Use this skill when the user wants to move work from their laptop/local agent to a remote Fargate coding session.

## What this does

1. Detects the current git repository and branch (or uses the repo/branch the user provides).
2. Uses AWS SSM to run the launcher on the Hermes host (`i-0328fd8001432219f` in `af-south-1`).
3. Launches and correlates the primary Pi session through `hermes-fargate`, optionally sending the task as its initial prompt.
4. Returns the pi-web Tailscale URL, task short ID, supervision commands, and artifact location.

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

2. Verify `git status --short`, the upstream branch, and `git rev-list --count '@{upstream}..HEAD'`. Fargate clones from GitHub, so uncommitted or unpushed work will be absent. Ask before committing or pushing on the user's behalf.

3. Set `PROMPT` to the coding task, then build shell-safe SSM parameters and launch through the session manager:
   ```bash
   PARAMETERS=$(python3 - "$REPO_URL" "$REF" "$PROMPT" <<'PY'
   import json, shlex, sys
   launch = shlex.join(["/opt/fargate-agent-harness/bin/hermes-fargate", "launch", *sys.argv[1:3], "--prompt", sys.argv[3]])
   command = "set -a; . /home/ec2-user/.hermes/fargate-env; set +a; exec sudo -u ec2-user --preserve-env=TELEGRAM_BOT_TOKEN,TELEGRAM_CHAT_ID " + launch
   print(json.dumps({"commands": [command]}))
   PY
   )
   aws ssm send-command \
     --region af-south-1 \
     --instance-ids i-0328fd8001432219f \
     --document-name AWS-RunShellScript \
     --parameters "$PARAMETERS" \
     --output text --query 'Command.CommandId'
   ```

4. Poll `aws ssm get-command-invocation` until the status is `Success` or `Failed`. Setup can take up to 15 minutes.

5. Parse the output:
   - `task: arn:aws:ecs:af-south-1:.../coding-agents/<uuid>`
   - `READY: http://fargate-<short-id>.<tailnet>.ts.net`
   - `Pi: <pi-session-id>`

6. Report back to the user:
   - The READY URL (open in browser/Tailscale phone). It uses HTTP because the Tailnet tunnel is already encrypted by WireGuard.
   - The task short ID.
   - Telegram controls: `/inspect`, `/transcript`, `/pi_prompt`, `/abort`, and `/kill` with the short ID.
   - The artifact prefix `s3://coding-agent-session-logs-526094459325-af-south-1/sessions/<short-id>/`; `manifest.json` is uploaded last as the completion marker and artifacts expire after 30 days.

## Optional follow-ups

Use `hermes-fargate list`, `inspect`, `transcript`, `prompt`, `abort`, or `kill` through SSM. For example:
```bash
aws ssm send-command --region af-south-1 --instance-ids i-0328fd8001432219f \
  --document-name AWS-RunShellScript \
  --parameters 'commands=["sudo -u ec2-user /opt/fargate-agent-harness/bin/hermes-fargate list"]' \
  --output text --query 'Command.CommandId'
```
