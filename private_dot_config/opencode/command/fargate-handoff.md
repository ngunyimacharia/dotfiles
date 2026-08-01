---
description: Hand off the current coding task to the supervised Fargate Pi session
---

# Fargate Handoff

Use this command when the user wants to continue work in an ephemeral Fargate pi-web session.

1. Resolve the GitHub repository and current branch:
   ```bash
   REPO_URL=$(git remote get-url origin 2>/dev/null | sed -E 's#^https://##; s#^git@##; s#:#/#' | sed -E 's/\.git$//')
   REF=$(git branch --show-current)
   ```

2. Verify `git status --short`, the upstream branch, and `git rev-list --count '@{upstream}..HEAD'`. Fargate clones from GitHub, so local-only work will be absent. Ask before committing or pushing.

3. Set `PROMPT` to the coding task. Build shell-safe SSM parameters and launch through Hermes so the Pi session is correlated and supervisable:
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

4. Poll `aws ssm get-command-invocation` until `Success` or `Failed`. Setup can take up to 15 minutes.

5. Return the `http://fargate-<id>.<tailnet>.ts.net` URL, task and Pi session IDs, and these controls: `/inspect`, `/transcript`, `/pi_prompt`, `/abort`, and `/kill`.

6. Explain that shutdown publishes `manifest.json` last under `s3://coding-agent-session-logs-526094459325-af-south-1/sessions/<short-id>/`. The manifest covers transcripts, subagent artifacts, hashes, and token/cost usage; artifacts expire after 30 days.
