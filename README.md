# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) for consistent development environment across multiple systems.

## Supported Platforms

- **Linux**: Ubuntu, Debian, Pop!\_OS
- **macOS**: Darwin (Apple Silicon and Intel)

### Fedora Support Removed

Fedora support was removed due to network connectivity issues caused by Valet Linux's dnsmasq configuration conflicting with Fedora's NetworkManager. The DNS resolver conflicts resulted in unreliable internet connectivity.

## Features

### Modern Shell Experience

This repository uses **Nushell** as the default shell, providing:

- **Structured data pipelines**: Work with tables, records, and lists natively
- **Better error messages**: Clear, actionable error reporting
- **Cross-platform consistency**: Same shell experience on Linux and macOS
- **Type-aware completions**: Smart autocompletion based on data types
- **Integrated tooling**: Starship prompt and Zoxide navigation built-in

### Cross-Platform Configuration

- **Platform-specific files**: Uses chezmoi templating to apply OS-specific configurations
- **Conditional package installation**: Automated package installation scripts for Ubuntu and macOS
- **Smart file exclusion**: `.chezmoiignore` ensures platform-appropriate files are applied

### Development Tools

#### Neovim

- Full LazyVim configuration with custom plugins
- PHP/Laravel development support (Blade formatting, Laravel.nvim)
- Code formatting via conform.nvim and null-ls
- AI assistance with OpenCode integration
- Custom keymaps and autocmds

#### OpenCode AFK

[opencode-afk](bin/opencode-afk) automatically processes AFK (Away From Keyboard) tickets from `.scratch/*/issues/` directories. It scans issue files, launches pending work concurrently using opencode, and appends one structured `## AFK Summary` entry per attempt.

Those issue-file summaries are the default source of truth for post-run reporting. Raw logs stay as an explicit fallback only when additional detail is needed.

**Pre-execution validation:**

Before scanning for tickets, `opencode-afk` validates that `.scratch` is properly configured:
- `.scratch` must be listed in `.gitignore` (or equivalent) to ensure it stays local-only
- No files under `.scratch/**` may be tracked by git
- If `.scratch` does not exist, the command exits cleanly with a warning (no-op)

**Usage:**

```bash
# Process all pending AFK tickets
opencode-afk

# Select a model interactively
opencode-afk --select-model

# Use a specific model
opencode-afk --model claude-sonnet-4-20250514
```

**Example Output:**

```
$ opencode-afk
[INFO] 2026-05-15 10:00:00 Using model: claude-sonnet-4-20250514
[INFO] 2026-05-15 10:00:01 Scanning for AFK tickets...
[INFO] 2026-05-15 10:00:01 Selected 2 AFK ticket(s):
[INFO] 2026-05-15 10:00:01   - test-feature-a/01-implement-endpoint
[INFO] 2026-05-15 10:00:01   - test-feature-b/02-update-docs

[INFO] 2026-05-15 10:00:01 Tmux detected: launching tickets in new windows

[INFO] 2026-05-15 10:00:01 Starting: test-feature-a/01-implement-endpoint
[INFO] 2026-05-15 10:00:01 Starting: test-feature-b/02-update-docs

[INFO] 2026-05-15 10:00:02 Launch complete. Exiting without waiting for ticket completion.
```

**How it works:**

- **tmux mode**: When run inside tmux, each ticket launches in a new numbered window (`afk:1`, `afk:2`, etc.) for easy scanning. Logs are written to `.scratch/.opencode-afk-logs/` with descriptive filenames (e.g., `feature-slug-issue-name.log`).
- **Background mode**: Outside tmux, tickets run as background processes with a concurrency limit of 3.
- **Autoclose**: Successful tmux windows close automatically after logging completion. Failed or interrupted windows remain open for debugging.
- **Launch-and-log**: `opencode-afk` launches tickets and exits immediately without waiting for all work to finish or printing a final aggregate result. The issue file becomes the summary record for each attempt; raw logs remain fallback-only input.

**After AFK runs:**

- Use the `/afk-summary` slash command to get a read-only summary of completed, failed, and interrupted work from issue-file `## AFK Summary` blocks by default.
- If issue-file summaries are missing or incomplete, `/afk-summary` asks before reading raw logs from `.scratch/.opencode-afk-logs/`.
- Use the `/afk-cleanup` slash command to safely remove completed scratch tickets and their logs. This command is confirmation-gated and conservative: it preserves all pending work and shows a deletion plan before executing.

Example `## AFK Summary` block matching `private_dot_config/opencode/prompts/afk-prompt.md`:

```md
## AFK Summary

- Timestamp: 2026-05-15 10:00 UTC
- Session/run ID: afk-20260515-1000
- Issue reference: `.scratch/afk-summary-issue-driven/issues/04-document-issue-driven-afk-summary-workflow.md`
- Tracker status: ready-for-human
- Outcome: completed
- Commits: `docs: update AFK summary workflow docs`
- Notable changes: documented issue-file summaries as the default source of truth
- Files/areas touched: `README.md`
- Tests/checks run: `chezmoi diff`
- Blockers/errors: none
- Next action: none
```

**Customization:**

Customize AFK behavior by editing `~/.config/opencode/prompts/afk-prompt.md`. This prompt file defines the instructions given to opencode for each ticket.

#### Terminal & Shell

- **Nushell**: Modern shell with structured data pipelines as default shell
- **Kitty**: GPU-accelerated terminal emulator configured to use Nushell
- **Starship**: Fast, minimal prompt with Nushell integration
- **Zoxide**: Smart directory jumping integrated with Nushell
- **Bash**: Fallback shell configuration via `.bashrc` template for compatibility

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
│   ├── nushell/               # Nushell shell configuration
│   │   ├── config.nu          # Shell config and aliases
│   │   └── env.nu.tmpl        # Environment variables (templated)
│   ├── nvim/                  # Neovim configuration
│   ├── opencode/              # OpenCode AI assistant config
│   └── starship.toml          # Starship prompt config
├── systemd/                   # Systemd service files
│   └── syncthing.service      # Syncthing user service
└── run_*.sh                   # Automated setup scripts
```

## Configuration Files

### Shell

- `nushell/config.nu`: Nushell configuration with aliases and keybindings
- `nushell/env.nu`: Nushell environment variables (templated for cross-platform)
- `.bashrc`: Fallback bash configuration (templated)

### Editors

- `nvim/`: Complete Neovim setup with LazyVim
- OpenCode integration for AI-assisted coding

### Terminal & Shell

- Nushell: Modern shell with structured data support
- Kitty: Modern GPU-accelerated terminal configured with Nushell
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

### Nushell Usage

Nushell is configured as the default shell in Kitty. Key features:

**Smart Navigation:**

```nushell
z project  # Jump to frequently used directories with zoxide
cd ..      # Traditional navigation still works
```

**Laravel Aliases:**

```nushell
a migrate          # php artisan migrate
amfs               # php artisan migrate:fresh --seed
sail up            # Laravel Sail
```

**Structured Data:**

```nushell
ls | where size > 1mb | sort-by modified  # Filter and sort files
docker ps | to json                        # Convert to JSON
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
systemctl --user start syncthing
systemctl --user enable syncthing
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
