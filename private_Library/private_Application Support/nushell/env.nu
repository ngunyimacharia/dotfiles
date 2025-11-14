# Nushell Environment Config File
#
# version = "0.108.0"

# Environment variables
$env.EDITOR = "nvim"
$env.SUDO_EDITOR = $env.EDITOR

# Path configuration
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    ($env.HOME | path join ".config" "composer" "vendor" "bin")
    ($env.HOME | path join ".local" "share" "mise" "installs" "node" "22.10.0" "bin")
    ($env.HOME | path join ".cargo" "bin")
    ($env.HOME | path join ".local" "bin")
    ($env.HOME | path join "go" "bin")
    ($env.HOME | path join ".opencode" "bin")
])

# 1Password SSH agent
$env.SSH_AUTH_SOCK = ($env.HOME | path join "Library" "Group Containers" "2BUA8C4S2C.com.1password" "t" "agent.sock")

# Android SDK configuration
$env.ANDROID_HOME = ($env.HOME | path join "Library" "Android" "sdk")
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    ($env.ANDROID_HOME | path join "emulator")
    ($env.ANDROID_HOME | path join "platform-tools")
])
$env.JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

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