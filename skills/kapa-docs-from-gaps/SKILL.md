---
name: kapa-docs-from-gaps
description: Turn Kapa coverage gaps and user or agent feedback into documentation fixes, and track each gap's status in Kapa until the fix is published and retrievable. Use when the user wants to close coverage gaps, act on feedback, write missing docs from what people ask, or follow up on docs fixes already in progress.
---

# Close coverage gaps with documentation

A coverage gap is a cluster of questions Kapa answered uncertainly. Feedback is
an end user downvoting or commenting on an answer, or an AI agent reporting what
the docs are missing. This skill turns both into documentation, and keeps each
gap's status in Kapa current so the docs team and the dashboard see the same
picture.

The work is a loop that spans several runs. One run drafts fixes and marks them
in progress. A human merges and publishes. A later run confirms the fix is
retrievable and marks the gap resolved. Every run starts at step 1, and step 1
finds both new gaps and gaps waiting on a published fix.

## How status is kept

Setting a status on a gap puts it on the project's **saved gaps** list
(`list_coverage_gap_records`). Gaps are re-clustered every period, so the same
topic comes back as a new cluster with a new id. A saved entry links to every
cluster it covers, and its `clusters` field lists them, one per period it was
found in. The saved list is the memory between runs. Check it before starting
work on anything.

Statuses are the project's status tags, the same ones the dashboard shows:

- The docs workflow uses `in_progress`, `resolved` and `dismissed`. Pass these
  as `status`. Kapa creates the matching tags the first time.
- Any other tag, such as `Reviewed`, goes by id: `status_tag_id` from
  `list_status_tags`. `status_tag_id: null` clears a status.

There are two update tools:

| The gap... | Use |
| --- | --- |
| is a cluster not on the saved list yet | `update_coverage_gap` with the **cluster id**. This creates its entry. |
| is a cluster for the same topic as a saved entry, e.g. found again this period | `update_coverage_gap` with the **cluster id** and `record_id` set to that **entry id**. This links the cluster to the entry; it takes the entry's status and drops out of `status: new`. |
| is a saved entry you want to change, whatever its clusters | `update_coverage_gap_record` with the **entry id**. The change shows on every linked cluster. |

Calling `update_coverage_gap` without `record_id` on a cluster that matches a
saved entry creates a second entry for the same gap. Always check first.

## 1. Find work

Start with `list_projects` if you don't know the project id.

**Follow-ups first.** `list_coverage_gap_records` with `status: in_progress`.
Each entry's `link` is the fix, normally a pull request. Check whether it has
merged, for example with `gh pr view <url> --json state,mergedAt`. A merged fix
goes to step 8. One that is still open stays as it is. Don't redraft it.

**New gaps.**

1. `list_coverage_gaps_periods` with `interval: quarterly`. A quarter has enough
   conversations for clusters to be meaningful. Use `monthly` if the user wants a
   faster loop, or if the quarter has no gaps yet. The first period is the latest.
2. `get_coverage_gaps` with that period `id` and `status: new`. Clusters come
   ranked by `thread_count`, so the first ones affect the most people.
3. `list_coverage_gap_records` with no filter, and match each new cluster
   against it by topic: title, summary and suggestion. Titles are generated, so
   "Setting up SSO with Okta" and "Okta SAML configuration" can be the same gap.
   - Matched an entry: link the cluster to it, with `update_coverage_gap`, the
     cluster `id` and `record_id`. Add a `note` such as "seen again in Q3, 12
     conversations". Then:
     - If the entry is `in_progress`, `resolved` or `dismissed`, someone has
       handled it. Don't redraft. A resolved gap that keeps coming back means the
       fix didn't work, so tell the user.
     - If it has any other tag, or none, nobody is fixing it. Work on it, and
       set statuses on the entry from now on.
   - No match: a new gap. Work on it, using `update_coverage_gap` on the cluster
     when you start.

**Feedback.** `list_threads` with `has_feedback: true`, `status_tag: "null"`
(not yet triaged) and `include: feedback`. Each question carries `feedback`
(end users: reaction and comment) and `agent_feedback` (agents: category,
severity, message). `feedback_source: agent` or `end_user` narrows it.

- Agent feedback is often the most specific about what is missing. It is linked
  to the agent's latest search before it, which may not be the search it is
  about, so read the message rather than trusting the question it sits on.
- Group feedback with the gap it belongs to. A downvote saying an answer was
  wrong is a docs fix in its own right, even with no gap.

Show the user what you found, ranked by people affected, and agree which to work
on this run. Don't take on everything at once.

