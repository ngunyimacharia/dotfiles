#!/bin/sh

# Setup inotify limits for Syncthing and other file watchers
# This prevents "failed to setup inotify handler" errors

SYSCTL_CONF="/etc/sysctl.d/90-inotify.conf"

# Check if running on Linux
if [ "$(uname)" != "Linux" ]; then
    echo "Skipping inotify setup (not on Linux)"
    exit 0
fi

# Check if already configured
if [ -f "$SYSCTL_CONF" ]; then
    if grep -q "fs.inotify.max_user_watches=524288" "$SYSCTL_CONF" 2>/dev/null; then
        echo "Inotify limits already configured"
        exit 0
    fi
fi

echo "Setting up inotify limits..."

# Create sysctl configuration
echo "fs.inotify.max_user_watches=524288" | sudo tee -a "$SYSCTL_CONF" >/dev/null
echo "fs.inotify.max_user_instances=8192" | sudo tee -a "$SYSCTL_CONF" >/dev/null

# Apply the configuration
if sudo sysctl -p "$SYSCTL_CONF" >/dev/null 2>&1; then
    echo "✓ Inotify limits configured successfully"
    echo "  - max_user_watches: 524288"
    echo "  - max_user_instances: 8192"
else
    echo "✗ Failed to apply inotify limits. You may need to run manually:"
    echo "  sudo sysctl -p $SYSCTL_CONF"
    exit 1
fi
