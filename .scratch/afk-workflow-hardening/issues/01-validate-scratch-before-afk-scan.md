# Validate `.scratch` safety before AFK ticket scanning

Status: done

## Why

`opencode-afk` should not operate on scratch tickets unless the local scratch tracker is protected from accidental commits. This fails fast before any ticket selection or AFK launch when `.scratch` is not ignored or when `.scratch/**` is tracked.

## Scope

Includes:
- Add pre-scan validation in `bin/opencode-afk` after the missing `.scratch` no-op check and before log directory creation or ticket scanning.
- Pass the ignore check only when `.gitignore` contains a rule that ignores `.scratch` or `.scratch/`.
- Fail if `git ls-files` reports any tracked `.scratch/**` path, including `.scratch/.opencode-afk-logs/**`.
- Preserve current missing `.scratch` behavior: warn and exit 0.
- Add fixture coverage to `bin/opencode-afk-verify-dependency-fixtures` or an equivalent repo-local automated shell verifier.

Excludes:
- Changing the local markdown tracker storage model.
- Removing or untracking existing scratch files for the user.
- Tmux window naming or autoclose behavior.

## Context

- Parent PRD/spec: `.scratch/afk-workflow-hardening/PRD.md`
- Relevant code: `bin/opencode-afk`, `bin/opencode-afk-verify-dependency-fixtures`

## Dependencies

Blocking:
- None

Related:
- None

## Acceptance Criteria

1. Running `opencode-afk` in a repo with `.scratch/` present but no `.gitignore` rule for `.scratch` or `.scratch/` exits non-zero with a clear error before scanning tickets.
2. Running `opencode-afk` in a repo with ignored `.scratch/` but tracked `.scratch/**` files exits non-zero with a clear error that names the tracked-file problem.
3. Tracked-file validation includes `.scratch/.opencode-afk-logs/**`, not just issue files.
4. Running `opencode-afk` where `.scratch` is absent still exits 0 with the existing warning/no-op behavior.
5. Running `opencode-afk` where `.scratch` is ignored and untracked proceeds to normal ticket discovery behavior.

## Verification

- Automated code tests to add/run:
  - Add fixture cases for missing `.scratch`, ignored/untracked `.scratch`, unignored `.scratch`, tracked `.scratch/issues/...`, and tracked `.scratch/.opencode-afk-logs/...`.
  - Run `sh -n bin/opencode-afk`.
  - Run `sh -n bin/opencode-afk-verify-dependency-fixtures`.
  - Run `bin/opencode-afk-verify-dependency-fixtures` and confirm the new scratch validation cases pass.
- Evidence expected: passing shell syntax checks plus fixture output showing the scratch validation matrix succeeds.

## Classification

- Executor: `AFK`
- Rationale: The behavior, seams, and verification cases are fully specified and require no human product decision.