## 2. Understand the gap

Use the cluster's `summary`, `suggestion` and its inline `threads`. The
suggestion is generated, so treat it as a hint, not a spec.

Read a sample of three to five conversations with `get_thread`: the questions as
asked and the answers Kapa gave. Questions with an uncertain answer show exactly
what is missing. If `get_thread` fails, `list_threads` carries the same
questions and answers without sources.

Write down the questions the fix must answer. Step 5 checks against this list.

## 3. Check what already exists

`search_project_knowledge` with `mode: deep`, using two or three of the sampled
questions as written. The top chunks show what Kapa can already find.

- A page that partly covers the topic should usually be extended, not
  duplicated. If the user also has Kapa's hosted MCP server for this project
  connected, its `get_<product>_knowledge_documents` tool returns the full page.
  Otherwise open the page URL from the chunk.
- If the user has the product's code repository open, check how the feature
  actually behaves there. Docs written from the gap alone repeat its assumptions.

## 4. Agree where the fix goes

Ask, unless the user has already said:

- **A docs repo** (docs-as-code): which repo, and whether it has a `STYLE.md`,
  templates or a contributing guide. Read them before drafting.
- **No repo**: which format they want, for example a Markdown file or a Word
  document, and where to save it.

## 5. Draft and check

Write in the repo's style and templates. Then check, and fix and recheck until
every point passes:

1. **Every question from step 2 is answered** where a reader would look for it.
2. **Accurate.** Check against the code when you have it. Never invent product
   facts such as setting names, menu paths, limits or URLs. Mark anything you
   could not confirm, for example `{{confirm: ...}}`, and list those for the
   user.
3. **Style** matches the repo's guide.
4. **Feedback addressed.** If a downvote said an answer was wrong, the page says
   what is right.

**When docs cannot fix it**, for example a product bug, a missing feature or an
off-topic question, don't write a page. Dismiss it with a reason:
`update_coverage_gap` (or `update_coverage_gap_record` if it is on the list)
with `status: dismissed` and a `note`. Tell the user, since a bug may need a
ticket instead.

## 6. Raise the fix

Open a pull request in the docs repo, or save the file where the user asked.
Don't merge it yourself; a human reviews.

## 7. Mark it in progress

On the gap, with the tool from the table above: `status: in_progress` and
`link` set to the pull request URL. `link` must be an `http(s)` URL. For a local
file, leave `link` out and put the path in `note`.

For feedback threads the fix addresses, `list_status_tags`, then
`update_thread_status` with each thread `id`, its `project_id` and the
`In progress` tag id. This takes them out of the untriaged list in step 1. The
tag exists once any gap has been set in progress. If it doesn't, ask which tag
to use rather than picking one.

## 8. Sync the published fix

This is a later run, once step 1 finds the pull request merged and the docs site
has deployed.

Kapa picks the change up on its next scheduled sync. To get it in now, find the
source holding the docs with `list_sources` and call `refresh_source`. It
re-reads the source and can spend the team's quota, so **confirm with the user
first**.

- A web crawl re-crawls. Follow it with `get_crawl_status` until it leaves
  `PENDING` and `IN_PROGRESS`. A crawl in review mode holds changed pages for
  `list_pages_for_review` and `approve_pages_for_review`.
- Other sources fetch their updates. Follow with `get_source` until
  `incremental_status` is no longer `updating` and `last_checked_at` has moved.
- A 409 means a sync is already running. Wait, don't retry in a loop.
- `can_be_refreshed: false` (file uploads, hand-written answers) means there is
  nothing to trigger.

## 9. Verify

Run the step 2 questions through `search_project_knowledge` again. The new or
updated page should be among the top chunks. If it isn't, say so. The gap isn't
resolved yet, and the cause is usually the page not being ingested or its
wording not matching how people ask.

## 10. Mark it resolved

`status: resolved` with `link` set to the published page, using the same tool
and id as in step 7. Set the feedback threads from step 7 to the `Resolved` tag
with `update_thread_status`.

## Rules that matter

- **Check the saved list before touching a gap.** A gap found again in a new
  period is linked to its existing entry with `record_id`. A second entry for
  the same topic splits its history and confuses the dashboard.
- **Only set statuses on gaps and threads you worked on this run.** Other people
  use the same tags.
- **Never mark a gap resolved before step 9 passes.** Resolved means "Kapa can
  now answer this", not "a PR exists".
- **Confirm before `refresh_source`.** It can spend quota.
- **Don't invent facts to fill a page.** A gap means the information was
  missing. Ask the user or mark it to confirm.
