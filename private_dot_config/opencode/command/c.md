---
description: Commit changes using conventional commits
---

Commit the current changes using conventional commit format. Never attribute model or opencode. Never use emojis, never be friendly. Always use separate commits if makes sense. Analyze the changes and create appropriate commit messages following the conventional commit format: feat, fix, docs, style, refactor, test, chore. Group related changes by component and create separate commits for different types of changes.

Before creating any commit, determine and run every relevant project quality check that should pass for the current changes. Inspect the project's GitHub workflows plus `composer.json` and `package.json` to identify the authoritative commands. Include all relevant categories:

- Formatters and linters such as Prettier, Pint, PHP CS Fixer, ESLint, or equivalent project-specific tools.
- Static analysis such as PHPStan, Larastan, TypeScript checks, or equivalent project-specific tools.
- Tests affected by the changes. Prefer the narrowest reliable scope, but if the repo's workflow or tooling indicates broader coverage is required, run that broader suite.

Do not guess when the repo defines the commands explicitly. Prefer the exact project commands from scripts, composer scripts, make targets, task runners, or workflow files. If a required check fails, stop, report the failure, and do not commit until all required checks pass.
