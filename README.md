## Supported Distributions

This dotfiles repository supports:
- Ubuntu/Debian-based distributions
- macOS (Darwin)
- Pop!_OS

## Fedora Support Removed

Fedora support was removed due to network connectivity issues caused by Valet Linux's dnsmasq configuration conflicting with Fedora's NetworkManager. The DNS resolver conflicts resulted in unreliable internet connectivity.

## Custom Desktop Entries

Custom `.desktop` files in `dot_local/share/applications/` override default application launchers for better compatibility and user experience:

- **1Password** (`1password.desktop`): Adds `--disable-gpu` flag to prevent GPU-related crashes on Wayland/X11
- **Google Chrome** (`google-chrome.desktop`): Adds `--disable-gpu` flag to all launch modes (normal, new window, incognito) for stable rendering on Linux
- **Slack** (`slack_slack.desktop`): Adds `--disable-gpu` flag to fix rendering issues with the Snap package
- **LazyDocker** (`lazydocker.desktop`): Creates a custom launcher that opens lazydocker in a dedicated Ghostty terminal window for container management

These entries are managed by chezmoi and override system-default launchers when present.

## Wireguard usage

Start: `sudo wg-quick up wg0`
Stop: `sudo wg-quick down wg0`
