#!/bin/bash

# Configure Blur My Shell Extension Settings
echo "Configuring Blur My Shell visual effects..."

# Enable overview blur
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview brightness 80
gsettings set org.gnome.shell.extensions.blur-my-shell.overview sigma 30
gsettings set org.gnome.shell.extensions.blur-my-shell.overview style 'default'

# Enable dash-to-dock blur
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 60
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style 'static'

# Disable blur for specific components
gsettings set org.gnome.shell.extensions.blur-my-shell.app-folder blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false

echo "Blur My Shell configured!"