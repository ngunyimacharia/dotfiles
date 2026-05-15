# Add fixture verification for dependency-aware AFK selection

Status: done

## Why

Dependency filtering is shell-script behavior with several parsing edge cases, so a repeatable fixture check reduces the chance of regressing ticket selection semantics. This issue makes the PRD acceptance matrix easy to rerun after implementation or future edits.

## Scope

Includes:
- Add a lightweight, repo-appropriate verification path for `bin/opencode-afk` dependency filtering using temporary fixture issues.
- Cover fixtures for: no dependencies, `Blocking: - None`, terminal blocker, non-terminal blocker, missing blocker, only `Related:`, and multiple blockers.
- Verify blocked tickets are omitted from selectable candidates and emit clear skip messages.
- Verify terminal blockers unblock downstream tickets, while non-terminal or missing blockers keep downstream tickets blocked.
- Verify downstream remains blocked during an invocation where its upstream ticket is merely selected/ready, and is only selectable in a later invocation after upstream status becomes terminal.
- Document or script how to run the verification without permanently polluting `.scratch/` with test fixtures.

Excludes:
- Replacing the existing interactive `fzf`, menu, tmux, or background execution behavior.
- Introducing a heavyweight test framework unless it is clearly justified by the existing repository patterns.
- Testing opencode model execution itself; this is about candidate discovery and dependency filtering.

## Context

- Parent PRD/spec: User-provided PRD summary for dependency-aware AFK ticket selection in `bin/opencode-afk`.
- Related implementation file: `bin/opencode-afk`.
- Repo test pattern: no traditional build system; shell verification should stay POSIX-friendly and compatible with the dotfiles repository guidance.

## Dependencies

Blocking:
- `.scratch/dependency-aware-opencode-afk/issues/01-filter-blocked-afk-tickets.md`

Related:
- None

## Acceptance Criteria

1. `sh -n bin/opencode-afk` is part of the verification path.
2. The fixture matrix includes all dependency cases named in Scope and clearly identifies expected selectable versus skipped tickets.
3. The verification can be run repeatedly from a clean checkout without leaving persistent fixture issue files behind.
4. Verification output or documentation makes failures actionable by showing which dependency case failed.
5. Both selection flows are addressed: automated or manual coverage for the fallback menu is included, and `fzf` coverage is included when practical or explicitly documented if not practical in the local environment.

## Verification

- Run the added verification path and capture passing output or the documented manual checklist results.
- Run `bin/opencode-afk-verify-dependency-fixtures` from the repo root.
- Confirm fixture files are created in a temporary location or cleaned up after the run.
- Confirm the verification fails before/fails without the dependency filter where practical, or otherwise documents the expected observable behavior it guards.

## Classification

- Executor: `AFK`
- Rationale: The fixture matrix and expected behavior are specified by the PRD, and the work can be completed without a human decision.

## Comments
