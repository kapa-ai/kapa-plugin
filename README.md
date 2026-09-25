# Kapa plugin

Set up and inspect a [Kapa](https://www.kapa.ai) project from your coding
agent. Connects the hosted Kapa MCP server and bundles a skill for every
source type.

## What you get

- **The Kapa MCP server**, wired up on install. Sign in once and the tools act
  as you, with your real permissions.
- **19 setup skills**, one per source type, each carrying the exact call order
  and the setup steps people miss.
- **Three commands**: `/kapa-setup`, `/kapa-check`, `/kapa-gaps`.

> **Local testing.** The manifests point at `http://localhost:8004/mcp`, where
> kapa-mcp runs in the dev workspace. Switch them to `https://mcp.kapa.ai/mcp`
> before publishing.

## Install

### Claude Code

```
/plugin marketplace add kapa-ai/kapa-plugin
/plugin install kapa
```

### Cursor, Codex, Gemini, opencode

Clone the repo and point your client at it, or add the server directly:

```json
{ "mcpServers": { "kapa": { "url": "http://localhost:8004/mcp" } } }
```

## Use it

```
/kapa-setup     connect a knowledge source
/kapa-check     see what the project holds and whether it answers
/kapa-gaps      find what people ask that your content does not cover
```

Or just ask: *"add our documentation site to Kapa"*.

## Sources it can set up

Web crawl, GitHub (files, issues, discussions, pull requests), Zendesk (help
center, tickets), Confluence, Jira, Jira Service Management, Notion, Slack,
Discord, Discourse, Google Drive, OpenAPI, YouTube, S3, and hand-written
answers.

## Links

- [Kapa docs](https://docs.kapa.ai)
- [Hosted MCP servers](https://docs.kapa.ai/integrations/mcp/overview)
