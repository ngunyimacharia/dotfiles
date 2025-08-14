#!/bin/sh

# Exit if not running on Linux
if [ "$(uname)" != "Linux" ]; then
  echo "Not on Linux"
  exit 0
fi

if snap list | grep -q "firefox"; then
  echo "Firefox is already installed"
else
  echo "Installing Firefox..."

  sudo snap install firefox
fi

# valet-linux-plus
composer global show "cpriego/valet-linux" >/dev/null 2>%1
if [ $? -eq 0 ]; then
  echo "valet-linux-plus is already installed"
else
  echo "Installing valet-linux-plus..."
  sudo apt-get install curl libnss3-tools jq xsel openssl ca-certificates
  composer global require cpriego/valet-linux
  sudo add-apt-repository ppa:ondrej/php
fi

# Utilities
if ! dpkg -l | grep -q "xclip"; then
  echo "Installing xclip ..."

  sudo apt install xclip
else
  echo "xclip is already installed."
fi

if ! dpkg -l | grep -q "libfuse2"; then
  echo "Installing libfuse2..."

  sudo apt install libfuse2
else
  echo "libfuse2 is already installed."
fi

if ! dpkg -l | grep -q "variety"; then
  echo "Installing Variety wallpaper manager..."
  sudo apt install variety
else
  echo "Variety is already installed."
fi

if ! dpkg -l | grep -q "syncthing"; then
  echo "Installing Syncthing..."
  # Add the release PGP keys
  sudo mkdir -p /etc/apt/keyrings
  sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
  # Add the "stable" channel to APT sources
  echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
  # Install Syncthing
  sudo apt update && sudo apt install syncthing
else
  echo "Syncthing is already installed."
fi

if ! dpkg -l | grep -q "wireguard"; then
  echo "Installing Wireguard VPN client..."
  sudo apt install wireguard systemd-resolved
  # Enable and start systemd-resolved service
  sudo systemctl enable systemd-resolved
  sudo systemctl start systemd-resolved
  # Configure system to use systemd-resolved
  sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
else
  echo "Wireguard is already installed."
fi

# Set up Wireguard configuration from 1Password if it doesn't exist
echo "Sudo access is required to check Wireguard configuration."
if ! file "/etc/wireguard/wg0.conf" >/dev/null 2>&1; then
  sudo mkdir -p /etc/wireguard
  WIREGUARD_CONF=$(op read "op://private/wiregard-conf/kdg.conf")
  echo "Setting up Wireguard configuration..."
  sudo mkdir -p /etc/wireguard
  WIREGUARD_CONF=$(op read "op://private/wiregard-conf/kdg.conf")

  if [ $? -eq 0 ]; then
    echo "$WIREGUARD_CONF" | sudo tee /etc/wireguard/wg0.conf >/dev/null
    sudo chmod 600 /etc/wireguard/wg0.conf
    echo "Wireguard configuration installed successfully."
  else
    echo "Failed to fetch Wireguard configuration from 1Password."
  fi
else
  echo "Wireguard configuration already exists."
fi

# AI Tools
which ollama >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing Ollama..."
  curl https://ollama.ai/install.sh | sh
else
  echo "Ollama is already installed."
fi

# Setup Ollama Web UI
if ! docker ps -a | grep -q "open-webui"; then
  echo "Setting up Ollama Web UI..."
  docker run -d \
    -p 3000:8080 \
    --gpus all \
    -v ollama:/root/.ollama \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always \
    --network=host \
    -e WEBUI_AUTH=False \
    ghcr.io/open-webui/open-webui:ollama
  echo "Ollama Web UI is now available at http://localhost:3000"
else
  echo "Ollama Web UI is already running."
fi

# Development Tools

# Install Fly.io CLI
if ! fly version >/dev/null 2>&1; then
  echo "Installing Fly.io CLI..."
  curl -L https://fly.io/install.sh | sh
else
  echo "Fly.io CLI is already installed."
fi

# Install Golang
if ! command -v go >/dev/null 2>&1; then
  echo "Installing Golang..."
  sudo add-apt-repository ppa:longsleep/golang-backports -y
  sudo apt update
  sudo apt install golang-go
else
  echo "Golang is already installed."
fi

# Install ripgrep
if ! dpkg -l | grep -q "ripgrep"; then
  echo "Installing ripgrep..."
  sudo apt install ripgrep
else
  echo "ripgrep is already installed."
fi

# Install Spotify
if ! flatpak list | grep -q "com.spotify.Client"; then
  echo "Installing Spotify..."
  flatpak install -y flathub com.spotify.Client
