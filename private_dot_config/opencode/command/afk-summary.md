---
description: Summarize completed, failed, and interrupted AFK work from tickets and logs
---

Read-only summary of AFK work. Do not modify, delete, commit, or change any files. This command is strictly informational.

## Steps

1. **Collect issue files first**: Inspect `.scratch/*/issues/*.md` as the default source of truth for AFK work.

2. **Read issue metadata**: For each issue file, read the `Status:` line near the top and every `## AFK Summary` block in the file.

3. **Report every recorded attempt**: Treat each `## AFK Summary` block as one AFK attempt. Include repeated attempts on the same issue, even when they reference the same ticket or outcome.

4. **Group the report by outcome**:
   - Completed or successful work
   - Failed or blocked work
   - Interrupted or incomplete work
   - Issues with missing `## AFK Summary` blocks

5. **Handle missing summaries explicitly**: If an issue file has no `## AFK Summary` block, report it as missing a summary. Do not fall back to raw AFK logs on the default path.

6. **Produce summary**: Output a structured report containing:
   - Completed work: ticket references, status, and AFK summary details
   - Failed or blocked work: ticket references, status, and blocker details
   - Interrupted or incomplete work: ticket references, status, and last known state
   - Missing summaries: issue references with no `## AFK Summary` block
   - Any repeated attempts or patterns visible across issue summaries

## Constraints

- Read-only: do not edit, delete, move, or create any files
- Do not change ticket statuses
- Do not commit or stage any changes
- Do not scan `.scratch/.opencode-afk-logs/` on the default path
- Report only; take no action beyond reading and summarizing
