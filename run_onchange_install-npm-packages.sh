#!/bin/sh

# Nothing here works without npm. Skip cleanly instead of letting every
# install below fail one by one and take the chezmoi apply down with them.
if ! command -v npm >/dev/null 2>&1; then
  echo "npm not found; skipping global npm package install."
  exit 0
fi

# Use a user-owned global prefix so npm install -g does not require sudo.
NPM_GLOBAL_PREFIX="$HOME/.npm-global"
if [ "$(npm config get prefix)" != "$NPM_GLOBAL_PREFIX" ]; then
  echo "setting npm global prefix to $NPM_GLOBAL_PREFIX..."
  mkdir -p "$NPM_GLOBAL_PREFIX/bin"
  npm config set prefix "$NPM_GLOBAL_PREFIX"
fi

npm list -g blade-formatter >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "blade-formatter already installed"
else
  echo "installing blade-formatter..."
  npm install -g blade-formatter
fi

npm list -g prettier >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "prettier already installed"
else
  echo "installing prettier..."
  npm install -g prettier
fi

npm list -g yarn >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "yarn already installed"
else
  echo "installing yarn..."
  npm install -g yarn
fi

npm list -g @anthropic-ai/claude-code >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "claude-code already installed"
else
  echo "installing claude-code..."
  npm install -g @anthropic-ai/claude-code
fi

npm list -g @openai/codex >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "codex already installed"
else
  echo "installing codex..."
  npm install -g @openai/codex
fi

npm list -g @mariozechner/pi-coding-agent >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "pi already installed"
else
  echo "installing pi..."
  npm install -g @mariozechner/pi-coding-agent
fi
