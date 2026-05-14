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
