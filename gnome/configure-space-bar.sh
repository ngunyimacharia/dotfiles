#!/bin/bash

# Configure Space Bar Extension Settings
echo "Configuring Space Bar workspace management..."

# Disable smart workspace names
gsettings set org.gnome.shell.extensions.space-bar smart-workspace-names false

# Enable move-to-workspace shortcuts
gsettings set org.gnome.shell.extensions.space-bar enable-move-to-workspace-shortcuts true

# Disable workspace activation shortcuts (manual control)
gsettings set org.gnome.shell.extensions.space-bar enable-workspace-activation-shortcuts false

# Show workspace indicator
gsettings set org.gnome.shell.extensions.space-bar show-workspace-indicator true

echo "Space Bar configured!"