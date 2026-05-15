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

# Issue tracker: Local Markdown

Issues and PRDs for this repo live as markdown files under `.scratch/`.

## Conventions

- One feature per directory: `.scratch/<feature-slug>/`
- The PRD is `.scratch/<feature-slug>/PRD.md`
- Implementation issues are `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01`
- Triage state is recorded as a `Status:` line near the top of each issue file
- Comments and conversation history append under a `## Comments` heading

## Example layout

```text
.scratch/
  checkout-redesign/
    PRD.md
    issues/
      01-cart-summary.md
      02-payment-form.md
```

## When a skill says "publish to the issue tracker"

Create a new file in the appropriate `.scratch/<feature-slug>/` location, creating directories if needed.

## When a skill says "fetch the relevant ticket"

Read the referenced markdown file directly.

# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the actual label strings or status values used in this repo's issue tracker.

| Label in mattpocock/skills | Label in our tracker | Meaning                                  |
| -------------------------- | -------------------- | ---------------------------------------- |
| `needs-triage`             | `needs-triage`       | Maintainer needs to evaluate this issue  |
| `needs-info`               | `needs-info`         | Waiting on reporter for more information |
| `ready-for-agent`          | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human`          | `ready-for-human`    | Requires human implementation            |
| `wontfix`                  | `wontfix`            | Will not be actioned                     |

When a skill mentions a triage role, use the corresponding label or status string from this table.

