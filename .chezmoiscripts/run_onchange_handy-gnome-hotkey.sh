#!/bin/sh
# Chezmoi on-change script to set Handy GNOME hotkey

set -e

echo "Applying Handy GNOME hotkey..."

if [ "$(uname)" != "Linux" ]; then
  echo "Not Linux; skipping."
  exit 0
fi

if ! command -v gsettings >/dev/null 2>&1; then
  echo "gsettings not available; skipping."
  exit 0
fi

if [ -n "${CHEZMOI_SOURCE_DIR:-}" ]; then
  script_path="$CHEZMOI_SOURCE_DIR/bin/handy-gnome-hotkey"
else
  script_path="$(cd "$(dirname "$0")" && pwd)/bin/handy-gnome-hotkey"
fi

if [ ! -x "$script_path" ]; then
  echo "Handy hotkey script not found; skipping."
  exit 0
fi

"$script_path"
status=$?

if [ $status -eq 0 ]; then
  echo "Handy GNOME hotkey applied."
else
  echo "Handy GNOME hotkey failed with status $status."
  exit $status
fi
