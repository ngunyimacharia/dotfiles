#!/bin/sh
# GNOME desktop settings that the theme switcher does not own.
#
# Anything that changes per light/dark mode lives in bin/switch-theme instead
# (color-scheme, gtk-theme, shell theme, icons, wallpaper). This script only
# sets the things that are true in both modes.

set -e

if [ "$(uname)" != "Linux" ] || ! command -v gsettings >/dev/null 2>&1; then
  echo "Not a GNOME desktop, skipping GNOME configuration."
  exit 0
fi

# Keybindings are not set here. They come from .chezmoidata/keybindings.toml
# through run_onchange_gnome-keybindings.sh. Two scripts writing the same
# gsettings keys would fight.
echo "Applying GNOME desktop settings..."

gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.interface monospace-font-name "CaskaydiaMono Nerd Font 10"
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# The User Themes extension is the only supported way to load a custom GNOME
# Shell stylesheet. Without it, ~/.themes/everforest-*/gnome-shell/gnome-shell.css
# is never read and the top bar stays stock. It ships in the gnome-shell-extensions
# package, which the Ubuntu package script installs.
USER_THEME_UUID="user-theme@gnome-shell-extensions.gcampax.github.com"

# gnome-extensions enable only knows about extensions the running Shell has
# already scanned. Right after the package is installed it reports "does not
# exist", and on Wayland the Shell cannot be restarted without logging out. So
# fall back to writing the enabled-extensions key directly, which the Shell
# picks up at next login either way.
enable_user_theme() {
  if gnome-extensions enable "$USER_THEME_UUID" 2>/dev/null; then
    echo "User Themes extension enabled."
    return 0
  fi

  python3 - "$USER_THEME_UUID" <<'PYEOF'
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
    print("User Themes already in enabled-extensions.")
    sys.exit(0)

enabled.append(uuid)
value = "[" + ", ".join("'%s'" % item for item in enabled) + "]"
subprocess.run(
    ["gsettings", "set", "org.gnome.shell", "enabled-extensions", value],
    check=True,
)
print("User Themes added to enabled-extensions; it loads at next login.")
PYEOF
}

if [ -d /usr/share/gnome-shell/extensions/"$USER_THEME_UUID" ] ||
  [ -d "$HOME/.local/share/gnome-shell/extensions/$USER_THEME_UUID" ]; then
  if command -v python3 >/dev/null 2>&1; then
    enable_user_theme
  else
    gnome-extensions enable "$USER_THEME_UUID" 2>/dev/null ||
      echo "User Themes is installed but could not be enabled; log out and back in."
  fi
else
  echo "User Themes extension not installed yet."
  echo "  Run: sudo apt install gnome-shell-extensions"
  echo "  Then log out and back in, and rerun 'chezmoi apply'."
fi

echo "GNOME configuration updated."
