const isTmux = () => Boolean(process.env.TMUX)

const runHelper = async ($, action, state) => {
  if (!isTmux()) return

  try {
    if (action === "clear") {
      await $`opencode-tmux-status clear`
    } else if (state === "running") {
      await $`opencode-tmux-status set running`
    } else if (state === "waiting") {
      await $`opencode-tmux-status set waiting`
    } else if (state === "idle") {
      await $`opencode-tmux-status set idle`
    }
  } catch {
    // Best effort only; OpenCode disposal can be synchronous and hard exits can skip cleanup.
  }
}

const setStatus = async ($, state) => {
  await runHelper($, "set", state)
}

const clearStatus = async ($) => {
  await runHelper($, "clear")
}

export const TmuxStatusPlugin = async ({ $, api } = {}) => {
  const onDispose = api?.lifecycle?.onDispose

  if (typeof onDispose === "function") {
    onDispose(() => {
      void clearStatus($)
    })
  } else if (typeof process !== "undefined" && typeof process.on === "function") {
    process.on("exit", () => {
      void clearStatus($)
    })
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.status") {
        if (event.status?.type === "busy") {
          await setStatus($, "running")
        } else if (event.status?.type === "retry") {
          await setStatus($, "waiting")
        }
        return
      }

      if (event.type === "session.idle") {
        await setStatus($, "idle")
      }
    },
  }
}
