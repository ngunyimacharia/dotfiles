# TUI Applications Configuration Module
# Source this file in your Nushell config to add TUI aliases

# Enhanced aliases for TUI applications
alias cat = bat
alias ls = lsd
alias top = btop

# Enhanced environment variables
export BAT_CONFIG_PATH = "$HOME/.config/tui-apps/bat.conf"
export LSD_CONFIG_FILE = "$HOME/.config/tui-apps/lsd.yaml"
export BTOP_CONFIG = "$HOME/.config/tui-apps/btop.conf"

echo "TUI applications aliases and environment configured!"