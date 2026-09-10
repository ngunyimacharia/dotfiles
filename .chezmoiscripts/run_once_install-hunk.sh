#!/bin/sh

# Install Hunk (review-first terminal diff viewer)
# https://github.com/modem-dev/hunk

echo "Setting up Hunk diff viewer..."

# Check if Hunk is already installed
if command -v hunk >/dev/null 2>&1; then
  echo "Hunk already installed: $(hunk --version 2>/dev/null || echo 'version unknown')"
else
  # Check for npm
  if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found. Please install Node.js/npm to use Hunk."
    exit 1
  fi

  echo "Installing hunkdiff via npm..."
  if npm i -g hunkdiff; then
    echo "Hunk installed successfully."
  else
    echo "Failed to install Hunk via npm."
    exit 1
  fi
fi

# Configure opt-in Git aliases that invoke Hunk directly.
# Using "hunk pager" via core.pager breaks watch mode because stdin is a static
# pipe. Invoking "hunk diff" / "hunk show" directly lets Hunk read from Git.
setup_git_alias() {
  alias_name="$1"
  alias_value="$2"
  current_value=$(git config --global "alias.${alias_name}" 2>/dev/null)

  if [ "$current_value" != "$alias_value" ]; then
    echo "Configuring git alias.${alias_name}..."
    git config --global "alias.${alias_name}" "$alias_value"
  else
    echo "git alias.${alias_name} already configured."
  fi
}

setup_git_alias "hdiff" '!hunk diff'
setup_git_alias "hshow" '!hunk show'

echo "Hunk setup complete."
