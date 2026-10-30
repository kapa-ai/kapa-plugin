---
name: kapa-improve-docs
description: Improve a documentation repository from what people ask Kapa. Combines coverage gaps, uncertain and downvoted answers, top questions and source usage into one worklist, checks each item against the docs and optionally an internal Kapa project, and works through it with the user or opens pull requests. Use when the user wants to improve their docs, close coverage gaps or act on Kapa analytics.
---

# Improve the docs from what people ask

Run this from the root of the documentation repository the Kapa project answers
from. Every judgement comes from reading the actual pages in this repo; the
analytics only say where to look.

## 1. Set up

1. `list_projects`, then ask which project holds the public traffic, unless the
   user already said.
2. Ask whether the team keeps an **internal project**: one that indexes support
   tickets, an internal wiki, Slack and similar. If so, note its id. It settles
   whether something is missing from the docs or not supported at all (step 4).
3. Agree on a window, by default the last 30 days, and say it back.
4. Read `.kapa/docs-improvements.md` if it exists. It is the decision log of
   earlier runs ([the log](references/decision-log.md)).
5. If the repo has no docs-looking content (Markdown or MDX pages, a docs config
   such as `docusaurus.config.*`, `mint.json` or `mkdocs.yml`), ask the user to
   switch to their docs repo before going on.

## 2. Build the worklist

Pull every signal, smallest responses first, and keep each item's evidence.

- **Uncertain answers:** `search_conversations` with `confidence_filter=uncertain`,
  the window's `start_date` and `end_date`, and `page_size` 25. Page with the
  URL-decoded `cursor` from `next` up to about 100 conversations, then check
  each candidate topic with `search_text` rather than paging through the rest.
- **Rated answers:** `search_conversations` with `reaction_filter=DOWNVOTE`, then
  `COMMENT`. Read the ones that matter with `get_thread` and
  `include_source_content=false`, which keeps each cited source's URL and title
  but not its full text; a feedback `comment` is a JSON string inside the field.
- **Coverage gaps:** `list_coverage_gaps_periods`, then `get_coverage_gaps` with
  the period's `id` and `threads_limit=0`, for the newest period that has
  clusters. Shorter periods are
  often empty for a mid-sized project, so fall back from weekly to monthly to
  quarterly, and say which window you used. Each cluster carries Kapa's
  `suggestion`.
- **Top questions:** `list_top_questions_periods`, then `get_top_questions` with
  the period's `id` and `threads_limit=0` to scan titles and counts. Fetch threads (`threads_limit` 5
  to 10) only for clusters you pick.
- **Agent feedback:** `list_agent_feedback` with `category=documentation` for
  the window. Agents using the project's hosted MCP servers report there where
  the docs blocked them.
- **Pages behind bad answers:** `get_source_usage` for the window, drilling down
  with `url_path`, then `list_source_questions` for pages that recur in uncertain
  or downvoted answers.

Then merge:

1. Group items about the same topic, whichever signal they came from. A topic hit
   by a gap, uncertain answers and a top-question cluster is one item.
2. Rank by **unique users** where the tools report them (the clusters), and by
   conversations otherwise. Set aside clusters where one person asked many
   times, test traffic, and agent traffic: requests that read like
   instructions ("set up a webcrawl for…") come from agents such as this plugin's
   setup skills, not from people reading the docs.
3. Drop items the docs now answer where people would look (read them), items an
   open pull request already covers (`gh pr list --search <topic>` or the host's
   equivalent), and items the log closed, unless their volume has since clearly
   grown. Keep an item the docs cover but people still miss: it may need a better
   heading, wording or link.

Show the user the ranked list, with counts and one representative question per
item, and agree where to start.

## 3. Work through it, one item at a time

For each item, follow the method for its kind in [the methods](references/methods.md):
read the conversations behind it, read the pages, and decide between a change to
the docs and no change. The bar for a change is high: name the page, the change,
the counts and at least three questions it would have helped, quoted as asked
but never with names, emails or other personal data from the conversations.

Present the recommendation, wait for the user's decision, and make the edit if
they want it now. Record every decision in the log, including "no change".

## 4. Check the internal project

When there is one, and an item looks like missing documentation, search it with
`search_project_knowledge` on the internal project id before deciding. Each
search is a real query on that project, counted toward its quota and shown in
its analytics, so before the first one tell the user which project and roughly
how many searches, and go on only with their go-ahead. The same applies to
searching the public project. Pass
`source_ids_include` with its internal sources (`list_sources`) so the public
docs it may also index do not answer for themselves.

The internal project answers a question the docs cannot: is this supported, and
how. A support reply or a wiki page often turns "missing" into a concrete fix,
or into "not supported", which is worth documenting too.

**Everything from the internal project is confidential.** Follow
[the rules for internal results](references/internal-project.md) without
exception: propose only what would be fine in public docs, never quote it, and
leave anything withheld on purpose to a human.

## 5. Finish

Summarise what changed, what was decided against and why, and what is left in
the worklist. Commit the log with the changes.

## Running unattended

In a scheduled task there is no one to ask. Then:

- Use the defaults above and the project and internal project named in the
  task's prompt.
- Search a project only if the task's prompt allows it; otherwise decide from
  the docs alone and flag the items a search would have settled.
- Open at most two pull requests, each for one topic, and record every other item
  in the log as "not now" with its counts, so the next run sees it.
- Mark any change informed by the internal project for human review in the pull
  request description, and never merge.
