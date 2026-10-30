---
name: kapa-gaps
description: Show what people ask that a Kapa project cannot answer, and what they ask most. Use when the user wants a quick look at coverage gaps or what content to write next, without working through a documentation repository.
---

# Find where a Kapa project falls short

1. Call `list_coverage_gaps_periods` for the project, then `get_coverage_gaps`
   with the period's `id` and `threads_limit=0`, for the newest period that has
   clusters. Weekly and
   monthly periods are often empty for a mid-sized project; fall back to the
   quarterly one and say which window you used.
2. Do the same with `list_top_questions_periods` and `get_top_questions`, with
   `threads_limit=0`, for what people ask most.
3. Add recent uncertain answers the clusters do not cover yet:
   `search_conversations` with `confidence_filter=uncertain` and `page_size` 25.
4. Summarise, ranked by unique users rather than threads, and suggest what
   content would close the biggest gaps. To act on it in a docs repository, use
   the `kapa-improve-docs` skill.
