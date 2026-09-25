# Kapa

Kapa turns a team's technical content into a RAG assistant. This plugin
connects your agent to the Kapa platform so you can set a project up, watch it
ingest, query it, and read its analytics without leaving the terminal.

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

1. `create_web_source`, then `set_crawl_config`
2. `preview_crawl` and `list_preview_pages` to see what it finds
3. `inspect_content_selector` until the extracted text is the article body
4. `set_content_selector`, then `start_crawl`

Only the last step spends the team's quota.

## The skills

There is one skill per source type, and each carries the exact call order plus
the out-of-band setup people miss, such as inviting a Slack bot to the channel
or sharing Notion pages with the integration. Load the one that matches what
the user chose rather than working it out from tool descriptions.

## Rules that matter

- **Credentials belong to the user.** Ask for every token and key. Never
  invent one, never reuse one across sources.
- **Ingesting spends quota.** Confirm before `start_crawl`.
- **Do not choose filters for people.** What belongs in a knowledge base
  differs per team, so show the options and ask.
- **Check before you save.** Every source has a validate tool and most have
  discovery tools. Use them: a wrong credential otherwise shows up as a source
  that silently ingests nothing.
- **Use `search_kapa_docs`** when unsure how a Kapa feature works.
