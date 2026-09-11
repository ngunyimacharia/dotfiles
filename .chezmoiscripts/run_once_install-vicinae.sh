#!/bin/sh
# Install Vicinae, the Linux launcher, and wire up the parts its own installer
# misses on a user-prefix install.
#
# Vicinae is the Raycast stand-in on Linux: same idea, same extension API
# shape, separate implementation. It is not Raycast and its config is not
# portable from the Mac; the shared piece between the two machines is the
# keybinding, which .chezmoidata/keybindings.toml puts on Alt+space for both.
#
# Installed under ~/.local rather than /usr/local on purpose. The upstream
# installer's root path also grants cap_dac_override to a helper binary and
# loads the uinput kernel module, which is how it simulates keystrokes for
# snippet expansion and paste. That is more access than a launcher needs
# here, so the user-prefix install skips it. The cost is that snippet
# expansion and paste emulation do not work.
#
# run_once_ because it is a network install of a ~50 MB AppImage. Re-running
# it by hand upgrades in place.
#
# Worth knowing: upstream publishes no checksum or signature for the AppImage,
# and the install script verifies nothing beyond HTTPS. Telemetry is on by
# default and is turned off below. Raycast-style extensions run with full
# Node.js access and no sandbox, so treat installing one like installing an
# npm package.

set -eu

[ "$(uname)" = "Linux" ] || exit 0

PREFIX="$HOME/.local"
EXT_UUID="vicinae@dagimg-dot"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl not found; skipping Vicinae install"
  exit 0
fi

if [ -x "$PREFIX/bin/vicinae" ]; then
  echo "Vicinae already installed ($("$PREFIX/bin/vicinae" version 2>/dev/null | head -1))"
else
  echo "Installing Vicinae..."
  installer=$(mktemp)
  if ! curl -fsSL https://vicinae.com/install -o "$installer"; then
    rm -f "$installer"
    echo "Could not download the Vicinae installer; skipping"
    exit 0
  fi
  # Upstream's installer is bash, not POSIX sh, and calls tput.
  if ! TERM="${TERM:-xterm}" bash "$installer" --prefix "$PREFIX" >/dev/null 2>&1; then
    rm -f "$installer"
    echo "Vicinae install failed; skipping"
    exit 0
  fi
  rm -f "$installer"
  echo "Vicinae installed to $PREFIX"
fi

# The installer drops its unit in $PREFIX/lib/systemd/user, which systemd does
# not search. Its user unit path is ~/.config/systemd/user and
# ~/.local/share/systemd/user, so link it into one of those or
# "systemctl --user enable vicinae" fails with "unit file does not exist".
unit_src="$PREFIX/lib/systemd/user/vicinae.service"
unit_dst="$HOME/.local/share/systemd/user/vicinae.service"
if [ -f "$unit_src" ] && [ ! -e "$unit_dst" ]; then
  mkdir -p "$(dirname "$unit_dst")"
  ln -sf "$unit_src" "$unit_dst"
  echo "Linked vicinae.service onto systemd's user unit path"
fi

if command -v systemctl >/dev/null 2>&1; then
  systemctl --user daemon-reload >/dev/null 2>&1 || true
  systemctl --user enable vicinae --now >/dev/null 2>&1 ||
    echo "Could not start vicinae.service; check 'journalctl --user -u vicinae'"
fi

# Telemetry ships on. It reports a per-install UUID, desktop, version, display
# protocol, architecture, OS, locale, resolution, chassis and kernel once a day.
settings="$HOME/.config/vicinae/settings.json"
if [ -f "$settings" ] && command -v python3 >/dev/null 2>&1; then
  python3 - "$settings" <<'PYEOF'
import json
import sys

path = sys.argv[1]
raw = open(path).read()
# The file is JSONC: a comment header, then the object. Parse only the object
# so the header survives a rewrite.
start = raw.find("{")
if start == -1:
    sys.exit(0)
header, body = raw[:start], raw[start:]
try:
    data = json.loads(body)
except ValueError:
    sys.exit(0)
if data.get("telemetry", {}).get("system_info") is False:
    sys.exit(0)
data.setdefault("telemetry", {})["system_info"] = False
open(path, "w").write(header + json.dumps(data, indent=3) + "\n")
print("Disabled Vicinae telemetry")
PYEOF
fi

# Clipboard history and window management reach Vicinae over D-Bus from a
# companion Shell extension. Without it those degrade, because a Wayland client
# cannot read the clipboard continuously or touch other windows on its own.
if command -v gnome-extensions >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
  if [ ! -d "$HOME/.local/share/gnome-shell/extensions/$EXT_UUID" ]; then
    shell_major=$(gnome-shell --version 2>/dev/null | awk '{print $3}' | cut -d. -f1)
    tag=$(curl -fsSL -H "User-Agent: chezmoi-installer/1.0" \
      "https://extensions.gnome.org/extension-info/?uuid=$EXT_UUID" 2>/dev/null |
      python3 -c "
import json
import sys

try:
    data = json.load(sys.stdin)
except ValueError:
    sys.exit(0)
entry = data.get('shell_version_map', {}).get('${shell_major}')
if entry:
    print(entry.get('version_tag') or entry.get('pk') or '')
" 2>/dev/null || true)
    if [ -n "$tag" ]; then
      zip=$(mktemp)
      if curl -fsSL "https://extensions.gnome.org/download-extension/${EXT_UUID}.shell-extension.zip?version_tag=${tag}" -o "$zip"; then
        gnome-extensions install --force "$zip" >/dev/null 2>&1 &&
          echo "Installed the Vicinae Shell extension"
      fi
      rm -f "$zip"
    else
      echo "No Vicinae Shell extension build for GNOME $shell_major; skipping"
    fi
  fi

  # Same story as User Themes: a freshly installed extension is invisible to
  # gnome-extensions until the Shell rescans, and Wayland cannot restart the
  # Shell without a logout. Write the key directly so it loads at next login.
  if [ -d "$HOME/.local/share/gnome-shell/extensions/$EXT_UUID" ]; then
    gnome-extensions enable "$EXT_UUID" 2>/dev/null || python3 - "$EXT_UUID" <<'PYEOF'
import ast
import subprocess
import sys

uuid = sys.argv[1]
raw = subprocess.run(
    ["gsettings", "get", "org.gnome.shell", "enabled-extensions"],
    capture_output=True, text=True, check=True,
).stdout.strip()
enabled = [] if raw in ("@as []", "") else ast.literal_eval(raw)
if uuid in enabled:
    sys.exit(0)
enabled.append(uuid)
subprocess.run(
    ["gsettings", "set", "org.gnome.shell", "enabled-extensions",
     "[" + ", ".join("'%s'" % item for item in enabled) + "]"],
    check=True,
)
print("Vicinae extension enabled; it loads at next login.")
PYEOF
  fi
fi

echo "Vicinae ready. Alt+space toggles it once you have logged out and back in."
