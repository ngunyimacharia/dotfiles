#!/bin/sh

# Configure global gitignore
echo "Setting up global gitignore configuration..."

# Ensure .gitignore exists in home directory (chezmoi should handle this via dot_gitignore)
if [ ! -f "$HOME/.gitignore" ]; then
  echo "Warning: ~/.gitignore not found. This should be managed by chezmoi."
  echo "Please run 'chezmoi apply' to ensure dotfiles are properly installed."
  exit 1
fi

# Configure git to use the global gitignore
current_excludesfile=$(git config --global core.excludesfile)
if [ "$current_excludesfile" != "$HOME/.gitignore" ]; then
  echo "Configuring git to use global gitignore..."
  git config --global core.excludesfile ~/.gitignore
  echo "Global gitignore configured at ~/.gitignore"
else
  echo "Global gitignore already configured."
fi

# Verify configuration
echo "Current global gitignore setting: $(git config --global core.excludesfile)"
