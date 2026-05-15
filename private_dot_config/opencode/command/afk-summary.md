---
description: Summarize completed, failed, and interrupted AFK work from tickets and logs
---

Read-only summary of AFK work. Do not modify, delete, commit, or change any files. This command is strictly informational.

## Steps

1. **Collect AFK logs**: Inspect `.scratch/.opencode-afk-logs/` for all log files. Extract session outcomes, visible commits, notable changes, and any blocker mentions.

2. **Collect issue tickets**: Inspect `.scratch/*/issues/*.md` for all local markdown tickets. Read the `Status:` line near the top of each file.

3. **Filter to terminal states only**: Include only tickets with completed, failed, or interrupted statuses. Exclude all pending, in-progress, or non-terminal tickets from the summary.

4. **Match logs to tickets**: Correlate AFK log entries with their corresponding issue tickets by feature slug, issue number, or ticket title.

5. **Surface unmatched logs**: For any AFK log entries that do not match a known ticket, report them as unmatched so they are not silently lost.

6. **Produce summary**: Output a structured report containing:
   - Completed work: ticket references, commits, and notable changes
   - Failed work: ticket references, error context, and blockers
   - Interrupted work: ticket references and last known state
   - Unmatched logs: log entries with no corresponding ticket
   - Any common blockers or patterns across sessions

## Constraints

- Read-only: do not edit, delete, move, or create any files
- Do not change ticket statuses
- Do not commit or stage any changes
- Do not run cleanup or deletion operations
- Report only; take no action beyond reading and summarizing
