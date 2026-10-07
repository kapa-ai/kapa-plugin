# Kapa

Kapa is an ingestion and retrieval system for a team's unstructured knowledge.
This plugin connects your agent to the Kapa platform so you can set a project
up, watch it ingest, query it, and read its analytics without leaving the
terminal.

## Signing in

Every tool acts as you, with your real permissions. Sign in once with `/mcp`
in Claude Code, or your client's equivalent. There is no API key to configure
here: a Kapa API key is something you create *for your own code*, not for this
connection.

Start with `list_projects`, which takes no arguments and returns your team and
its projects.

## Setting up a source

Two calls for every source: `create_*_source` returns an id, then a config
call tells it what to ingest. **Saving that config starts the ingest**, so
there is no publish step to look for.

A web crawl is the exception. It ingests nothing until `start_crawl` runs, and
it is worth previewing first:

1. `create_web_crawl_source`, then `set_crawl_config`
2. `preview_crawl` and `list_preview_pages` to see what it finds
3. `inspect_content_selector` until the extracted text is the article body
4. `set_content_selector`, then `start_crawl`

Only the last step spends the team's quota.

## The skills

There is one skill per source type, and each carries the exact call order plus
the out-of-band setup people miss, such as inviting a Slack bot to the channel
or sharing Notion pages with the integration. Load the one that matches what
the user chose rather than working it out from tool descriptions.

## Closing coverage gaps

To turn coverage gaps or feedback into documentation, load the
`kapa-docs-from-gaps` skill. It covers finding the gaps and untriaged feedback,
drafting the fix, and tracking each gap's status in Kapa (in progress, resolved
or dismissed) across runs. Gap statuses are kept on the project's saved gaps
list, so check `list_coverage_gap_records` before working on a gap. A gap found
again in a new period is linked to its existing entry by passing `record_id` to
`update_coverage_gap`, rather than starting a second entry.

## Rules that matter

- **Credentials belong to the user.** Ask for every token and key. Never
  invent one, never reuse one across sources.
- **Ingesting spends quota.** Saving a source's configuration starts
  ingestion, and so does `start_crawl` for a web crawl. Confirm with the user
  before either.
- **Do not choose filters for people.** What belongs in a knowledge base
  differs per team, so show the options and ask.
- **Check before you save.** Every source has a validate tool and most have
  discovery tools. Use them: a wrong credential otherwise shows up as a source
  that silently ingests nothing.
- **Use `search_kapa_docs`** when unsure how a Kapa feature works.
