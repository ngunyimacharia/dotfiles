Status: done

## Title

Run tmux, Nushell, and Starship multi-ticket verification

## Why

The original failure appears when `opencode-afk` launches multiple AFK ticket sessions from inside tmux while Nushell and Starship are active. The fix is not complete until the high-risk environment is exercised end to end and shows that prompt/color fragments can no longer corrupt helper startup.

## Scope

Includes:
- Verify the implemented tmux direct-command launch in a real tmux session where Nushell is the shell and Starship prompt rendering is enabled.
- Launch at least two selected AFK tickets from one `opencode-afk` run to exercise the multi-window automation path.
- Confirm no malformed prefixes such as `rgb:.../sh`, color path fragments, or other Starship/Nushell prompt fragments are prepended to the helper command.
- Confirm no `nu::shell::external_command` failure occurs because of corrupted helper startup.
- Confirm each selected ticket receives the correct helper and meta-file arguments through observable logs/sentinels/status behavior.
- Capture verification evidence in the implementation PR or issue comments.

Excludes:
- Depending on exact prompt color escape output or theme-specific Starship rendering.
- Reworking the implementation if a separate hold-open UX preference is discovered; log it as a follow-up unless it blocks required logging/sentinel/status behavior.
- Manual testing that only uses bash, zsh, or manually typed commands instead of the tmux + Nushell + Starship launch path.

## Context

- Parent PRD/spec: `.scratch/fix-opencode-afk-tmux-nushell-prompt-race/PRD.md`
- This is the highest-value verification path described by the PRD and should run after the direct tmux launch and lifecycle behavior are implemented.

## Dependencies

Blocking:
- `.scratch/fix-opencode-afk-tmux-nushell-prompt-race/issues/01-launch-tmux-helper-as-initial-command.md`
- `.scratch/fix-opencode-afk-tmux-nushell-prompt-race/issues/02-preserve-tmux-lifecycle-side-effects.md`

Related:
- `.scratch/fix-opencode-afk-tmux-nushell-prompt-race/issues/03-confirm-non-tmux-background-mode-unchanged.md`

## Acceptance Criteria

1. From inside tmux with Nushell and Starship active, one `opencode-afk` invocation launches at least two selected AFK tickets into separate named tmux windows.
2. Each launched ticket starts through the helper initial command path and does not rely on typed input into an interactive Nushell prompt.
3. No selected ticket fails at startup with a Nushell `nu::shell::external_command` error caused by a malformed prompt/color prefix before `sh`.
4. Logs under `.scratch/.opencode-afk-logs` exist for each launched ticket and contain useful startup/output information.
5. Done or failed sentinels are created according to each helper outcome.
6. Successful tickets still transition to done using the existing status update behavior.
7. Verification evidence records the environment used, the number of tickets launched, and the observed absence of prompt/color command corruption.

## Verification

- Start a real tmux session configured to use Nushell, with Starship enabled in the Nushell prompt.
- Ensure at least two eligible AFK issue files are available with `Status: ready-for-agent` or AFK executor metadata.
- Run `opencode-afk` from inside that tmux session and select at least two tickets.
- Inspect tmux panes, logs, and sentinel files to confirm each ticket launched correctly and no corrupted command prefix appeared.
- Search captured logs/output for `nu::shell::external_command`, `rgb:`, and representative malformed `/sh` prefixes; absence of the original corruption is the expected evidence, not exact prompt color matching.
- Record evidence in the implementation PR or issue comments: command/session used, ticket count, log/sentinel paths checked, and status update results.

## Classification

- Executor: `AFK`
- Rationale: The required environment and expected observations are specified; a coding agent or maintainer can execute the verification without additional product decisions.

## Comments

- Verified in a detached tmux session (`tmux -L afkverify`) with Nushell and Starship active, using a temporary `XDG_CONFIG_HOME` that loads `starship init nu`.
- Launched two AFK tickets in one `opencode-afk --model default` run and observed separate tmux windows for `tmux-afk-verification/01-alpha` and `tmux-afk-verification/02-beta`.
- Confirmed `.scratch/.opencode-afk-logs/tmux-afk-verification-01-alpha.log` and `tmux-afk-verification-02-beta.log` were created, with matching `.done` sentinels and correct `.meta` ticket/log paths.
- Searched the captured logs for `nu::shell::external_command`, `rgb:`, and malformed `/sh` prefixes; no corruption markers were present.
