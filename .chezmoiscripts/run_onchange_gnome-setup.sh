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

echo "Applying GNOME desktop settings..."

gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.interface monospace-font-name "CaskaydiaMono Nerd Font 10"
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# Alt+Tab walks individual windows rather than grouping them per application.
# GNOME's default groups by app and then needs Alt+` to reach a second window
# of the same app, which is the wrong shape for a tiling-style workflow. The
# popup this drives is the one themed by ~/.themes/everforest-*/gnome-shell.
echo "Rebinding Alt+Tab to switch windows instead of applications..."
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

# The User Themes extension is the only supported way to load a custom GNOME
# Shell stylesheet. Without it, ~/.themes/everforest-*/gnome-shell/gnome-shell.css
# is never read and the top bar stays stock. It ships in the gnome-shell-extensions
# package, which the Ubuntu package script installs.
USER_THEME_UUID="user-theme@gnome-shell-extensions.gcampax.github.com"
if command -v gnome-extensions >/dev/null 2>&1; then
  if gnome-extensions list 2>/dev/null | grep -qx "$USER_THEME_UUID"; then
    if gnome-extensions enable "$USER_THEME_UUID" 2>/dev/null; then
      echo "User Themes extension enabled."
    else
      echo "User Themes is installed but could not be enabled; log out and back in, then rerun."
    fi
  else
    echo "User Themes extension not installed yet."
    echo "  Run: sudo apt install gnome-shell-extensions"
    echo "  Then log out and back in, and rerun 'chezmoi apply'."
  fi
fi

echo "GNOME configuration updated."
