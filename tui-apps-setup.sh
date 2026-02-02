# TUI Applications Installation and Configuration Script
# Usage: ./tui-apps-setup.sh

set -e

TUI_CONFIG_DIR="$HOME/.config/tui-apps"

echo "Setting up TUI applications with Everforest theme..."

# Create configuration directory
mkdir -p "$TUI_CONFIG_DIR"

# Install btop configuration
echo "Setting up btop..."
if [ ! -f "$TUI_CONFIG_DIR/btop.conf" ]; then
    cp "$HOME/.local/share/chezmoi/tui-configs/btop.conf" "$TUI_CONFIG_DIR/btop.conf"
fi

# Install fastfetch configuration
echo "Setting up fastfetch..."
if [ ! -f "$TUI_CONFIG_DIR/fastfetch.jsonc" ]; then
    cp "$HOME/.local/share/chezmoi/tui-configs/fastfetch.jsonc" "$TUI_CONFIG_DIR/fastfetch.jsonc"
fi

# Install bat configuration
echo "Setting up bat..."
if [ ! -f "$TUI_CONFIG_DIR/bat.conf" ]; then
    cp "$HOME/.local/share/chezmoi/tui-configs/bat.conf" "$TUI_CONFIG_DIR/bat.conf"
fi

# Install lsd configuration
echo "Setting up lsd..."
if [ ! -f "$TUI_CONFIG_DIR/lsd.yaml" ]; then
    cp "$HOME/.local/share/chezmoi/tui-configs/lsd.yaml" "$TUI_CONFIG_DIR/lsd.yaml"
fi

# Create aliases for enhanced terminal experience
echo "Creating TUI aliases..."

# Add to Nushell config if exists
NU_CONFIG="$HOME/.config/nushell/config.nu"
if [ -f "$NU_CONFIG" ]; then
    echo "source tui-apps/config.nu" >> "$NU_CONFIG"
fi

# Add to Bash config if exists
BASH_CONFIG="$HOME/.bashrc"
if [ -f "$BASH_CONFIG" ]; then
    echo "" >> "$BASH_CONFIG"
    echo "# TUI Applications Aliases" >> "$BASH_CONFIG"
    echo "alias cat='bat'" >> "$BASH_CONFIG"
    echo "alias ls='lsd'" >> "$BASH_CONFIG"
    echo "alias top='btop'" >> "$BASH_CONFIG"
fi

echo ""
echo "✅ TUI applications setup complete!"
echo ""
echo "📋 Configured tools:"
echo "  • btop - System monitoring (Everforest theme)"
echo "  • fastfetch - System information (Everforest colors)"
echo "  • bat - Enhanced cat with syntax highlighting"
echo "  • lsd - Enhanced ls with icons and colors"
echo ""
echo "🔄 Aliases created:"
echo "  • cat -> bat (enhanced)"
echo "  • ls -> lsd (enhanced)"
echo "  • top -> btop (enhanced)"
echo ""
echo "💡 Restart your shell or run 'source ~/.bashrc' to apply aliases."