#!/bin/bash

# Configure TopHat Extension Settings
echo "Configuring TopHat system monitoring..."

# Minimal configuration: only network usage shown
gsettings set org.gnome.shell.extensions.tophat show-network true
gsettings set org.gnome.shell.extensions.tophat show-cpu false
gsettings set org.gnome.shell.extensions.tophat show-disk false
gsettings set org.gnome.shell.extensions.tophat show-memory false
gsettings set org.gnome.shell.extensions.tophat show-filesystem false

# Network display in bits per second
gsettings set org.gnome.shell.extensions.tophat network-unit 'bits'

# Position in top bar
gsettings set org.gnome.shell.extensions.tophat position 'right'

echo "TopHat configured!"