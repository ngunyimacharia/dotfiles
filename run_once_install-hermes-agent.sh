#!/bin/sh

# Install Hermes Agent (Nous Research) including the desktop app
# https://hermes-agent.nousresearch.com/

# Only supported on Linux and macOS
case "$(uname -s)" in
  Linux | Darwin) ;;
  *)
    echo "Unsupported OS, skipping Hermes Agent installation"
    exit 0
    ;;
esac

# Skip if the agent and a built desktop app are already present
if command -v hermes >/dev/null 2>&1 && [ -d "$HOME/.hermes/hermes-agent/apps/desktop/release" ]; then
  echo "Hermes Agent with desktop app already installed."
  exit 0
fi

echo "Installing Hermes Agent (with desktop app)..."

# Two-stage: download first, then run, so curl failures aren't masked by bash
tmp_installer="$(mktemp)"
if ! curl -fsSL https://hermes-agent.nousresearch.com/install.sh -o "$tmp_installer"; then
  echo "Failed to download the Hermes installer."
  rm -f "$tmp_installer"
  exit 1
fi

# --include-desktop builds the Electron desktop app during install
# --skip-setup skips the interactive first-run wizard (run `hermes` later to configure)
if bash "$tmp_installer" --include-desktop --skip-setup; then
  echo "Hermes Agent installed successfully."
  rm -f "$tmp_installer"
else
  echo "Hermes Agent installation failed."
  rm -f "$tmp_installer"
  exit 1
fi

echo "To connect the desktop app to the remote Hermes server:"
echo "  Settings -> Gateway -> Remote gateway -> enter the remote URL and sign in."
