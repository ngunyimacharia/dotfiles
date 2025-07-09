# Agent Guidelines for Chezmoi Dotfiles Repository

## Build/Test Commands
- No traditional build system - this is a chezmoi dotfiles repository
- Apply changes: `chezmoi apply`
- Check diff: `chezmoi diff`
- Test shell scripts: Run individual scripts in `run_*` files
- Format Lua: `stylua .` (uses stylua.toml config)
- Format PHP/Blade: Uses prettier and blade-formatter via conform.nvim

## Code Style Guidelines

### Shell Scripts
- Use `#!/bin/sh` shebang for POSIX compatibility
- Check command success with `$?` and conditional logic
- Echo status messages for user feedback
- Use proper error redirection (`2>&1`)

### Lua (Neovim Config)
- 2-space indentation (per stylua.toml)
- 120 character line width
- Use double quotes for strings
- Follow LazyVim plugin structure patterns
- Conditional formatters based on config file presence

### General
- Use descriptive variable names and clear comments
- Follow existing patterns in similar files
- Test changes before committing to avoid breaking dotfiles setup