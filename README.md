# Kapa plugin

A plugin that bundles the Kapa platform MCP server with skills for agents, so
your agent can set up knowledge sources, search them and read analytics in a
Kapa project. Sign in once and the tools act as you, with your Kapa
permissions.

[Kapa](https://www.kapa.ai) is an ingestion and retrieval system.
[Ingestion](https://docs.kapa.ai/knowledge-sources/data-ingestion) builds one
knowledge base from [20+ types of sources](https://docs.kapa.ai/knowledge-sources)
and keeps it up to date as that content changes.
[Agentic retrieval](https://docs.kapa.ai/retrieval) searches across it to find
what an agent needs. You hand Kapa to your agents as a search tool via
[MCP](https://docs.kapa.ai/retrieval/hosted-mcp-server) or the
[API](https://docs.kapa.ai/retrieval/http-api), or use one of the
[prebuilt agents](https://docs.kapa.ai/integrations), such as a website widget
or a Slack bot.

## Install

### Claude Code

```
/plugin marketplace add kapa-ai/kapa-plugin
/plugin install kapa
```

### Codex

```bash
codex plugin marketplace add kapa-ai/kapa-plugin
codex plugin add kapa@kapa
```

### Cursor

Inside Cursor's agent chat:

```
/add-plugin kapa
```

Or install the plugin from its
[Cursor Marketplace listing](https://cursor.com/marketplace/kapa).

### Every other client

Add the MCP server to your client's configuration:

```json
{ "mcpServers": { "kapa": { "url": "https://mcp.kapa.ai/mcp" } } }
```

Then copy `skills/` into wherever that client reads skills from, so the agent
gets the call sequences rather than only the tool list.

## What it can do

The plugin bundles the Kapa platform MCP server with skills for working with
the platform, and lets you do the following.

### Configure sources

Index your [knowledge sources](https://docs.kapa.ai/knowledge-sources) in a
Kapa project. You can create new sources or edit the configuration of
existing ones.

Start with `kapa-setup`, or ask: *"add our documentation site to Kapa"*. The
agent asks what you want to ingest, then loads the setup skill for that
source.

The following knowledge sources are supported:

- [Web crawl](https://docs.kapa.ai/knowledge-sources/connectors/web-crawling)
- [GitHub files](https://docs.kapa.ai/knowledge-sources/connectors/github-code)
- [GitHub issues](https://docs.kapa.ai/knowledge-sources/connectors/github-issues)
- [GitHub discussions](https://docs.kapa.ai/knowledge-sources/connectors/github-discussions)
- [GitHub pull requests](https://docs.kapa.ai/knowledge-sources/connectors/github-pull-requests)
- [Zendesk Help Center](https://docs.kapa.ai/knowledge-sources/connectors/zendesk-help-center)
- [Zendesk tickets](https://docs.kapa.ai/knowledge-sources/connectors/zendesk-support-tickets)
- [Confluence](https://docs.kapa.ai/knowledge-sources/connectors/confluence)
- [Jira](https://docs.kapa.ai/knowledge-sources/connectors/jira)
- [Jira Service Management](https://docs.kapa.ai/knowledge-sources/connectors/jira-service-management)
- [Notion](https://docs.kapa.ai/knowledge-sources/connectors/notion)
- [Slack](https://docs.kapa.ai/knowledge-sources/connectors/slack)
- [Discord](https://docs.kapa.ai/knowledge-sources/connectors/discord)
- [Discourse](https://docs.kapa.ai/knowledge-sources/connectors/discourse)
- [Google Drive](https://docs.kapa.ai/knowledge-sources/connectors/google-drive)
- [OpenAPI](https://docs.kapa.ai/knowledge-sources/connectors/openapi)
- [YouTube](https://docs.kapa.ai/knowledge-sources/connectors/youtube)
- [S3](https://docs.kapa.ai/knowledge-sources/connectors/s3-storage)
- [Hand-written answers](https://docs.kapa.ai/knowledge-sources/connectors/custom-qa)

### Search your knowledge base

All indexed sources can be searched with
[agentic retrieval](https://docs.kapa.ai/retrieval) through this plugin. For
example, ask: *"what does our knowledge base say about SSO?"*

Searching through the plugin is mainly for testing what your knowledge base
returns. To put it in front of users or agents, use the
[prebuilt agents](https://docs.kapa.ai/integrations), a
[hosted MCP server](https://docs.kapa.ai/retrieval/hosted-mcp-server) or the
[retrieval API](https://docs.kapa.ai/retrieval/http-api).

### Read analytics

Every question that flows through Kapa, whichever agent or interface asked it,
is kept as a conversation. This plugin gives your agent access to Kapa's
[analytics](https://docs.kapa.ai/analytics), so it can pull the
[top questions](https://docs.kapa.ai/analytics/top-questions) and
[coverage gaps](https://docs.kapa.ai/analytics/coverage-gaps) for a period, or
look through [conversations](https://docs.kapa.ai/analytics/conversations).
`kapa-gaps` combines the latest gaps and top questions into suggestions for
what to write next.
