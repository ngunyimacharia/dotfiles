#!/bin/sh

# Exit if not running on Linux
if [ "$(uname)" != "Linux" ]; then
  exit 0
fi

# Check if syncthing service is already enabled
if systemctl is-enabled syncthing >/dev/null 2>&1; then
  echo "Syncthing service is already enabled"
  exit 0
fi

# Copy service file
sudo cp ~/.dotfiles/systemd/syncthing.service /etc/systemd/system/syncthing.service

# Enable service
sudo systemctl daemon-reload
systemctl enable syncthing
systemctl start syncthing

echo "Syncthing service has been enabled and started"
