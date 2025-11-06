# Fedora Support Implementation

This document outlines the Fedora support added to the dotfiles repository.

## New Files Created

- `run_onchange_fedora_install-packages.sh` - Main Fedora package installation script
- `run_onchange_fedora_spotify-setup.sh` - Fedora-specific Spotify setup via Flatpak

## Updated Files

- `run_onchange_linux_install-packages.sh` → `run_onchange_ubuntu_install-packages.sh` (renamed and updated OS detection)
- `run_onchange_linux_spotify-setup.sh` → `run_onchange_ubuntu_spotify-setup.sh` (renamed and updated OS detection)  
- `dot_bashrc.tmpl` - Updated to handle OS-specific paths properly

## Application Coverage Comparison

| Application | Ubuntu/Debian | Fedora | Installation Method |
|-------------|---------------|---------|-------------------|
| **Browsers** |
| Firefox | ✅ snap | ✅ dnf | Native package managers |
| Google Chrome | ✅ deb repository | ✅ dnf repository | Official repositories |
| Zen Browser | ✅ flatpak | ✅ flatpak | Flatpak |
| **Development Tools** |
| Neovim | ✅ ppa | ✅ dnf | Native package managers |
| Docker/Podman | ✅ docker | ✅ podman | Container runtimes |
| Golang | ✅ ppa | ✅ dnf | Native package managers |
| Node.js/npm | ✅ apt + nvm | ✅ dnf + nvm | Package managers + NVM |
| Stripe CLI | ✅ deb repository | ✅ dnf repository | Official repositories |
| Fly.io CLI | ✅ curl install | ✅ curl install | Direct installation |
| lazygit | ✅ github releases | ✅ copr repository | Different sources |
| ripgrep | ✅ apt | ✅ dnf | Native package managers |
| **AI Tools** |
| Ollama | ✅ curl install | ✅ curl install | Direct installation |
| Ollama Web UI | ✅ docker | ✅ podman | Container runtimes |
| OpenCode | ✅ curl install | ✅ curl install | Direct installation |
| **Terminal Tools** |
| Alacritty | ✅ apt | ✅ dnf | Native package managers |
| Zellij | ✅ github releases | ✅ dnf | Different sources |
| **Utilities** |
| 1Password | ✅ deb repository | ✅ dnf repository | Official repositories |
| Syncthing | ✅ deb repository | ✅ dnf repository | Official repositories |
| Wireguard | ✅ apt | ✅ dnf | Native package managers |
| xclip | ✅ apt | ✅ dnf | Native package managers |
| Variety | ✅ apt | ✅ dnf | Native package managers |
| **Communication** |
| Slack | ✅ snap | ✅ flatpak | Different app stores |
| Discord | ✅ snap | ✅ flatpak | Different app stores |
| Franz | ✅ manual download | ✅ flatpak | Different methods |
| **Media & Productivity** |
| Spotify | ✅ flatpak | ✅ flatpak | Flatpak |
| Obsidian | ✅ flatpak | ✅ flatpak | Flatpak |
| **Developer Tools** |
| Postman | ✅ snap | ✅ flatpak | Different app stores |
| ngrok | ✅ snap | ✅ dnf repository | Different sources |
| Beekeeper Studio | ✅ deb repository | ✅ flatpak | Different sources |
| freeze | ✅ manual download | ✅ go install | Different methods |

## Key Differences

### Package Managers
- **Ubuntu/Debian**: APT, Snap, Flatpak, manual downloads
- **Fedora**: DNF, Flatpak, COPR repositories, manual downloads

### Container Runtime
- **Ubuntu**: Docker
- **Fedora**: Podman (preferred container runtime)

### Repository Management
- **Ubuntu**: Uses PPAs for additional software
- **Fedora**: Uses COPR repositories and official third-party repos

### Application Installation Preferences
- **Ubuntu**: Prefers Snap for some apps (Slack, Discord, Postman, ngrok)
- **Fedora**: Prefers Flatpak for GUI applications, DNF for CLI tools

## OS Detection Logic

All scripts now use proper OS detection:

```bash
# For Ubuntu/Debian
if [ ! -f /etc/os-release ] || ! grep -qE "^ID=(ubuntu|debian)" /etc/os-release; then
  echo "Not on Ubuntu/Debian, skipping..."
  exit 0
fi

# For Fedora  
if [ ! -f /etc/os-release ] || ! grep -q "^ID=fedora" /etc/os-release; then
  echo "Not on Fedora, skipping..."
  exit 0
fi
```

## Testing

To test the Fedora support:

1. Run on a Fedora system: `chezmoi apply`
2. Check that `run_onchange_fedora_install-packages.sh` executes
3. Verify all applications install correctly
4. Confirm Ubuntu scripts are skipped

## Notes

- All applications from the Ubuntu script have equivalent installation methods on Fedora
- Some applications use different installation sources but provide the same functionality
- The dotfiles maintain feature parity across both distributions
- Container workloads automatically use the appropriate runtime (Docker on Ubuntu, Podman on Fedora)