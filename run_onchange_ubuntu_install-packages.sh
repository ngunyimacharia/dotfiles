#!/bin/sh

# Exit if not running on Ubuntu/Debian
if [ ! -f /etc/os-release ] || ! grep -qE "^ID=(ubuntu|debian|pop)" /etc/os-release; then
  echo "Not on Ubuntu/Debian, skipping Ubuntu/Debian package installation"
  exit 0
fi

# valet-linux-plus
composer global show "cpriego/valet-linux" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "valet-linux-plus is already installed"
else
  echo "Installing valet-linux-plus..."
  sudo apt-get install curl libnss3-tools jq xsel openssl ca-certificates
  sudo add-apt-repository ppa:ondrej/php -y
  sudo apt update
   sudo apt install php php-cli php-mbstring php-xml php-zip php-curl -y
   curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
  composer global require cpriego/valet-linux
fi

# Laravel Takeout
if command -v composer >/dev/null 2>&1; then
  composer global show "tightenco/takeout" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Installing Laravel Takeout..."
    composer global require tightenco/takeout
  else
    echo "Laravel Takeout is already installed."
  fi
else
  echo "Composer not available, skipping Laravel Takeout installation."
fi

# Utilities
if ! dpkg -l | grep "^ii" | grep -q "xclip"; then
  echo "Installing xclip ..."

  sudo apt install xclip
else
  echo "xclip is already installed."
fi

if ! dpkg -l | grep "^ii" | grep -q "libfuse2"; then
  echo "Installing libfuse2..."

  sudo apt install libfuse2
else
  echo "libfuse2 is already installed."
fi

if ! dpkg -l | grep "^ii" | grep -q "variety"; then
  echo "Installing Variety wallpaper manager..."
  sudo apt install variety
else
  echo "Variety is already installed."
fi

if ! dpkg -l | grep "^ii" | grep -q "syncthing"; then
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

if ! dpkg -l | grep "^ii" | grep -q "wireguard"; then
  echo "Installing Wireguard VPN client..."
  sudo apt install wireguard
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
if ! test -f "/etc/wireguard/wg0.conf"; then
  sudo mkdir -p /etc/wireguard
  echo "Setting up Wireguard configuration..."
  WIREGUARD_CONF=$(op read "op://private/wireguard-conf/kdg.conf" 2>/dev/null)

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
  sudo add-apt-repository ppa:longsleep/golang-backports -y
  sudo apt update
  sudo apt install golang-go
else
  echo "Golang is already installed."
fi

# Install ripgrep
if ! dpkg -l | grep "^ii" | grep -q "ripgrep"; then
  echo "Installing ripgrep..."
  sudo apt install ripgrep
else
  echo "ripgrep is already installed."
fi

# Install fzf
which fzf >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing fzf..."
  FZF_VERSION=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo fzf.tar.gz "https://github.com/junegunn/fzf/releases/latest/download/fzf-${FZF_VERSION}-linux_amd64.tar.gz"
  tar xf fzf.tar.gz fzf
  sudo install fzf /usr/local/bin
  rm fzf.tar.gz fzf
else
  echo "fzf is already installed."
fi

# Install fd
if ! dpkg -l | grep "^ii" | grep -q "fd-find"; then
  echo "Installing fd..."
  sudo apt install fd-find
else
  echo "fd is already installed."
fi

# Install build essentials (required for nvim-treesitter)
if ! dpkg -l | grep "^ii" | grep -q "build-essential"; then
  echo "Installing build-essential..."
  sudo apt install build-essential
else
  echo "build-essential is already installed."
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
if ! dpkg -l | grep "^ii" | grep -q "neovim"; then
  echo "Installing Neovim..."
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt update
  sudo apt install neovim
else
  echo "Neovim is already installed."
fi

# Install VSCode
if ! command -v code >/dev/null 2>&1; then
  echo "Installing Visual Studio Code..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update
  sudo apt install code
else
  echo "Visual Studio Code is already installed."
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
if ! dpkg -l | grep "^ii" | grep -q "google-chrome-stable"; then
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
if ! dpkg -l | grep "^ii" | grep -q "1password"; then
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

# Install Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  # Add Docker's official GPG key
  sudo apt-get update
  sudo apt-get install ca-certificates curl gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # Add the repository to Apt sources
  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  # Install Docker
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  echo "Adding user to docker group..."
  sudo usermod -aG docker $(whoami)
else
  echo "Docker is already installed."
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

# Install LazyDocker
which lazydocker >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing LazyDocker..."
  LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazydocker.tar.gz lazydocker
  sudo install lazydocker /usr/local/bin
  rm lazydocker.tar.gz lazydocker
else
  echo "LazyDocker is already installed."
fi

# Install Zellij
which zellij >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing Zellij..."
  curl -Lo zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
  tar xf zellij.tar.gz zellij
  sudo install zellij /usr/local/bin
  rm zellij.tar.gz zellij
else
  echo "Zellij is already installed."
fi
# Communication tools

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

# Install Zoom via Flatpak
if ! flatpak list | grep -q "us.zoom.Zoom"; then
  echo "Installing Zoom..."
  flatpak install -y flathub us.zoom.Zoom
else
  echo "Zoom is already installed."
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

# Install tree-sitter CLI (required for nvim-treesitter)
if ! command -v tree-sitter >/dev/null 2>&1; then
  echo "Installing tree-sitter CLI..."
  npm install -g tree-sitter-cli
else
  echo "tree-sitter CLI is already installed."
fi

# No package manager available
which freeze >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "freeze already installed."
else
  echo "Freeze is not installed. Opening browser for download..."
  xdg-open https://github.com/charmbracelet/freeze/releases &
  disown
fi

# Install Beekeeper Studio
if ! dpkg -l | grep "^ii" | grep -q "beekeeper-studio"; then
  echo "Installing Beekeeper Studio..."
  # Install GPG key and repository
  curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key | sudo gpg --dearmor --output /usr/share/keyrings/beekeeper.gpg &&
    sudo chmod go+r /usr/share/keyrings/beekeeper.gpg &&
    echo "deb [signed-by=/usr/share/keyrings/beekeeper.gpg] https://deb.beekeeperstudio.io stable main" |
    sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list >/dev/null
  # Update apt and install
  sudo apt update && sudo apt install beekeeper-studio -y
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

# Install Ghostty
if ! snap list | grep -q "ghostty"; then
  echo "Installing Ghostty..."
  sudo snap install ghostty --classic
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
  curl -fsSL https://opencode.ai/install | bash
fi

# Install Starship
which starship >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Starship already installed."
else
  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Install zoxide
which zoxide >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "zoxide already installed."
else
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Install Nushell
which nu >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Nushell already installed."
else
  echo "Installing Nushell..."
  NUSHELL_VERSION=$(curl -s "https://api.github.com/repos/nushell/nushell/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  curl -Lo /tmp/nu.tar.gz "https://github.com/nushell/nushell/releases/download/${NUSHELL_VERSION}/nu-${NUSHELL_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
  tar -xzf /tmp/nu.tar.gz -C /tmp
  mkdir -p $HOME/.local/bin
  cp "/tmp/nu-${NUSHELL_VERSION}-x86_64-unknown-linux-gnu/nu" $HOME/.local/bin/
  chmod +x $HOME/.local/bin/nu
  rm -rf /tmp/nu.tar.gz "/tmp/nu-${NUSHELL_VERSION}-x86_64-unknown-linux-gnu"
  echo "Nushell installed to $HOME/.local/bin/nu"
fi
