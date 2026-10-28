# Methods per item

Whatever the item, the same three steps: read what people asked and what Kapa
answered, read the pages in this repo, then decide. Default to no change; a
change has to earn its place.

## Reading the evidence

- A conversation from `search_conversations` shows only its first question.
  `get_thread` returns every turn, Kapa's answers, the feedback and the sources
  each answer retrieved (`referenced_in_answer` marks the cited ones). Pass
  `include_source_content=false` unless you need the sources' text: with it, a
  long conversation runs to hundreds of thousands of characters.
- **Uncertain** means Kapa judged its own answer not supported by the knowledge
  base. The page it cited is only the closest match, so the fix may belong on
  another page, or on no page that exists yet.
- Count unique users, not threads. Ten threads from one person is one person.
- Questions in other languages count the same; quote them as written.

## Gaps: uncertain answers and coverage gap clusters

Search the repo for the topic: the obvious page, the FAQ, the configuration
reference, and anything an answer cited. Then pick one:

- **Missing.** Nothing covers it, and it belongs in the docs. Propose the page or
  section and what it says.
- **Not supported.** The product does not do it. If people keep asking, a
  plain "this is not supported, here is the alternative" is a fix. Check the
  internal project before concluding this.
- **Unfindable.** The docs cover it, but under words people do not use, or
  buried in a table. Propose the heading, wording or cross-link that would match
  how people ask. `search_project_knowledge` on the public project shows what
  Kapa retrieves for a question, which tells missing from unfindable; it is a
  real query, so only with the user's go-ahead.
- **Already fixed.** The docs changed since. Log it and move on.
- **Noise.** Off-topic, abuse, test traffic, agent instructions, or out of the
  docs' scope (careers, a competitor's product). Log it with one line.

Kapa's `suggestion` on a coverage gap cluster is a lead, not a verdict.

## Top questions: well-trodden topics

These are documented by definition; the question is whether well. Judge:

- **Discoverability:** would someone phrasing it like these users land on the
  right page?
- **Completeness:** do the docs answer the angles people actually ask about?
- **Clarity:** do the answers hedge or contradict the docs?
- **Fragmentation:** is the answer split across pages that never link?

Verdict: well documented, or a concrete improvement.

## Pages behind bad answers: source usage

For a page that recurs in uncertain or downvoted answers, list its questions
with `list_source_questions` (`url_path` set to the page) and group them by the
change that would have helped them, not by topic. For each group with at least
three questions, pick one:

- **Add** what is in scope for the page and missing everywhere.
- **Clarify** what exists but is misread; quote the passage.
- **Restructure** what exists but is buried or under the wrong heading.
- **Cross-link** to the page that already covers it; name it.
- **Delete** what is outdated or pulls answers the wrong way; quote it.
- **No change** when the page serves them, or the fix belongs elsewhere.

## Downvotes and comments

Read the whole conversation and the comment. A downvote on a correct answer is
not a docs problem. A downvote on a wrong answer is, when the wrong part came
from the docs: an outdated page, a contradiction between two pages, or an
example that no longer works. Fix the source, not the symptom.

## What a recommendation contains

- The page to edit or create, and the change in one or two sentences.
- The counts: conversations, unique users, and which signals.
- At least three verbatim questions the change would have helped.
- What the docs say today, with the file path.
- For anything informed by the internal project, the capability statement only,
  flagged for review.
