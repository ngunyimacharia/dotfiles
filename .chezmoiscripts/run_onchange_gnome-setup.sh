#!/bin/sh
# Chezmoi on-change script for GNOME Extensions and Settings
# This runs when GNOME configuration files are applied

set -e

echo "🔄 Applying GNOME configuration changes..."
echo "Checking for GNOME desktop environment..."

# Only run on Linux with GNOME
if [ "$(uname)" = "Linux" ] && command -v gnome-shell &> /dev/null; then
    echo "GNOME desktop environment detected"
    
    # Apply GNOME optimizations
    echo "Applying GNOME desktop settings..."
    gsettings set org.gnome.mutter center-new-windows true
    gsettings set org.gnome.desktop.interface monospace-font-name "CaskaydiaMono Nerd Font 10"
    gsettings set org.gnome.desktop.calendar show-weekdate true
    gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
    echo "✅ GNOME configuration updated successfully!"
else
    echo "⚠️  GNOME not detected. Skipping GNOME configuration."
fi