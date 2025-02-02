#!/bin/sh

npm list -g blade-formatter >/dev/null 2>%1
if [ $? -eq 0 ]; then
  echo "blade-formatter already installed"
else
  echo "installing blade-formatter..."
  npm install -g blade-formatter
fi

npm list -g prettier >/dev/null 2>%1
if [ $? -eq 0 ]; then
  echo "prettier already installed"
else
  echo "installing prettier..."
  npm install -g prettier
fi

npm list -g yarn >/dev/null 2>%1
if [ $? -eq 0 ]; then
  echo "yarn already installed"
else
  echo "installing yarn..."
  npm install -g yarn
fi

# Configure global gitignore
if [ ! -f "$HOME/.gitignore" ]; then
  echo "Configuring global gitignore..."
  cp ~/.local/share/chezmoi/dot_gitignore ~/.gitignore
  git config --global core.excludesfile ~/.gitignore
else
  echo "Global gitignore already configured."
fi