else
  echo "Spotify is already installed."
fi

# Install Obsidian
if ! flatpak list | grep -q "md.obsidian.Obsidian"; then
  echo "Installing Obsidian..."
  flatpak install -y flathub md.obsidian.Obsidian
else
  echo "Obsidian is already installed."
fi

# Install Neovim
if ! dpkg -l | grep -q "neovim"; then
  echo "Installing Neovim..."
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
  sudo apt install neovim
else
  echo "Neovim is already installed."
fi

if ! snap list | grep -q "postman"; then
  echo "Installing postman..."
  sudo snap install postman
else
  echo "Postman is already installed."
fi

if ! snap list | grep -q "ngrok"; then
  echo "Installing ngrok..."
  sudo snap install ngrok
else
  echo "ngrok is already installed."
fi

which stripe >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing Stripe CLI..."
  curl -s https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public | gpg --dearmor | sudo tee /usr/share/keyrings/stripe.gpg
  echo "deb [signed-by=/usr/share/keyrings/stripe.gpg] https://packages.stripe.dev/stripe-cli-debian-local stable main" | sudo tee -a /etc/apt/sources.list.d/stripe.list
  sudo apt update
  sudo apt install stripe

else
  echo "Stripe CLI is already installed."
fi

# Browsers
if ! dpkg -l | grep -q "google-chrome-stable"; then
  echo "Installing Google Chrome..."
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  sudo apt update
  sudo apt install google-chrome-stable
else
  echo "Google Chrome is already installed."
fi

if ! flatpak list | grep -q "app.zen_browser.zen"; then
  echo "Installing Zen Browser..."
  flatpak install flathub app.zen_browser.zen
else
  echo "Zen Browser is already installed."
fi

# Password Manager
if ! dpkg -l | grep -q "1password"; then
  echo "Installing 1Password..."
  # Add the key for the 1Password apt repository
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  # Add the 1Password apt repository
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
  # Add the debsig-verify policy
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  # Install 1Password
  sudo apt update && sudo apt install 1password 1password-cli
else
  echo "1Password is already installed."
fi

# Terminal
if ! dpkg -l | grep -q "ghostty"; then
  echo "Installing Ghostty..."
  wget -O ghostty.deb https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.0.1-0-ppa4/ghostty_1.0.1-0.ppa4_amd64_24.10.deb
  sudo apt install ./ghostty.deb
  rm ghostty.deb
else
  echo "Ghostty is already installed."
fi
# Install lazygit
which lazygit >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit.tar.gz lazygit
else
  echo "lazygit is already installed."
fi

# Install Zellij
which zellij >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing Zellij..."
  ZELLIJ_VERSION=$(curl -s "https://api.github.com/repos/zellij-org/zellij/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo zellij.deb "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.deb"
  sudo dpkg -i zellij.deb
  rm zellij.deb
else
  echo "Zellij is already installed."
fi
# Communication tools

# Check for Franz installation
if ! dpkg -l | grep -q "franz"; then
  echo "Franz is not installed. Opening download page..."
  xdg-open "https://meetfranz.com/#download" &
  disown
else
  echo "Franz is already installed."
fi

if ! snap list | grep -q "slack"; then
  sudo snap install slack
else
  echo "Slack is already installed."
fi

if ! snap list | grep -q "discord"; then
  sudo snap install discord
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
  sudo apt update
  sudo apt install -y npm
fi

# No package manager available
which freeze >/dev/null 2>%1
if [ $? -eq 0 ]; then
  echo "freeze already installed."
else
  echo "Freeze is not installed. Opening browser for download..."
  xdg-open https://github.com/charmbracelet/freeze/releases &
  disown
fi

# Install Beekeeper Studio
if ! dpkg -l | grep -q "beekeeper-studio"; then
  echo "Installing Beekeeper Studio..."
  # Install GPG key and repository
  curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key | sudo gpg --dearmor --output /usr/share/keyrings/beekeeper.gpg \
    && sudo chmod go+r /usr/share/keyrings/beekeeper.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/beekeeper.gpg] https://deb.beekeeperstudio.io stable main" \
    | sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list > /dev/null
  # Update apt and install
  sudo apt update && sudo apt install beekeeper-studio -y
else
  echo "Beekeeper Studio is already installed."
fi

# Install OpenCode
which opencode >/dev/null 2>%1
if [ $? -eq 0 ]; then
  echo "OpenCode already installed."
else
  curl -fsSL https://opencode.ai/install | bash
fi
