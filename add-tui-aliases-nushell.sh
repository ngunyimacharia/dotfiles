#!/bin/bash

# Add TUI aliases to Nushell configuration
# Usage: ./add-tui-aliases-nushell.sh

set -e

NU_CONFIG="$HOME/.config/nushell/config.nu"
TUI_ALIASES="$HOME/.local/share/chezmoi/tui-aliases.sh"

echo "Adding TUI aliases to Nushell configuration..."

# Source TUI aliases
if [ -f "$TUI_ALIASES" ]; then
    echo "source tui-aliases.sh" >> "$NU_CONFIG"
    echo "✅ TUI aliases added to Nushell config"
else
    echo "❌ TUI aliases file not found"
fi

echo ""
echo "💡 Restart Nushell to activate new aliases"
echo "   Run: exec nu"