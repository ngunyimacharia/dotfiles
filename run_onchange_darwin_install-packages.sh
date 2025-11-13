#!/bin/sh

# Exit if not running on Linux
if [ "$(uname)" != "Darwin" ]; then
  echo "Not on MacOS"
  exit 0
fi

# Install Neovim
if ! brew list | grep -q "neovim"; then
  echo "Installing Neovim..."
  brew install neovim
else
  echo "Neovim is already installed."
fi

# Install Visual Studio Code
if ! brew list --cask | grep -q "visual-studio-code"; then
  echo "Installing Visual Studio Code..."
  brew install --cask visual-studio-code
else
  echo "Visual Studio Code is already installed."
fi

# Install 1Password
if ! brew list --cask | grep -q "1password"; then
  echo "Installing 1Password..."
  brew install --cask 1password 1password-cli
else
  echo "1Password is already installed."
fi

# Install Google Chrome
if ! brew list --cask | grep -q "google-chrome"; then
  echo "Installing Google Chrome..."
  brew install --cask google-chrome
else
  echo "Google Chrome is already installed."
fi
# Install Zen Browser
if ! test -d "/Applications/Zen Browser.app"; then
  echo "Installing Zen Browser..."
  curl -L "https://objects.githubusercontent.com/github-production-release-asset-2e65be/778556932/07bb19d8-1960-4589-9d79-c290c0b6795d?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250131%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250131T071117Z&X-Amz-Expires=300&X-Amz-Signature=271b6858c0614b280560b1b2f2df0d5c9ae074b8bb45b982cef68c5aa4ac953a&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dzen.macos-universal.dmg&response-content-type=application%2Foctet-stream" -o zen.dmg
  hdiutil attach zen.dmg
  cp -R "/Volumes/Zen/Zen.app" /Applications/
  hdiutil detach "/Volumes/Zen"
  rm zen.dmg
else
  echo "Zen Browser is already installed."
fi

# Install Setapp
if ! brew list --cask | grep -q "setapp"; then
  echo "Installing Setapp..."
  brew install --cask setapp
else
  echo "Setapp is already installed."
fi



# Install Syncthing
if ! brew list | grep -q "syncthing"; then
  echo "Installing Syncthing..."
  brew install --cask syncthing
else
  echo "Syncthing is already installed."
fi

# Install Microsoft Teams
if ! brew list --cask | grep -q "microsoft-teams"; then
  echo "Installing Microsoft Teams..."
  brew install --cask microsoft-teams
else
  echo "Microsoft Teams is already installed."
fi

# Install Zoom
if ! brew list --cask | grep -q "zoom"; then
  echo "Installing Zoom..."
  brew install --cask zoom
else
  echo "Zoom is already installed."
fi

# Check for Wireguard
if ! test -d "/Applications/WireGuard.app"; then
  echo "Wireguard is not installed. Opening Mac App Store..."
  open "https://apps.apple.com/us/app/wireguard/id1451685025?ls=1&mt=12"
else
  echo "Wireguard is already installed."
fi

# Install lazygit
if ! brew list | grep -q "lazygit"; then
  echo "Installing lazygit..."
  brew install lazygit
else
  echo "lazygit is already installed."
fi

# Install Raycast
if ! brew list --cask | grep -q "raycast"; then
  echo "Installing Raycast..."
  brew install --cask raycast
else
  echo "Raycast is already installed."
fi

# Install npm
if ! brew list | grep -q "node"; then
  echo "Installing npm..."
  brew install npm
else
  echo "npm is already installed."
fi

# Install tree-sitter CLI (required for nvim-treesitter)
if ! command -v tree-sitter >/dev/null 2>&1; then
  echo "Installing tree-sitter CLI..."
  npm install -g tree-sitter-cli
else
  echo "tree-sitter CLI is already installed."
fi

# Install Zellij
if ! brew list | grep -q "zellij"; then
  echo "Installing Zellij..."
  brew install zellij
else
  echo "Zellij is already installed."
fi

# Install Slack
if ! brew list --cask | grep -q "slack"; then
  echo "Installing Slack..."
  brew install --cask slack
else
  echo "Slack is already installed."
fi

# Install Laravel Herd
if ! test -d "/Applications/Herd.app"; then
  echo "Laravel Herd is not installed. Opening download page..."
  open "https://herd.laravel.com/download"
else
  echo "Laravel Herd is already installed."
fi

# Install Laravel Takeout (requires Composer)
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

# Install Stripe CLI
if ! brew list | grep -q "stripe"; then
  echo "Installing Stripe CLI..."
  brew install stripe/stripe-cli/stripe
else
  echo "Stripe CLI is already installed."
fi

# Install Whatsapp
if ! brew list | grep -q "whatsapp"; then
  echo "Installing Stripe CLI..."
  brew install --cask whatsapp
else
  echo "Whatsapp is already installed."
fi

# Install Spotify
if ! brew list --cask | grep -q "spotify"; then
  echo "Installing Spotify..."
  brew install --cask spotify
else
  echo "Spotify is already installed."
fi

# Install Obsidian
if ! brew list --cask | grep -q "obsidian"; then
  echo "Installing Obsidian..."
  brew install --cask obsidian
else
  echo "Obsidian is already installed."
fi

# Install ripgrep
if ! brew list | grep -q "ripgrep"; then
  echo "Installing ripgrep..."
  brew install ripgrep
else
  echo "ripgrep is already installed."
fi

# Install fzf
if ! brew list | grep -q "fzf"; then
  echo "Installing fzf..."
  brew install fzf
else
  echo "fzf is already installed."
fi

# Install fd
if ! brew list | grep -q "fd"; then
  echo "Installing fd..."
  brew install fd
else
  echo "fd is already installed."
fi

# Install Golang
if ! brew list | grep -q "go"; then
  echo "Installing Golang..."
  brew install go
else
  echo "Golang is already installed."
fi

# Install Docker Desktop
if ! brew list --cask | grep -q "docker"; then
  echo "Installing Docker Desktop..."
  brew install --cask docker
else
  echo "Docker Desktop is already installed."
fi



# Install LocalSend
if ! brew list --cask | grep -q "localsend"; then
  echo "Installing LocalSend..."
  brew install --cask localsend
else
  echo "LocalSend is already installed."
fi



# Install Android Studio
if ! brew list --cask | grep -q "android-studio"; then
  echo "Installing Android Studio..."
  brew install --cask android-studio
else
  echo "Android Studio is already installed."
fi

# Install Ghostty
if ! brew list --cask | grep -q "ghostty"; then
  echo "Installing Ghostty..."
  brew install --cask ghostty
else
  echo "Ghostty is already installed."
fi

# Install Beekeeper Studio
if ! brew list --cask | grep -q "beekeeper-studio"; then
  echo "Installing Beekeeper Studio..."
  brew install --cask beekeeper-studio
else
  echo "Beekeeper Studio is already installed."
fi

# Install OpenCode
which opencode >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "OpenCode already installed."
else
  curl -fsSL https://opencode.ai/install | bash
fi

# Install Starship
if ! brew list | grep -q "starship"; then
  echo "Installing Starship..."
  brew install starship
else
  echo "Starship is already installed."
fi

# Install zoxide
if ! brew list | grep -q "zoxide"; then
  echo "Installing zoxide..."
  brew install zoxide
else
  echo "zoxide is already installed."
fi
