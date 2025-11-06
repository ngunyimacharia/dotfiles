#!/bin/sh

# Exit if not running on Fedora
if [ ! -f /etc/os-release ] || ! grep -q "^ID=fedora" /etc/os-release; then
  echo "Not on Fedora, skipping Fedora package installation"
  exit 0
fi

echo "Installing packages for Fedora..."

# Enable RPM Fusion repositories (needed for many packages)
if ! dnf repolist | grep -q "rpmfusion"; then
  echo "Enabling RPM Fusion repositories..."
  sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

# Enable Flathub repository for Flatpak apps
if ! flatpak remotes | grep -q flathub; then
  echo "Adding Flathub repository..."
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi



# Development Tools

# valet-linux-plus dependencies
composer global show "cpriego/valet-linux" >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing valet-linux-plus dependencies..."
  sudo dnf install -y curl nss-tools jq xsel openssl ca-certificates
  composer global require cpriego/valet-linux
else
  echo "valet-linux-plus is already installed"
fi

# Utilities
if ! rpm -q xclip; then
  echo "Installing xclip..."
  sudo dnf install -y xclip
else
  echo "xclip is already installed."
fi

if ! rpm -q fuse; then
  echo "Installing fuse..."
  sudo dnf install -y fuse
else
  echo "fuse is already installed."
fi

if ! rpm -q variety; then
  echo "Installing Variety wallpaper manager..."
  sudo dnf install -y variety
else
  echo "Variety is already installed."
fi

# Syncthing
if ! rpm -q syncthing; then
  echo "Installing Syncthing..."
  # Add Syncthing repository
  sudo curl -L -o /etc/yum.repos.d/syncthing.repo https://syncthing.net/release-key.repo
  sudo dnf install -y syncthing
else
  echo "Syncthing is already installed."
fi

# Wireguard VPN
if ! rpm -q wireguard-tools; then
  echo "Installing Wireguard VPN client..."
  sudo dnf install -y wireguard-tools systemd-resolved
  # Enable and start systemd-resolved service
  sudo systemctl enable systemd-resolved
  sudo systemctl start systemd-resolved
else
  echo "Wireguard is already installed."
fi

# Set up Wireguard configuration from 1Password if it doesn't exist
echo "Sudo access is required to check Wireguard configuration."
if ! test -f "/etc/wireguard/wg0.conf"; then
  sudo mkdir -p /etc/wireguard
  echo "Setting up Wireguard configuration..."
  WIREGUARD_CONF=$(op read "op://private/wiregard-conf/kdg.conf" 2>/dev/null)

  if [ $? -eq 0 ] && [ -n "$WIREGUARD_CONF" ]; then
    echo "$WIREGUARD_CONF" | sudo tee /etc/wireguard/wg0.conf >/dev/null
    sudo chmod 600 /etc/wireguard/wg0.conf
    echo "Wireguard configuration installed successfully."
  else
    echo "Failed to fetch Wireguard configuration from 1Password or 1Password CLI not available."
  fi
else
  echo "Wireguard configuration already exists."
fi



# Development Tools



# Install Golang
if ! command -v go >/dev/null 2>&1; then
  echo "Installing Golang..."
  sudo dnf install -y golang
else
  echo "Golang is already installed."
fi

# Install ripgrep
if ! rpm -q ripgrep; then
  echo "Installing ripgrep..."
  sudo dnf install -y ripgrep
else
  echo "ripgrep is already installed."
fi

# Install Spotify via Flatpak
if ! flatpak list | grep -q "com.spotify.Client"; then
  echo "Installing Spotify..."
  flatpak install -y flathub com.spotify.Client
else
  echo "Spotify is already installed."
fi

# Install Obsidian via Flatpak
if ! flatpak list | grep -q "md.obsidian.Obsidian"; then
  echo "Installing Obsidian..."
  flatpak install -y flathub md.obsidian.Obsidian
else
  echo "Obsidian is already installed."
fi

# Install Neovim
if ! rpm -q neovim; then
  echo "Installing Neovim..."
  sudo dnf install -y neovim
else
  echo "Neovim is already installed."
fi

# Install Postman via Flatpak
if ! flatpak list | grep -q "com.getpostman.Postman"; then
  echo "Installing Postman..."
  flatpak install -y flathub com.getpostman.Postman
else
  echo "Postman is already installed."
fi

