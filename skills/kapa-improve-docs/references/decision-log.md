# The decision log

`.kapa/docs-improvements.md` in the docs repository records decisions that leave
no trace in the docs themselves, so a later run, a teammate or a scheduled task
does not propose them again. The docs and open pull requests record the rest.

Create it on first use, after telling the user, and commit it with the changes
it relates to. The log holds topics, counts and decisions drawn from what people
asked, so if the repository is public, say so first and offer to keep the log
out of git instead (listed in `.git/info/exclude`); a scheduled task then needs
it committed somewhere it can read, or it starts each run without it.

## Format

One entry per topic, newest first:

```markdown
## Deep thinking mode in the widget

- Decided: 2026-10-20, documented
- Signal: coverage gap "Default deep thinking in widget" (quarterly, Jul to Sep 2026), 8 conversations, 7 users; 11 uncertain answers
- Change: docs/integrations/website-widget/configuration/behavior.md, PR #123
- Why: no attribute pre-selects Thinking; the page now says so
```

Decisions: `documented`, `already covered`, `not supported, documented`,
`no change`, `noise`, `out of scope`, `not now`.

## Using it

- Match new items to entries by topic, not by cluster id: clusters are rebuilt
  every period with new ids.
- An entry closes a topic until its volume clearly grows, about double the
  conversations or users it was decided on. Then reopen it and say why.
- `not now` keeps an item in view; list it again when the next run starts.
- Keep entries short, and never put user questions, names or internal-project
  content in the log.
