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
if ! test -d "/Applications/Visual Studio Code.app"; then
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
if ! brew list --cask zen >/dev/null 2>&1; then
  echo "Installing Zen Browser..."
  brew install --cask zen
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

# Install tmux
if ! brew list | grep -q "tmux"; then
  echo "Installing tmux..."
  brew install tmux
else
  echo "tmux is already installed."
fi

# Install Herdr
if ! brew list | grep -q "herdr"; then
  echo "Installing Herdr..."
  brew install herdr
else
  echo "Herdr is already installed."
fi

# Install Slack
if ! brew list --cask | grep -q "slack"; then
  echo "Installing Slack..."
  brew install --cask slack
else
  echo "Slack is already installed."
fi

# Install Lerd and its Podman dependency.
export PATH="$HOME/.local/share/lerd/bin:$HOME/.local/bin:$PATH"

if ! command -v lerd >/dev/null 2>&1; then
  echo "Installing Lerd..."
  lerd_installer=$(mktemp)
  if ! curl -fsSL https://lerd.sh/install.sh -o "$lerd_installer"; then
    rm -f "$lerd_installer"
    echo "Failed to download the Lerd installer." >&2
    exit 1
  fi
  if ! bash "$lerd_installer"; then
    rm -f "$lerd_installer"
    echo "Failed to install Lerd." >&2
    exit 1
  fi
  rm -f "$lerd_installer"
else
  echo "Lerd is already installed."
fi

if [ ! -f "$HOME/.config/lerd/config.yaml" ]; then
  echo "Configuring Lerd..."
  if ! lerd install; then
    echo "Failed to configure Lerd." >&2
    exit 1
  fi
fi

# Make Lerd's managed tool shims available to the rest of this script.
export PATH="$HOME/.local/share/lerd/bin:$HOME/.local/bin:$PATH"

if command -v composer >/dev/null 2>&1; then
  composer global show "laravel/lsp" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Installing Laravel LSP..."
    composer global require laravel/lsp
  else
    echo "Laravel LSP is already installed."
  fi
else
  echo "Composer not available, skipping global Laravel tools."
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

# Install AWS CLI
if ! brew list | grep -q "awscli"; then
  echo "Installing AWS CLI..."
  brew install awscli
else
  echo "AWS CLI is already installed."
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

# Install LocalSend
if ! brew list --cask | grep -q "localsend"; then
  echo "Installing LocalSend..."
  brew install --cask localsend
else
  echo "LocalSend is already installed."
fi



# Install Android Studio
if ! test -d "/Applications/Android Studio.app"; then
  echo "Installing Android Studio..."
  brew install --cask android-studio
else
  echo "Android Studio is already installed."
fi

# Install FiraCode Nerd Font
if ! brew list --cask | grep -q "font-fira-code-nerd-font"; then
  echo "Installing FiraCode Nerd Font..."
  brew tap homebrew/cask-fonts
  brew install --cask font-fira-code-nerd-font
else
  echo "FiraCode Nerd Font is already installed."
fi

# Install Kitty
if ! brew list | grep -q "kitty"; then
  echo "Installing Kitty..."
  brew install kitty
else
  echo "Kitty is already installed."
fi

# Install Beekeeper Studio
if ! test -d "/Applications/Beekeeper Studio.app"; then
  echo "Installing Beekeeper Studio..."
  brew install --cask beekeeper-studio
else
  echo "Beekeeper Studio is already installed."
fi

# Install OpenCode v1 (official curl installer, installs to ~/.opencode)
which opencode >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "OpenCode v1 already installed."
else
  echo "Installing OpenCode v1..."
  curl -fsSL https://opencode.ai/install | bash
fi

# Install OpenCode v2 (npm beta channel, side-by-side at ~/.opencode2)
if [ -x "$HOME/.opencode2/bin/opencode" ]; then
  echo "OpenCode v2 already installed."
else
  if command -v npm >/dev/null 2>&1; then
    echo "Installing opencode v2 (beta)..."
    npm install -g --prefix "$HOME/.opencode2" opencode-ai@beta 2>&1
  else
    echo "npm not found; skipping opencode v2 install."
  fi
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

# Configure Zsh as default shell
ZSH_PATH="/bin/zsh"
if [ -f "$ZSH_PATH" ]; then
  if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s "$ZSH_PATH"
    echo "Shell changed to Zsh. Please restart your terminal or log out/in for changes to take effect."
  else
    echo "Zsh is already the default shell."
  fi
else
  echo "Zsh binary not found at expected location."
fi

# Omarchy-style desktop stack. AeroSpace does the tiling (chosen over yabai
# because SIP is enabled on this machine and yabai would need it disabled),
# sketchybar replaces the menu bar, borders draws the active-window outline,
# and alt-tab gives a real thumbnail window switcher. All four read their
# colors from .chezmoidata/palette.toml through chezmoi templates.
for formula in nikitabobko/tap/aerospace FelixKratz/formulae/sketchybar FelixKratz/formulae/borders; do
  name="${formula##*/}"
  if brew list "$name" >/dev/null 2>&1; then
    echo "$name is already installed."
  else
    echo "Installing $name..."
    brew install "$formula"
  fi
done

if ! test -d "/Applications/AltTab.app"; then
  echo "Installing AltTab..."
  brew install --cask alt-tab
else
  echo "AltTab is already installed."
fi
