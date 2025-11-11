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

# valet-linux-plus dependencies (check after composer is installed)
if command -v composer >/dev/null 2>&1; then
  composer global show "cpriego/valet-linux" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Installing valet-linux-plus dependencies..."
    sudo dnf install -y curl nss-tools jq xsel openssl ca-certificates
    composer global require cpriego/valet-linux
  else
    echo "valet-linux-plus is already installed"
  fi
  
  # Install Laravel Takeout
  composer global show "tightenco/takeout" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Installing Laravel Takeout..."
    composer global require tightenco/takeout
  else
    echo "Laravel Takeout is already installed."
  fi
  
  # Configure Valet DNS to use reliable upstream servers
  if command -v valet >/dev/null 2>&1; then
    echo "Configuring Valet DNS with reliable upstream servers..."
    mkdir -p ~/.config/valet
    
    # Check if dnsmasq.conf already has our DNS servers configured
    if [ ! -f ~/.config/valet/dnsmasq.conf ] || ! grep -q "server=8.8.8.8" ~/.config/valet/dnsmasq.conf; then
      echo "Adding DNS server configuration to Valet..."
      echo "server=8.8.8.8" >> ~/.config/valet/dnsmasq.conf
      echo "server=1.1.1.1" >> ~/.config/valet/dnsmasq.conf
      echo "no-resolv" >> ~/.config/valet/dnsmasq.conf
      
      echo "Restarting Valet to apply DNS changes..."
      valet restart
    else
      echo "Valet DNS configuration already exists."
    fi
  fi
else
  echo "Composer not available, skipping valet-linux-plus and Laravel Takeout installation"
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

if ! rpm -q gnome-tweaks; then
  echo "Installing GNOME Tweaks..."
  sudo dnf install -y gnome-tweaks
else
  echo "GNOME Tweaks is already installed."
fi

# Syncthing (install from Fedora repos since external repo is broken)
if ! rpm -q syncthing; then
  echo "Installing Syncthing from Fedora repositories..."
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



# Install Composer first (needed for valet-linux-plus)
if ! command -v composer >/dev/null 2>&1; then
  echo "Installing Composer..."
  sudo dnf install -y composer
else
  echo "Composer is already installed."
fi

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

# Install fzf
if ! rpm -q fzf; then
  echo "Installing fzf..."
  sudo dnf install -y fzf
else
  echo "fzf is already installed."
fi

# Install fd
if ! rpm -q fd-find; then
  echo "Installing fd..."
  sudo dnf install -y fd-find
else
  echo "fd is already installed."
fi

# Install GCC compiler (required for nvim-treesitter)
if ! rpm -q gcc; then
  echo "Installing GCC compiler..."
  sudo dnf install -y gcc
else
  echo "GCC is already installed."
fi

# Install GitHub CLI
if ! rpm -q gh; then
  echo "Installing GitHub CLI..."
  sudo dnf install -y gh
else
  echo "GitHub CLI is already installed."
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

# Install ngrok (manual installation required)
if ! command -v ngrok >/dev/null 2>&1; then
  echo "Opening ngrok installation guide..."
  echo "Please follow the manual installation instructions at:"
  echo "https://ngrok.com/docs/guides/device-gateway/linux"
  xdg-open https://ngrok.com/docs/guides/device-gateway/linux &
  disown
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
  sudo dnf config-manager enable google-chrome 2>/dev/null || sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
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

# Install Zellij (use cargo install since dnf package may not be available)
which zellij >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Installing Zellij via cargo..."
  # Install required dependencies first
  sudo dnf install -y perl perl-FindBin openssl-devel
  if command -v cargo >/dev/null 2>&1; then
    cargo install zellij --locked
  else
    echo "Installing Rust and Cargo first..."
    sudo dnf install -y rust cargo
    cargo install zellij --locked
  fi
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

# Check for npm installation (after NVM setup)
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
  if command -v npm >/dev/null 2>&1; then
    echo "npm is already available via NVM"
    # Install npm packages
    echo "Installing global npm packages..."
    npm install -g blade-formatter prettier yarn @anthropic-ai/claude-code tree-sitter-cli
  else
    echo "npm not available via NVM, installing system npm..."
    sudo dnf install -y npm
  fi
else
  echo "NVM not available, installing system npm..."
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

# Install Docker
if ! rpm -q docker-ce >/dev/null 2>&1 && ! rpm -q docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  # For Fedora 43+, use native packages (more reliable)
  if grep -q "Fedora release 4[3-9]" /etc/fedora-release 2>/dev/null; then
    echo "Using native Fedora Docker packages for Fedora 43+..."
    sudo dnf install -y docker docker-compose
  else
    # For older Fedora versions, use Docker CE repository
    sudo dnf install -y dnf-plugins-core
    # Create Docker CE repository file manually (config-manager syntax changed)
    sudo tee /etc/yum.repos.d/docker-ce.repo > /dev/null <<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi
  
  # Start and enable Docker service
  sudo systemctl start docker
  sudo systemctl enable docker
  
  # Add user to docker group and verify
  echo "Adding user to docker group..."
  sudo usermod -aG docker $USER
  echo "Docker installed successfully!"
  echo ""
  echo "IMPORTANT: Docker group changes require a session restart to take effect."
  echo "Please either:"
  echo "  1. Log out and log back in, OR"
  echo "  2. Run 'newgrp docker' in your current terminal, OR" 
  echo "  3. Restart your terminal"
  echo ""
  echo "After restarting your session, test Docker access with: docker ps"
else
  echo "Docker is already installed."
  # Check if user is in docker group even if Docker is already installed
  if ! groups | grep -q docker; then
    echo "Adding user to docker group (Docker was already installed but user not in group)..."
    sudo usermod -aG docker $USER
    echo ""
    echo "IMPORTANT: Docker group changes require a session restart to take effect."
    echo "Please either:"
    echo "  1. Log out and log back in, OR"
    echo "  2. Run 'newgrp docker' in your current terminal, OR"
    echo "  3. Restart your terminal"
    echo ""
    echo "After restarting your session, test Docker access with: docker ps"
  else
    echo "User is already in the docker group."
  fi
fi

# Install lazydocker
which lazydocker >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "lazydocker already installed."
else
  echo "Installing lazydocker..."
  if command -v go >/dev/null 2>&1; then
    go install github.com/jesseduffield/lazydocker@latest
    echo "lazydocker installed via go install"
  else
    echo "Installing lazydocker via binary download..."
    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazydocker.tar.gz lazydocker
    sudo install lazydocker /usr/local/bin
    rm lazydocker.tar.gz lazydocker
    echo "lazydocker installed via binary download"
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

# Install Ghostty via COPR repository
if ! command -v ghostty >/dev/null 2>&1; then
  echo "Installing Ghostty via COPR..."
  sudo dnf copr enable -y scottames/ghostty
  sudo dnf install -y ghostty
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