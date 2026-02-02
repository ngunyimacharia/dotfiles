#!/bin/bash

# Configure Just Perfection Extension Settings
echo "Configuring Just Perfection UI customization..."

# Animation speed: 2 (fast)
gsettings set org.gnome.shell.extensions.just-perfection animation-speed 2

# Show running apps in dash
gsettings set org.gnome.shell.extensions.just-perfection show-running-apps true

# Show workspace switcher
gsettings set org.gnome.shell.extensions.just-perfection show-workspace-switcher true

# Disable workspace popup
gsettings set org.gnome.shell.extensions.just-perfection disable-workspace-popup false

# Show app grid icon
gsettings set org.gnome.shell.extensions.just-perfection show-app-grid-icon true

echo "Just Perfection configured!"