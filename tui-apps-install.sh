#!/bin/bash

# Install TUI Applications
# Usage: ./tui-apps-install.sh

set -e

echo "🖥️ Installing enhanced TUI applications..."

# Install btop - System monitor with beautiful graphs
if ! dpkg -l | grep -q "^ii.*btop"; then
    echo "Installing btop..."
    BTOP_VERSION=$(curl -s "https://api.github.com/repos/aristocratos/btop/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo btop.tar.gz "https://github.com/aristocratos/btop/releases/download/v${BTOP_VERSION}/btop-${BTOP_VERSION}-x86_64-linux-musl.tar.gz"
    tar -xf btop.tar.gz -C /tmp
    sudo dpkg -i /tmp/btop_*.deb
    rm btop.tar.gz btop*.deb
    echo "✅ btop installed"
else
    echo "btop is already installed."
fi

# Install fastfetch - Fast system information display
if ! command -v fastfetch >/dev/null 2>&1; then
    echo "Installing fastfetch..."
    sudo snap install fastfetch
    echo "✅ fastfetch installed"
else
    echo "fastfetch is already installed."
fi

# Install bat - Enhanced cat with syntax highlighting
if ! command -v bat >/dev/null 2>&1; then
    echo "Installing bat..."
    sudo apt install -y bat
    echo "✅ bat installed"
else
    echo "bat is already installed."
fi

# Install lsd - Enhanced ls with icons and colors
if ! command -v lsd >/dev/null 2>&1; then
    echo "Installing lsd..."
    sudo apt install -y lsd
    echo "✅ lsd installed"
else
    echo "lsd is already installed."
fi

# Install delta - Enhanced git diff viewer
if ! command -v delta >/dev/null 2>&1; then
    echo "Installing delta..."
    sudo apt install -y git-delta
    echo "✅ delta installed"
else
    echo "delta is already installed."
fi

echo ""
echo "🎉 TUI applications installation complete!"
echo ""
echo "📋 Installed tools:"
echo "  • btop - System monitoring with Everforest theme support"
echo "  • fastfetch - System information"
echo "  • bat - Enhanced cat with syntax highlighting"
echo "  • lsd - Enhanced ls with icons and colors"
echo "  • delta - Enhanced git diff viewer"
echo ""
echo "💡 These tools are now available as native commands"
echo "🌲 Configuration files created in ~/.config/tui-apps/"
echo ""
echo "💡 Run tui-apps-setup.sh to add Bash aliases and environment variables."
