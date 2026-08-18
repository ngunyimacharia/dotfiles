---
name: remote-handoff
description: Hand off a coding task to a remote ephemeral exe.dev box running opencode, via the local remote-agent-harness checkout. Use when the user asks to delegate or run a task on a remote box, spin up a remote coding environment/session, or "hand this off". The Telegram notification with the opencode session URL is sent automatically by the harness.
---

# Remote Handoff

Delegate coding work to an ephemeral remote box (exe.dev VM running opencode web, tailnet-only) using the existing harness at `~/Code/remote-agent-harness`. The harness handles VM lifecycle, repo clone, opencode session creation, prompt delivery, and the Telegram notification containing the session URL.

## Security rules (non-negotiable)

- Never print, copy, or commit values from `~/.hermes/harness-env` (tokens, tailnet names, chat IDs). Source it; never read it aloud.
- Never paste session URLs, VM names, or tailnet hostnames into issues, PRs, commits, or chezmoi-tracked files.
- This skill stays free of identifiers by design; everything sensitive is resolved from the local environment at runtime.

## Prerequisites

- Harness checkout at `~/Code/remote-agent-harness` (worktrees of it also work).
- `~/.hermes/harness-env` exporting `HARNESS_BACKEND=exe` plus Telegram, Tailscale, and provider credentials.

## Workflow

Every harness command needs the env sourced first:

    cd ~/Code/remote-agent-harness
    set -a; source ~/.hermes/harness-env; set +a

1. **Hand off a task** — creates the box, clones the repo, delivers the prompt, and sends the Telegram message with the opencode URL automatically:

       bin/hermes-harness launch github.com/<owner>/<repo> [<ref>] --prompt "<full task description>"

   Repo format is scheme-less (`github.com/owner/repo`). Note the short id from the output (`Task: <sid>`). Write the prompt as a complete brief: context, files, acceptance criteria — the remote agent cannot ask quick clarifying questions.
2. **Send follow-up work to a running session:**

       bin/hermes-harness prompt <sid> "<instruction>"

3. **List sessions:** `bin/hermes-harness list`
4. **Stop a session:** `bin/hermes-harness kill <sid>`

The user watches and steers the session through the opencode web URL from the Telegram message. Do not block waiting for completion: the remote agent runs autonomously, and the harness reaps idle boxes (`idle-check` / TTL).

## Debugging ladder

Work through these in order; each step names the likely cause and fix.

1. **Any command fails immediately / env-looking errors** — env not sourced. Re-run prefixed with `set -a; source ~/.hermes/harness-env; set +a`. Verify backend without leaking anything: `bash -c 'set -a; source ~/.hermes/harness-env; set +a; echo "$HARNESS_BACKEND"'` must print `exe`.
2. **Launch output mentions ECS/Fargate** — `HARNESS_BACKEND` is unset or not `exe`; fix `~/.hermes/harness-env`.
3. **`Could not parse machine id from launch-task-exe output`** — the launcher itself failed. Run `bin/launch-task-exe <repo> <ref>` directly and read its stderr; the usual cause is a missing `TS_AUTHKEY`, `KIMI_API_KEY`, or `OPENCODE_GO_API_KEY` in `~/.hermes/harness-env`.
4. **Launch succeeded but "Initial prompt was not accepted"** — the VM was not ready for the API yet or the tailnet path failed. Get the URL from `bin/hermes-harness list`, then retry manually: `bin/opencode-send <url> /home/exedev/work "<task>"`. If curl-level errors persist after 60s, check `tailscale status` and that the VM appears online.
5. **Launch printed the message but no Telegram arrived** — `bin/telegram-notify "remote-handoff self-test"`; a failure means `TELEGRAM_BOT_TOKEN` / `TELEGRAM_CHAT_ID` are missing from `~/.hermes/harness-env`.
6. **`prompt` says "not correlated with Pi"** — the session predates opencode prompt routing (harness checkout is behind; `git pull`) or the session is aws/fly-backed (pi) and needs `bin/hermes-harness inspect <sid>` to reconcile first.
7. **Still stuck** — `python3 -m unittest discover -s tests -q` in the harness checkout must pass; then inspect VM state with `bin/exe-cli` (list VMs, check the session short id) and the session DB at `~/.hermes/harness-sessions.db`.
