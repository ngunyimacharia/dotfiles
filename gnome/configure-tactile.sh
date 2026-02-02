#!/bin/bash

# Configure Tactile Extension Settings
echo "Configuring Tactile window tiling..."

# Set 4-column layout: [1, 2, 1, 0] columns
gsettings set org.gnome.shell.extensions.tactile column-count 4
gsettings set org.gnome.shell.extensions.tactile column-sizes '[1, 2, 1, 0]'

# Set gap size between windows
gsettings set org.gnome.shell.extensions.tactile gap-size 32

# Enable keyboard shortcuts (Super+T W S for tiling)
gsettings set org.gnome.shell.extensions.tactile enable-shortcuts true

echo "Tactile configured!"