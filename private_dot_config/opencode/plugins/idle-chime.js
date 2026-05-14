let lastPlayedAt = 0

export const IdleChimePlugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type !== "session.idle") return

      const now = Date.now()
      if (now - lastPlayedAt < 1000) return
      lastPlayedAt = now

      try {
        await $`sh -c '
if command -v canberra-gtk-play >/dev/null 2>&1; then
  canberra-gtk-play -i complete -d opencode >/dev/null 2>&1 && exit 0
fi

if command -v paplay >/dev/null 2>&1; then
  for sound in \
    /usr/share/sounds/freedesktop/stereo/message.oga \
    /usr/share/sounds/freedesktop/stereo/complete.oga \
    /usr/share/sounds/freedesktop/stereo/bell.oga
  do
    if [ -f "$sound" ]; then
      paplay "$sound" >/dev/null 2>&1 && exit 0
    fi
  done
fi

printf "\\a" >/dev/tty 2>/dev/null || true
'`
      } catch {}
    },
  }
}
