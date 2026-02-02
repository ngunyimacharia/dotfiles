#!/bin/bash

# Add TUI aliases to Bash configuration
# Usage: ./add-tui-aliases-bash.sh

set -e

BASH_CONFIG="$HOME/.bashrc"
TUI_ALIASES="$HOME/.local/share/chezmoi/tui-aliases.sh"

echo "Adding TUI aliases to Bash configuration..."

# Add TUI aliases section
if [ -f "$BASH_CONFIG" ]; then
    echo "" >> "$BASH_CONFIG"
    echo "# Enhanced Terminal Aliases (TUI Applications)" >> "$BASH_CONFIG"
    echo "cat README.md    # Enhanced cat with syntax highlighting" >> "$BASH_CONFIG"
    echo "lsd -la         # Enhanced ls with icons and colors" >> "$BASH_CONFIG"
    echo "top             # Enhanced system monitoring" >> "$BASH_CONFIG"
    echo "" >> "$BASH_CONFIG"
    echo "# Enhanced command aliases (active after restarting shell)" >> "$BASH_CONFIG"
    
    # Source the TUI aliases if available
    if [ -f "$TUI_ALIASES" ]; then
        echo "source $TUI_ALIASES" >> "$BASH_CONFIG"
    else
        echo "⚠️  TUI aliases file not found" >> "$BASH_CONFIG"
    fi
    
    echo "✅ TUI aliases added to Bash configuration"
else
    echo "❌ Bash configuration file not found: $BASH_CONFIG"
fi

echo ""
echo "💡 Restart your shell or run 'source ~/.bashrc' to apply new aliases."