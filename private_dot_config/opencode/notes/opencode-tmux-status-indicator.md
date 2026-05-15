# OpenCode tmux status mapping evidence

Source of truth:
- OpenCode plugin docs list `session.status` and `session.idle` as the relevant session hooks.
- Generated SDK types define `SessionStatus` as `idle | retry | busy`.
- Live probe session: `ses_1d3af481effeW2DIu0VP2vEgAj` from `/var/folders/r7/fdg697857h31gn_d8h8fkmch0000gn/T/opencode/event-probe`.

Verified mapping:
- Running: `session.status` with `status.type === "busy"`.
- Waiting: `session.status` with `status.type === "retry"`.
- Idle/done: `session.idle` remains the terminal completion event; `session.status` with `status.type === "idle"` also appears, but the shipped mapper and notifier still use `session.idle` as the completion signal.

Evidence from the probe log:
- `session.status` published with `status.type: "busy"` during the active model turn.
- `session.status` published with `status.type: "idle"` immediately before `session.idle`.
- No guessed event names were used.

Cleanup behavior:
- There is no documented dedicated plugin shutdown hook.
- Closest safe cleanup is JS runtime teardown hooks such as `process.on("exit")` plus signal handlers, but async cleanup is not guaranteed.
- In the probe, `process.exit` fired after `server.instance.disposed`; `beforeExit`, `SIGINT`, and `SIGTERM` did not fire, so stale state remains possible on hard termination.
