# Filter blocked AFK tickets before selection

Status: done

## Why

`bin/opencode-afk` currently offers downstream AFK tickets even when their upstream implementation issues are not complete. Filtering blocked tickets before selection prevents agents from launching work out of dependency order while preserving the current AFK launch flow for unblocked tickets.

## Scope

Includes:
- Parse `## Dependencies` sections in `.scratch/*/issues/*.md` for otherwise AFK-eligible tickets.
- Enforce only bullets under `Blocking:`; ignore bullets under `Related:` and any other section.
- Treat `- None` under `Blocking:` case-insensitively as no blocking dependencies.
- Support backticked repo-relative dependency paths such as ``- `.scratch/tabby-tmux-opencode/issues/01-add-tabby-tpm-plugin.md` ``.
- Consider a dependency satisfied only when the referenced ticket exists and has a terminal status according to the existing `is_terminal_status` logic: `done`, `closed`, `complete`, or `resolved`.
- Exclude blocked tickets from the file passed to `fzf` and the fallback numbered menu.
- Print clear skip messages for blocked tickets, including the blocked ticket label/path and each unmet dependency.
- Preserve current scanning, AFK eligibility, terminal-ticket skipping, selection, tmux, and background launch behavior for selectable tickets.

Excludes:
- Adding a broader issue dependency graph or topological launch ordering.
- Treating `Related:` entries as blockers.
- Marking downstream tickets unblocked within the same invocation when an upstream ticket is also selected; downstream should wait for a future invocation after upstream completion.
- Changing ticket status values or issue tracker conventions.

## Context

- Parent PRD/spec: User-provided PRD summary for dependency-aware AFK ticket selection in `bin/opencode-afk`.
- Relevant implementation seam: `bin/opencode-afk` builds `TICKET_LIST` around the existing scan at the `# --- Select pending AFK tickets ---` section, then feeds that list to `select_tickets_with_fzf` or `select_tickets_with_menu`.
- Existing helpers to reuse: `get_ticket_status`, `is_terminal_status`, `is_ready_for_agent_status`, `has_afk_executor`, and `ticket_label`.

## Dependencies

Blocking:
- None

Related:
- `.scratch/dependency-aware-opencode-afk/issues/02-add-dependency-fixture-verification.md`

## Acceptance Criteria

1. AFK-eligible tickets with no `## Dependencies` section remain selectable.
2. AFK-eligible tickets with `Blocking:` containing only `- None` in any case remain selectable.
3. AFK-eligible tickets with only `Related:` dependencies remain selectable.
4. AFK-eligible tickets with `Blocking:` dependencies are selectable only when every referenced dependency file exists and is terminal by the existing terminal-status logic.
5. AFK-eligible tickets with any non-terminal or missing blocking dependency are excluded from both `fzf` and fallback menu selection.
6. Blocked tickets emit clear skip output that identifies unmet dependency path(s).
7. If upstream and downstream tickets are both ready in one invocation, the downstream ticket is still blocked until a later invocation after the upstream file has terminal status.
8. Existing AFK eligibility and launch behavior remain unchanged for tickets that pass the dependency filter.

## Verification

- Run `sh -n bin/opencode-afk` and confirm no syntax errors.
- Run `bin/opencode-afk-verify-dependency-fixtures` from the repo root to exercise temporary fixtures in both `fzf` and fallback menu modes.
- Create temporary fixture tickets under a scratch feature directory covering: no dependencies, `Blocking: - None`, terminal blocker, non-terminal blocker, missing blocker, only `Related:`, and multiple blockers.
- Run `bin/opencode-afk` against the fixture with a controlled model selection path and verify only unblocked tickets appear in selection.
- Verify blocked tickets appear in log/terminal output as skipped with unmet dependencies.
- Verify a downstream fixture remains blocked in a run where its upstream ready fixture is also selectable, then becomes selectable only after the upstream fixture status is made terminal and the command is run again.
- If practical, verify both `fzf` and fallback numbered-menu flows by temporarily running with and without `fzf` on `PATH`.

## Classification

- Executor: `AFK`
- Rationale: The PRD defines the dependency parsing and filtering semantics completely; no product, design, or architecture decision is required beyond normal review.

## Comments
