#!/bin/sh

# Spotify setup: Ensure Flatpak version is installed on Fedora

# Exit if not running on Fedora
if [ ! -f /etc/os-release ] || ! grep -q "^ID=fedora" /etc/os-release; then
  echo "Not on Fedora, skipping Spotify setup"
  exit 0
fi

echo "Setting up Spotify via Flatpak on Fedora..."

# Check if Flatpak is available
if ! command -v flatpak >/dev/null 2>&1; then
    echo "Flatpak not found, installing..."
    sudo dnf install -y flatpak
    if [ $? -ne 0 ]; then
        echo "Failed to install Flatpak"
        exit 1
    fi
fi

# Add Flathub repository if not already added
if ! flatpak remotes | grep -q flathub; then
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install Spotify via Flatpak if not already installed
if ! flatpak list | grep -q com.spotify.Client; then
    echo "Installing Spotify via Flatpak..."
    flatpak install -y flathub com.spotify.Client
    if [ $? -eq 0 ]; then
        echo "Successfully installed Spotify via Flatpak"
    else
        echo "Failed to install Spotify via Flatpak"
        exit 1
    fi
else
    echo "Spotify Flatpak already installed"
fi

echo "Spotify setup complete!"