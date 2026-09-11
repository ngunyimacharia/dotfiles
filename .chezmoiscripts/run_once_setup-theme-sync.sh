#!/bin/sh
# Share the active theme between machines through Syncthing.
#
# Creates a small Syncthing folder at ~/.local/share/dotfiles-sync holding one
# file, the name of the current theme, and enables the watcher that applies it
# when the other machine changes it.
#
# A dedicated folder rather than a corner of an existing one: theme state
# turning up in Documents would be a surprise, and this can be removed without
# touching anything that matters.
#
# Idempotent. It skips when the folder already exists, so it is safe to rerun
# by hand after adding a device.

set -eu

FOLDER_ID="dotfiles-state"
SYNC_DIR="$HOME/.local/share/dotfiles-sync"

if ! command -v python3 >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
  echo "theme-sync: needs python3 and curl; skipping"
  exit 0
fi

# Syncthing keeps its config in a different place on each OS.
for candidate in \
  "$HOME/Library/Application Support/Syncthing/config.xml" \
  "$HOME/.local/state/syncthing/config.xml" \
  "$HOME/.config/syncthing/config.xml"; do
  if [ -f "$candidate" ]; then
    CONFIG="$candidate"
    break
  fi
done

if [ -z "${CONFIG:-}" ]; then
  echo "theme-sync: no Syncthing config found; skipping"
  exit 0
fi

mkdir -p "$SYNC_DIR"

python3 - "$CONFIG" "$FOLDER_ID" "$SYNC_DIR" <<'PYEOF'
import json
import sys
import urllib.error
import urllib.request
import xml.etree.ElementTree as ET

config, folder_id, sync_dir = sys.argv[1], sys.argv[2], sys.argv[3]
root = ET.parse(config).getroot()

gui = root.find("gui")
api_key = gui.findtext("apikey")
address = gui.findtext("address") or "127.0.0.1:8384"
if not api_key:
    print("theme-sync: no Syncthing API key; skipping")
    sys.exit(0)

base = "http://%s/rest" % address


def call(path, payload=None):
    req = urllib.request.Request(base + path, method="POST" if payload else "GET")
    req.add_header("X-API-Key", api_key)
    data = None
    if payload is not None:
        data = json.dumps(payload).encode()
        req.add_header("Content-Type", "application/json")
    with urllib.request.urlopen(req, data, timeout=10) as fh:
        body = fh.read()
    return json.loads(body) if body else None


try:
    folders = call("/config/folders")
except (urllib.error.URLError, OSError) as exc:
    print("theme-sync: Syncthing API unreachable (%s); skipping" % exc)
    sys.exit(0)

if any(f["id"] == folder_id for f in folders):
    print("theme-sync: Syncthing folder already configured")
    sys.exit(0)

# Share with every device Syncthing already knows, this machine included. These
# are devices the user has already paired, so nothing new is being trusted.
devices = [d.get("id") for d in root.findall("device") if d.get("id")]
if len(devices) < 2:
    print("theme-sync: only one device known to Syncthing; nothing to sync with")
    sys.exit(0)

call("/config/folders", {
    "id": folder_id,
    "label": "Dotfiles State",
    "path": sync_dir,
    "type": "sendreceive",
    "devices": [{"deviceID": d} for d in devices],
    "rescanIntervalS": 10,
    "fsWatcherEnabled": True,
    "fsWatcherDelayS": 1,
})
print("theme-sync: Syncthing folder created, shared with %d devices" % len(devices))
PYEOF

# Enable the watcher that applies a theme the other machine chose.
if [ "$(uname)" = "Darwin" ]; then
  plist="$HOME/Library/LaunchAgents/dev.dotfiles.theme-sync.plist"
  if [ -f "$plist" ]; then
    launchctl unload "$plist" 2>/dev/null || true
    launchctl load "$plist" 2>/dev/null &&
      echo "theme-sync: launch agent loaded"
  fi
elif command -v systemctl >/dev/null 2>&1; then
  systemctl --user daemon-reload >/dev/null 2>&1 || true
  systemctl --user enable --now theme-sync.path >/dev/null 2>&1 &&
    echo "theme-sync: systemd path unit enabled"
fi
