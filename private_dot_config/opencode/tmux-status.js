const isTmux = () => Boolean(process.env.TMUX)

const runHelper = async ($, tmuxTarget, action, state) => {
  if (!isTmux()) return

  try {
    if (action === "clear") {
      await $`env OPENCODE_TMUX_TARGET=${tmuxTarget ?? ""} opencode-tmux-status clear`
    } else if (state === "running") {
      await $`env OPENCODE_TMUX_TARGET=${tmuxTarget ?? ""} opencode-tmux-status set running`
    } else if (state === "waiting") {
      await $`env OPENCODE_TMUX_TARGET=${tmuxTarget ?? ""} opencode-tmux-status set waiting`
    } else if (state === "idle") {
      await $`env OPENCODE_TMUX_TARGET=${tmuxTarget ?? ""} opencode-tmux-status set idle`
    }
  } catch {
    // Best effort only; OpenCode disposal can be synchronous and hard exits can skip cleanup.
  }
}

const setStatus = async ($, tmuxTarget, state) => {
  await runHelper($, tmuxTarget, "set", state)
}

const clearStatus = async ($, tmuxTarget) => {
  await runHelper($, tmuxTarget, "clear")
}

export const TmuxStatusPlugin = async ({ $, api } = {}) => {
  const tmuxTarget = process.env.OPENCODE_TMUX_TARGET || process.env.TMUX_PANE
  const onDispose = api?.lifecycle?.onDispose

  if (typeof onDispose === "function") {
    onDispose(() => {
      void clearStatus($, tmuxTarget)
    })
  } else if (typeof process !== "undefined" && typeof process.on === "function") {
    process.on("exit", () => {
      void clearStatus($, tmuxTarget)
    })
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.status") {
        const status = event.properties?.status

        if (status?.type === "busy") {
          await setStatus($, tmuxTarget, "running")
        } else if (status?.type === "retry") {
          await setStatus($, tmuxTarget, "waiting")
        }
        return
      }

      if (event.type === "session.idle") {
        await setStatus($, tmuxTarget, "idle")
      }
    },
  }
}
