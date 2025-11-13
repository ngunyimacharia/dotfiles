# Global Agent Guidelines

## Commit Guidelines

### Conventional Commits

Always use conventional commit format:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for formatting changes
- `refactor:` for code refactoring
- `test:` for adding tests
- `chore:` for maintenance tasks

### Context-Based Commits

Create separate commits based on logical context rather than committing all changes at once:

- Group related changes by component (e.g., nvim config, shell scripts, system configs)
- Separate feature additions from bug fixes
- Keep documentation updates in separate commits
- Split large refactoring into logical chunks

Examples:

- `feat(nvim): add avante plugin configuration`
- `fix(bash): correct PATH ordering in .bashrc`
- `chore(chezmoi): update gitignore patterns`
- `docs: update README with new setup instructions`

### Commit Authorship

- Do not add "opencode" as a co-author in commit messages
- Keep commits clean without AI tool attribution

## General Guidelines

- Use descriptive variable names and clear comments
- Follow existing patterns in similar files
- Test changes before committing to avoid breaking functionality

