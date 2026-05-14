---
description: Set up issue-tracker context and triage label conventions for agent workflows
---

Inspect the repo to determine whether this is a Laravel Boost project. Detection signals (in order of strength):
- `composer.json` requires `laravel/boost` (strong)
- `boost.json` exists (strong)
- `.ai/guidelines/` directory exists (weak)

If a strong signal is found, ask the user: "Detected Laravel Boost. Use Boost conventions?"
If only the weak signal is found, ask: "Found `.ai/guidelines/` directory. Is this a Laravel Boost project?"
If the user confirms the Boost branch:
- If `composer.json` requires `laravel/boost` but `boost.json` or `.ai/guidelines/` is missing, run `php artisan boost:install`.
- If `boost.json` exists, run `php artisan boost:update`.
- Then proceed with Boost file writing.

If the user declines or no signal is found, proceed to the upstream-lite branch.

Interview the user one question at a time:

1. Issue tracker: GitHub, Jira, or local markdown?
   - **GitHub**: Use the `gh` CLI (https://cli.github.com/).
     - Create: `gh issue create --title "..." --body "..."`
     - Read: `gh issue view <number> --comments`
     - List: `gh issue list --state open --json number,title,body,labels`
     - Comment: `gh issue comment <number> --body "..."`
     - Edit labels: `gh issue edit <number> --add-label "..." / --remove-label "..."`
     - Close: `gh issue close <number> --comment "..."`
   - **Jira**: Use the Atlassian CLI (`acli`) (https://developer.atlassian.com/cloud/acli/reference/commands/).
     - Authenticate first: `acli jira auth login`
     - Create: `acli jira workitem create --project <key> --type <type> --summary "..." --description "..."`
     - Read: `acli jira workitem view <issue-key>`
     - List/Search: `acli jira workitem search --jql "project = <key> AND status != Done"`
     - Comment: `acli jira workitem comment create <issue-key> --comment "..."`
     - Edit: `acli jira workitem edit <issue-key> --summary "..." --description "..."`
     - Transition: `acli jira workitem transition <issue-key> --transition "..."`
   - **Local markdown**: Issues live as `.md` files under a configurable directory (e.g., `.scratch/` or `docs/issues/`).
     - Create: Write a new `.md` file with frontmatter for title, status, and labels.
     - Read: Read the `.md` file directly.
     - List: List all `.md` files in the issues directory.
     - Update: Edit the `.md` file and update frontmatter/status.

2. Repo path / project identifier and how agents should interact with it:
   - For GitHub: infer from `git remote -v` or ask for `owner/repo`.
   - For Jira: ask for the project key (e.g., `PROJ`), Jira site URL, and default issue type.
   - For local markdown: ask for the directory path where issue files should live.

3. Triage label vocabulary: map the five canonical roles to actual project labels:
   - `needs-triage`
   - `needs-info`
   - `ready-for-agent`
   - `ready-for-human`
   - `wontfix`

Draft the following files in chat but DO NOT write them yet:

- Boost branch: `.ai/guidelines/issue-tracker.md`
- Upstream-lite branch: `docs/agents/issue-tracker.md` and update `CLAUDE.md` if present, otherwise `AGENTS.md`

Show a diff of the proposed changes against the current file state. Ask "Write these files?" and only proceed if the user explicitly confirms. If the user declines, leave the draft in chat for manual editing.
