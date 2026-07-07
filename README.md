# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) for consistent development environment across multiple systems.

## Supported Platforms

- **Linux**: Ubuntu, Debian, Pop!\_OS
- **macOS**: Darwin (Apple Silicon and Intel)

### Fedora Support Removed

Fedora support was removed due to network connectivity issues caused by Valet Linux's dnsmasq configuration conflicting with Fedora's NetworkManager. The DNS resolver conflicts resulted in unreliable internet connectivity.

## Features

### Modern Bash Experience

This repository uses **Bash** as the default shell, providing:

- **Cross-platform compatibility**: Same shell baseline on Linux and macOS
- **Integrated tooling**: Starship prompt and Zoxide navigation
- **Development environment setup**: Laravel, Android, Bun, Composer, Go, and Rust paths
- **TUI aliases**: Optional bat, lsd, and btop aliases when installed

### Cross-Platform Configuration

- **Platform-specific files**: Uses chezmoi templating to apply OS-specific configurations
- **Conditional package installation**: Automated package installation scripts for Ubuntu and macOS
- **Smart file exclusion**: `.chezmoiignore` ensures platform-appropriate files are applied

### Development Tools

#### Neovim

- Full LazyVim configuration with custom plugins
- PHP/Laravel development support (Blade formatting, Laravel.nvim)
- Code formatting via conform.nvim and null-ls
- AI assistance with Claude Code (`claudecode.nvim`), OpenCode (`opencode.nvim`), and terminal harness integration
- Custom keymaps and autocmds

#### AI Coding Harnesses

This repository installs and configures multiple terminal-first AI coding agents:

- **Kimi Code CLI** — `kimi`
- **Claude Code** — `claude-code` (also available inside Neovim via `claudecode.nvim`)
- **OpenAI Codex** — `codex`
- **OpenCode** — `opencode`
- **Pi** — `@mariozechner/pi-coding-agent`

Each harness gets its own `AGENTS.md` under `~/.config/<harness>/` (or `~/.kimi/`, `~/.claude/`, `~/.codex/`) generated from shared templates. MCP servers (`context7`, `ray`) are wired for harnesses that support them.

#### Terminal & Shell

- **Bash**: Default shell configuration via `.bashrc` template
- **Kitty**: GPU-accelerated terminal emulator configured to use Bash
- **Starship**: Fast, minimal prompt with Bash integration
- **Zoxide**: Smart directory jumping integrated with Bash

#### Version Control

- Global `.gitignore` setup via `run_once_setup-gitignore.sh`
- Git configuration managed through chezmoi

### Linux-Specific Features

#### Custom Desktop Entries

Custom `.desktop` files in `dot_local/share/applications/` override default application launchers for better compatibility:

- **LazyDocker** (`lazydocker.desktop`): Custom launcher that opens lazydocker in a dedicated Kitty terminal window

#### Docker Icon

Custom Docker icon (`Docker.png`) in `dot_local/share/icons/` for improved visual consistency.

### macOS-Specific Features

- Homebrew package management
- Zen Browser installation
- PHP development tools (Valet, Laravel ecosystem)
- macOS-optimized applications (VSCode, 1Password, etc.)

### Ubuntu/Debian-Specific Features

- **Valet Linux Plus**: PHP development environment with Nginx
- **Laravel Takeout**: Docker-based service manager for development
- **Development utilities**: xclip, libfuse2, and other Linux-specific tools
- **Composer global packages**: PHP dependency management

## Installation

### Prerequisites

1. Install chezmoi:

   ```bash
   # macOS
   brew install chezmoi

   # Linux
   sh -c "$(curl -fsLS get.chezmoi.io)"
   ```

2. Initialize dotfiles:

   ```bash
   chezmoi init https://github.com/yourusername/dotfiles.git
   ```

3. Review changes before applying:

   ```bash
   chezmoi diff
   ```

4. Apply dotfiles:

   ```bash
   chezmoi apply
   ```

### Automatic Package Installation

