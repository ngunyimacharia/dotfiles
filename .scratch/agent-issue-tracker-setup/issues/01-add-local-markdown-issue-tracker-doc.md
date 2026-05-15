Status: done

## Title

Add the local markdown issue tracker guide

## Why

Agent skills need a repo-local source of truth for where PRDs and implementation issues are stored. This slice documents the selected upstream-lite `.scratch/<feature-slug>/` convention without changing any runtime dotfiles behavior.

## Scope

Includes:
- Create `docs/agents/issue-tracker.md` with the exact local markdown tracker content below.
- Preserve the selected upstream `.scratch/<feature-slug>/` layout and local markdown publish/fetch instructions.

Excludes:
- Triage label mapping; that is handled in issue 02.
- Updating root `AGENTS.md`; that is handled in issue 03.
- Creating or modifying any real implementation issues beyond this planning issue.

## Context

- Parent PRD/spec: `.scratch/agent-issue-tracker-setup/PRD.md`
- Relevant design/tech notes: upstream-lite branch selected because Laravel Boost signals were absent.

Required file content:

~~~md
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
~~~

## Dependencies

Blocking:
- None

Related:
- `.scratch/agent-issue-tracker-setup/issues/02-add-default-triage-label-mapping-doc.md`
- `.scratch/agent-issue-tracker-setup/issues/03-advertise-agent-tracker-docs-in-agents.md`

## Acceptance Criteria

1. `docs/agents/issue-tracker.md` exists.
2. The file content exactly matches the required markdown in this issue.
3. The documented layout uses `.scratch/<feature-slug>/PRD.md` and `.scratch/<feature-slug>/issues/<NN>-<slug>.md`.
4. The file states that triage state is recorded as a `Status:` line near the top of each issue file.

## Verification

- Read `docs/agents/issue-tracker.md` and compare it to the required content in this issue.
- Confirm no unrelated files are changed by this issue.

## Classification

- Executor: `AFK`
- Rationale: The exact target path and file content are fully specified and require no product, design, or architecture decision.
