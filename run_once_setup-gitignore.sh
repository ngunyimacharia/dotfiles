#!/bin/sh

# Configure global gitignore
if [ ! -f "$HOME/.gitignore" ]; then
  echo "Configuring global gitignore..."
  cp ~/.local/share/chezmoi/dot_gitignore ~/.gitignore
  git config --global core.excludesfile ~/.gitignore
else
  echo "Global gitignore already configured."
fi
