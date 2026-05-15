Status: done

## Title

Confirm non-tmux background mode remains unchanged

## Why

The prompt race fix is scoped to tmux mode. Users running `opencode-afk` outside tmux should keep the existing background-process behavior, including concurrency limits and non-streaming helper logging.

## Scope

Includes:
- Verify that when `$TMUX` is not set, `opencode-afk` still launches each selected ticket with `nohup sh "$HELPER" "$meta_file"` or the existing equivalent background-process pattern.
- Preserve the existing `MAX_CONCURRENT` background concurrency behavior.
- Preserve `STREAM_OUTPUT=0` outside tmux so helper output is written through the log path rather than streamed to a tmux pane.
- Preserve non-tmux PID tracking and cleanup behavior.
- Confirm the tmux direct-command launch change does not alter ticket selection, model handling, prompt loading, commit-context capture, status detection, or final launch summary outside tmux.

Excludes:
- Changing the non-tmux launch mechanism.
- Adding new non-tmux UX, retry, or status behavior.
- Verifying the Nushell/Starship tmux prompt race; that is covered by the tmux verification issue.

## Context

- Parent PRD/spec: `.scratch/fix-opencode-afk-tmux-nushell-prompt-race/PRD.md`
- This issue can be completed independently of the tmux implementation because it verifies that the non-tmux path remains isolated from the tmux-only fix.

## Dependencies

Blocking:
- none

Related:
- `.scratch/fix-opencode-afk-tmux-nushell-prompt-race/issues/01-launch-tmux-helper-as-initial-command.md`

## Acceptance Criteria

1. Running `opencode-afk` outside tmux still reports `No tmux detected: launching tickets as background processes`.
2. Selected tickets outside tmux are still launched as background helper processes rather than tmux windows.
3. Outside tmux, `STREAM_OUTPUT=0` is written to each selected ticket's meta file.
4. The existing background concurrency limit remains in effect.
5. Non-tmux logs and sentinels are still written under `.scratch/.opencode-afk-logs` using the existing paths.
6. Non-tmux interrupt cleanup still kills tracked background PIDs when applicable.
7. No tmux-only direct-command changes alter ticket selection, model selection, prompt loading, or launch summary behavior outside tmux.

## Verification

- Run `opencode-afk` from a shell where `$TMUX` is unset with multiple safe eligible AFK tickets selected.
- Confirm helper processes are launched in the background and no tmux windows are created.
- Confirm each non-tmux meta file has `STREAM_OUTPUT="0"`.
- Confirm logs and sentinels appear under `.scratch/.opencode-afk-logs`.
- If practical, select more tickets than `MAX_CONCURRENT` and confirm no more than the configured number run concurrently.
- Run `chezmoi diff` after changes to verify only intended script changes are present.

## Classification

- Executor: `AFK`
- Rationale: This is a concrete regression check of existing behavior and requires no human product decision.

## Comments

- Verified `bin/opencode-afk` keeps the non-tmux branch unchanged: it still reports background-process mode, writes `STREAM_OUTPUT="0"` into the meta file, uses the existing `MAX_CONCURRENT` gate, launches with `nohup sh`, and tracks PIDs for cleanup. `sh -n bin/opencode-afk` passed.
