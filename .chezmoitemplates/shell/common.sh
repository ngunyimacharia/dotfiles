# Shared bash/zsh configuration.
#
# Included by ~/.bashrc and ~/.zshrc through chezmoi's template directive.
# Linux gets ~/.bashrc and macOS gets ~/.zshrc (see .chezmoiignore), so this
# file is the single place to change anything both machines should share.
# Keep it POSIX-compatible: it is parsed by bash AND zsh.
# Shell-specific setup (prompt init, completion system) stays in the rc files.

# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

# Terminal compatibility fallback
case "$TERM" in
  xterm-kitty)
    if command -v infocmp >/dev/null 2>&1; then
      infocmp "$TERM" >/dev/null 2>&1 || export TERM="xterm-256color"
    else
      export TERM="xterm-256color"
    fi
    ;;
esac

# Path edits
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="$PATH:$HOME/.config/composer/vendor/bin"
export PATH="$HOME/.local/share/lerd/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/kitty.app/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"

# mise-managed runtimes. The shims directory is version-agnostic, so it does
# not rot the way a pinned .../installs/node/<version>/bin path does. Appended
# (not prepended) so nvm still wins, exactly like the pinned path did.
if [ -d "$HOME/.local/share/mise/shims" ]; then
  export PATH="$PATH:$HOME/.local/share/mise/shims"
fi

# 1Password SSH agent
{{ if eq .chezmoi.os "linux" -}}
export SSH_AUTH_SOCK=~/.1password/agent.sock
{{ else if eq .chezmoi.os "darwin" -}}
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
{{ end }}
# Enhanced Terminal Aliases (via TUI Apps)
# Note: `cat` is intentionally left untouched (bat decorates output and
# breaks scripts/git messages). Use `bat` directly for pretty output.
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  alias bat='batcat'
fi
if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd'
fi
if command -v btop >/dev/null 2>&1; then
  alias top='btop'
fi

# No BAT_CONFIG_PATH / LSD_CONFIG_FILE / BTOP_CONFIG here on purpose. Those
# pointed at ~/.config/tui-apps/, where only bat ever read its file: lsd 1.0.0
# ignores LSD_CONFIG_FILE, and BTOP_CONFIG is not a variable btop knows. All
# three configs now live at the paths each tool reads natively and are managed
# by chezmoi, themed from .chezmoidata/palette.toml.

# Laravel specific
alias a='php artisan'
alias amfs='php artisan migrate:fresh --seed'
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Activate the default Node.js version (set via `nvm alias default`)
command -v nvm >/dev/null 2>&1 && nvm use default --silent

if [ -f "$HOME/.env" ]; then
  set -a
  . "$HOME/.env"
  set +a
fi

# opencode v1 (curl installer) / v2 (npm beta, side-by-side)
export PATH="$HOME/.opencode/bin:$PATH"
if [ -x "$HOME/.opencode2/bin/opencode" ]; then
  alias opencode="$HOME/.opencode2/bin/opencode"
fi
if [ -x "$HOME/.opencode/bin/opencode" ]; then
  alias opencode1="$HOME/.opencode/bin/opencode"
fi

# AI harness convenience aliases
if command -v claude >/dev/null 2>&1; then
  alias cc='claude'
fi
if command -v codex >/dev/null 2>&1; then
  alias cx='codex'
fi
if command -v opencode >/dev/null 2>&1; then
  alias oc='opencode'
fi
if command -v pi >/dev/null 2>&1; then
  alias p='pi'
fi

# Claude Code profile switching (work vs personal)
claude-work() {
  CLAUDE_CONFIG_DIR="$HOME/.claude" claude "$@"
}
claude-personal() {
  CLAUDE_CONFIG_DIR="$HOME/.claude-personal" claude "$@"
}

# Shared terminal/app theme switcher
theme() {
  "$HOME/bin/theme" "$@"
}

# Bun (JavaScript runtime) installation
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Android SDK configuration
{{ if eq .chezmoi.os "linux" -}}
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools
alias start-emulator="emulator @Pixel_9 -sysdir \$ANDROID_SDK_ROOT/system-images/android-36.1/google_apis_playstore/x86_64/ &"

# Locate a JDK 21 wherever the distro put it. Ubuntu/Debian append the arch
# (-amd64/-arm64), Arch does not. Probing beats pinning one distro's layout.
if [ -z "${JAVA_HOME:-}" ]; then
  for _jdk in \
    /usr/lib/jvm/java-21-openjdk-amd64 \
    /usr/lib/jvm/java-21-openjdk-arm64 \
    /usr/lib/jvm/java-21-openjdk \
    /usr/lib/jvm/default-java; do
    if [ -d "$_jdk" ]; then
      export JAVA_HOME="$_jdk"
      break
    fi
  done
  unset _jdk
fi
{{ else if eq .chezmoi.os "darwin" -}}
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools

# Ask macOS for the JDK instead of pinning a Zulu path that moves on upgrade.
# Prefer 17 (what this machine has), fall back to whatever is newest.
if [ -z "${JAVA_HOME:-}" ] && [ -x /usr/libexec/java_home ]; then
  _jdk="$(/usr/libexec/java_home -v 17 2>/dev/null || /usr/libexec/java_home 2>/dev/null || true)"
  [ -n "$_jdk" ] && export JAVA_HOME="$_jdk"
  unset _jdk
fi
{{ end -}}