The repository includes automated package installation scripts that run when applied:

- `run_once_setup-gitignore.sh`: Sets up global gitignore
- `run_once_setup-syncthing.sh`: Configures Syncthing service
- `run_onchange_ubuntu_install-packages.sh`: Installs Ubuntu/Debian packages
- `run_onchange_darwin_install-packages.sh`: Installs macOS packages via Homebrew
- `run_onchange_install-npm-packages.sh`: Installs global npm packages

These scripts:

- Only run on their respective platforms
- Check if packages are already installed before attempting installation
- Run automatically when files change or on first apply

## Structure

```
.
├── .chezmoiignore              # Platform-specific file exclusions
├── dot_bashrc.tmpl             # Bash configuration (Linux)
├── dot_local/                  # Linux-specific local files
│   └── share/
│       ├── applications/       # Custom .desktop entries
│       └── icons/              # Custom icons
├── private_dot_config/         # User configuration files
│   ├── kitty/                 # Kitty terminal config
│   ├── nvim/                  # Neovim configuration
│   ├── opencode/              # OpenCode AI assistant config
│   └── starship.toml          # Starship prompt config
├── systemd/                   # Systemd service files
│   └── syncthing@.service     # Syncthing boot service template
└── run_*.sh                   # Automated setup scripts
```

## Configuration Files

### Shell

- `.bashrc`: Bash configuration with aliases, environment variables, Starship, and zoxide

### Editors

- `nvim/`: Complete Neovim setup with LazyVim
- OpenCode integration for AI-assisted coding

### Terminal & Shell

- Bash: Default interactive shell configuration
- Kitty: Modern GPU-accelerated terminal configured with Bash
- Starship: Minimal, fast shell prompt
- Zoxide: Smart directory navigation

## Platform-Specific Exclusions

The `.chezmoiignore` file ensures platform-appropriate configuration:

**macOS excludes:**

- `.local` (Linux desktop entries/icons)

**Always excluded:**

- `.config/nvim/lazy-lock.json` (generated file)
- `.config/nvim/lazyvim.json` (generated file)

## Development Workflows

### Bash Usage

Bash is configured as the default shell in Kitty. Key features:

**Smart Navigation:**

```bash
z project  # Jump to frequently used directories with zoxide
cd ..      # Traditional navigation still works
```

**Laravel Aliases:**

```bash
a migrate          # php artisan migrate
amfs               # php artisan migrate:fresh --seed
sail up            # Laravel Sail
```

**Environment:**

- Starship prompt automatically loaded
- Zoxide for smart directory jumping
- All environment variables templated for cross-platform use

### PHP/Laravel Development

**Ubuntu/Debian:**

```bash
# Valet is automatically installed
valet start
valet park ~/Code

# Use Takeout for services
takeout enable mysql
```

**macOS:**

```bash
# Valet is automatically installed
valet start
valet park ~/Code
```

### Wireguard VPN

**Ubuntu/Debian:**

```bash
# Start VPN
sudo wg-quick up wg0

# Stop VPN
sudo wg-quick down wg0
```

### Syncthing

Systemd service is automatically configured on Linux:

```bash
sudo systemctl enable --now syncthing@$USER.service
```

## Updating

To update dotfiles from the repository:

```bash
# Pull latest changes
chezmoi update

# Or manually:
chezmoi git pull
chezmoi apply
```

## Customization

1. **Edit source files**:

   ```bash
   chezmoi edit ~/.bashrc
   ```

2. **Add new files**:

   ```bash
   chezmoi add ~/.config/newapp/config.toml
   ```

3. **Apply changes**:

   ```bash
   chezmoi apply
   ```

## Troubleshooting

- **Changes not applying**: Run `chezmoi diff` to see what would change
- **Platform-specific issues**: Check `.chezmoiignore` for exclusions
- **Package installation failures**: Check the relevant `run_*_install-packages.sh` script
- **Neovim issues**: Run `:checkhealth` in Neovim

## License

Personal dotfiles - use at your own discretion.
