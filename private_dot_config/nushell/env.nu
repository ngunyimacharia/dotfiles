# Nushell Environment Config File
#
# version = "0.108.0"

# Environment variables
$env.EDITOR = "nvim"
$env.SUDO_EDITOR = $env.EDITOR

# Terminal compatibility fallback
let current_term = ($env.TERM? | default "")
if ($current_term in ["xterm-kitty" "xterm-ghostty"]) {
    let infocmp_available = (try { which infocmp | is-not-empty } catch { false })
    if $infocmp_available {
        let terminfo_ok = (try { (^infocmp $current_term | complete).exit_code == 0 } catch { false })
        if (not $terminfo_ok) {
            $env.TERM = "xterm-256color"
        }
    } else {
        $env.TERM = "xterm-256color"
    }
}

# Android SDK configuration
$env.ANDROID_SDK_ROOT = "/home/raven/Android/Sdk"
$env.ANDROID_HOME = "/home/raven/Android/Sdk"
$env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"

# Path configuration
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    "/usr/local/bin"
    ($env.HOME | path join ".config" "composer" "vendor" "bin")
    ($env.HOME | path join ".local" "share" "mise" "installs" "node" "22.10.0" "bin")
    ($env.HOME | path join ".cargo" "bin")
    ($env.HOME | path join ".local" "bin")
    ($env.HOME | path join "go" "bin")
    ($env.HOME | path join ".opencode" "bin")
    ($env.ANDROID_SDK_ROOT | path join "emulator")
    ($env.ANDROID_SDK_ROOT | path join "platform-tools")
])

# 1Password SSH agent
$env.SSH_AUTH_SOCK = ($env.HOME | path join ".1password" "agent.sock")

# NVM Directory
$env.NVM_DIR = ($env.HOME | path join ".nvm")

# Starship prompt
try {
    mkdir ~/.cache/starship
    if (which starship | is-not-empty) {
        starship init nu | save -f ~/.cache/starship/init.nu
    }
} catch { |e| }

# Zoxide (replaces cd command)
try {
    if (which zoxide | is-not-empty) {
        zoxide init nushell --cmd cd | save -f ~/.zoxide.nu
    }
} catch { |e| }