# Install ngrok
if ! rpm -q ngrok; then
  echo "Installing ngrok..."
  # Add ngrok repository
  curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.repo | sudo tee /etc/yum.repos.d/ngrok.repo
  sudo dnf install -y ngrok
else
  echo "ngrok is already installed."
fi

# Install Stripe CLI
which stripe >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing Stripe CLI..."
  # Add Stripe repository
  echo "[stripe-cli]
name=stripe-cli
baseurl=https://packages.stripe.dev/stripe-cli-rpm-local/
enabled=1
gpgcheck=1
gpgkey=https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public" | sudo tee /etc/yum.repos.d/stripe-cli.repo
  sudo dnf install -y stripe
else
  echo "Stripe CLI is already installed."
fi

# Browsers
if ! rpm -q google-chrome-stable; then
  echo "Installing Google Chrome..."
  # Add Google Chrome repository
  sudo dnf install -y fedora-workstation-repositories
  sudo dnf config-manager --set-enabled google-chrome
  sudo dnf install -y google-chrome-stable
else
  echo "Google Chrome is already installed."
fi

if ! flatpak list | grep -q "io.github.zen_browser.zen"; then
  echo "Installing Zen Browser..."
  flatpak install -y flathub io.github.zen_browser.zen
else
  echo "Zen Browser is already installed."
fi

# Password Manager
if ! rpm -q 1password; then
  echo "Installing 1Password..."
  # Add 1Password repository
  sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
  sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
  sudo dnf install -y 1password 1password-cli
else
  echo "1Password is already installed."
fi



# Install lazygit
which lazygit >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing lazygit..."
  sudo dnf copr enable -y atim/lazygit
  sudo dnf install -y lazygit
else
  echo "lazygit is already installed."
fi

# Install Zellij
which zellij >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing Zellij..."
  sudo dnf install -y zellij
else
  echo "Zellij is already installed."
fi

# Communication tools



# Install Slack via Flatpak
if ! flatpak list | grep -q "com.slack.Slack"; then
  echo "Installing Slack..."
  flatpak install -y flathub com.slack.Slack
else
  echo "Slack is already installed."
fi

# Install Discord via Flatpak
if ! flatpak list | grep -q "com.discordapp.Discord"; then
  echo "Installing Discord..."
  flatpak install -y flathub com.discordapp.Discord
else
  echo "Discord is already installed."
fi

# Check for NVM installation
if [ -d "$HOME/.nvm" ]; then
  echo "NVM is already installed."
else
  echo "Installing NVM..."
  # Install NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

  # Load NVM immediately for the rest of the script
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # Install latest LTS version of Node
  nvm install --lts
  nvm use --lts
fi

# Check for npm installation
if command -v npm >/dev/null 2>&1; then
  echo "npm is already installed"
else
  echo "Installing npm..."
  sudo dnf install -y npm
fi

# Install freeze (code screenshot tool)
which freeze >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "freeze already installed."
else
  echo "Installing freeze..."
  # Use go install since there's no RPM package
  if command -v go >/dev/null 2>&1; then
    go install github.com/charmbracelet/freeze@latest
    echo "freeze installed via go install"
  else
    echo "Freeze requires Go to be installed. Opening browser for manual download..."
    xdg-open https://github.com/charmbracelet/freeze/releases &
    disown
  fi
fi

# Install Beekeeper Studio via Flatpak
if ! flatpak list | grep -q "io.beekeeperstudio.Studio"; then
  echo "Installing Beekeeper Studio..."
  flatpak install -y flathub io.beekeeperstudio.Studio
else
  echo "Beekeeper Studio is already installed."
fi

# Install Android Studio via Flatpak
if ! flatpak list | grep -q "com.google.AndroidStudio"; then
  echo "Installing Android Studio..."
  flatpak install -y flathub com.google.AndroidStudio
else
  echo "Android Studio is already installed."
fi

# Install Ghostty via Flatpak
if ! flatpak list | grep -q "com.mitchellh.ghostty"; then
  echo "Installing Ghostty..."
  flatpak install -y flathub com.mitchellh.ghostty
else
  echo "Ghostty is already installed."
fi

# Install LocalSend via Flatpak
if ! flatpak list | grep -q "org.localsend.localsend_app"; then
  echo "Installing LocalSend..."
  flatpak install -y flathub org.localsend.localsend_app
else
  echo "LocalSend is already installed."
fi

# Install OpenCode
which opencode >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "OpenCode already installed."
else
  echo "Installing OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
fi

echo "Fedora package installation complete!"