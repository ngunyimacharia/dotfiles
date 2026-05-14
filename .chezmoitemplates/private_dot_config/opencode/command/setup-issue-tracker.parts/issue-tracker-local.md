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
