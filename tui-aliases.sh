# TUI Aliases for Enhanced Terminal Experience
# This should be appended to your Bash config

# Enhanced commands for better terminal experience
# Note: `cat` is intentionally left untouched (bat decorates output and
# breaks scripts/git messages). Use `bat` directly for pretty output.
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  alias bat='batcat'
fi
command -v lsd >/dev/null 2>&1 && alias ls='lsd'
command -v btop >/dev/null 2>&1 && alias top='btop'

export BAT_CONFIG_PATH="$HOME/.config/tui-apps/bat.conf"
export LSD_CONFIG_FILE="$HOME/.config/tui-apps/lsd.yaml"
export BTOP_CONFIG="$HOME/.config/tui-apps/btop.conf"

# These aliases will be active once you restart your shell
# Run `tui-apps-setup.sh` to install and configure the applications
