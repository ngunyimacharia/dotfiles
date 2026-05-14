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
2. Tracker-specific configuration:
   - GitHub: infer from `git remote -v` or ask for `owner/repo`.
   - Jira: ask for the Jira site URL, project key (for example `PROJ`), and default issue type.
   - Local markdown: use the upstream `.scratch/<feature-slug>/` convention unless the user explicitly needs a different structure.
3. Triage label vocabulary: map the five canonical roles to actual project labels or status strings:
   - `needs-triage`
   - `needs-info`
   - `ready-for-agent`
   - `ready-for-human`
   - `wontfix`

Use these detailed conventions when drafting the output files.

For GitHub issue tracker output, generate content in this shape:

```md
# Issue tracker: GitHub

Issues and PRDs for this repo live as GitHub issues. Use the `gh` CLI for all operations.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`
  - Use a heredoc for multi-line bodies when needed.
- **Read an issue**: `gh issue view <number> --comments`
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'`
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply labels**: `gh issue edit <number> --add-label "..."`
- **Remove labels**: `gh issue edit <number> --remove-label "..."`
- **Close an issue**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v` when possible. `gh` usually handles this automatically inside a clone.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.
```


For Jira issue tracker output, generate content in this shape:

```md
# Issue tracker: Jira

Issues and PRDs for this repo live in Jira. Use the Atlassian CLI (`acli`) for all operations.

## Conventions

- **Authenticate first**: `acli jira auth login`
- **Create an issue**: `acli jira workitem create --project <key> --type <type> --summary "..." --description "..."`
- **Read an issue**: `acli jira workitem view <issue-key>`
- **Search issues**: `acli jira workitem search --jql "project = <key> AND status != Done"`
- **Comment on an issue**: `acli jira workitem comment create <issue-key> --comment "..."`
- **Edit an issue**: `acli jira workitem edit <issue-key> --summary "..." --description "..."`
- **Transition an issue**: `acli jira workitem transition <issue-key> --transition "..."`

Use the configured Jira site, project key, and default issue type for this repo.

## When a skill says "publish to the issue tracker"

Create a Jira issue in the configured project.

## When a skill says "fetch the relevant ticket"

Run `acli jira workitem view <issue-key>`.
```


For local markdown issue tracker output, generate content in this shape:

````md
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
````


Generate a separate triage labels file in this exact shape:

```md
# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the actual label strings or status values used in this repo's issue tracker.

| Label in mattpocock/skills | Label in our tracker | Meaning |
| -------------------------- | -------------------- | ------- |
| `needs-triage` | `needs-triage` | Maintainer needs to evaluate this issue |
| `needs-info` | `needs-info` | Waiting on reporter for more information |
| `ready-for-agent` | `ready-for-agent` | Fully specified, ready for an AFK agent |
| `ready-for-human` | `ready-for-human` | Requires human implementation |
| `wontfix` | `wontfix` | Will not be actioned |

When a skill mentions a triage role, use the corresponding label or status string from this table.
```

For the upstream-lite branch, update agent index files with this exact block shape:

```md
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.
```

Editing rules for the upstream-lite branch:

- If both `CLAUDE.md` and `AGENTS.md` exist, edit both.
- If only one exists, edit that file.
- If neither exists, ask the user which one to create.
- If `## Agent skills` already exists, update it in place.
- Do not duplicate the section.
- Do not remove surrounding user content.

Draft the following files in chat but DO NOT write them yet:

- Boost branch:
  - `.ai/guidelines/issue-tracker.md`
  - `.ai/guidelines/triage-labels.md`
- Upstream-lite branch:
  - `docs/agents/issue-tracker.md`
  - `docs/agents/triage-labels.md`
  - update `CLAUDE.md` and/or `AGENTS.md` using the `## Agent skills` block rules above

Do not add domain docs setup in v1.
Do not add GitLab support in v1.

Show a diff of the proposed changes against the current file state. Ask "Write these files?" and only proceed if the user explicitly confirms. If the user declines, leave the draft in chat for manual editing.
