#!/bin/sh

set -e

# Exit if not running on Linux
if [ "$(uname)" != "Linux" ]; then
  exit 0
fi

SYNC_USER=${USER:-$(id -un)}
SERVICE_NAME="syncthing@${SYNC_USER}.service"
SERVICE_SOURCE=$(chezmoi source-path systemd/syncthing@.service 2>/dev/null || true)

if [ -z "$SERVICE_SOURCE" ] || [ ! -f "$SERVICE_SOURCE" ]; then
  SERVICE_SOURCE="$HOME/.local/share/chezmoi/systemd/syncthing@.service"
fi

if [ ! -f "$SERVICE_SOURCE" ]; then
  echo "Syncthing service template not found: $SERVICE_SOURCE"
  exit 1
fi

if ! sudo -v; then
  echo "Sudo access is required to configure the Syncthing system service"
  exit 1
fi

# Install and enable a per-user system service so Syncthing starts at boot.
sudo install -m 0644 "$SERVICE_SOURCE" /etc/systemd/system/syncthing@.service
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"

if command -v syncthing >/dev/null 2>&1; then
  sudo systemctl start "$SERVICE_NAME"
  echo "Syncthing service $SERVICE_NAME has been enabled and started"
else
  echo "Syncthing service $SERVICE_NAME has been enabled and will start after Syncthing is installed"
fi
