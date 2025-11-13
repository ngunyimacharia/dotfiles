# Nushell Config File
#
# version = "0.108.0"

# Load Starship prompt
use ~/.cache/starship/init.nu

# Load zoxide
source ~/.zoxide.nu

# Aliases
# Laravel specific
alias a = php artisan
alias amfs = php artisan migrate:fresh --seed
alias sail = if ('sail' | path exists) { sh sail } else { sh vendor/bin/sail }
alias takeout = docker run --rm -v /var/run/docker.sock:/var/run/docker.sock --add-host=host.docker.internal:host-gateway -it tighten/takeout:latest

# Android emulator (Linux only)
alias start-emulator = emulator @Pixel_9 -sysdir $env.ANDROID_SDK_ROOT/system-images/android-36.1/google_apis_playstore/x86_64/ &

# Configuration
$env.config = {
  show_banner: false
  edit_mode: emacs
  buffer_editor: "nvim"
}
