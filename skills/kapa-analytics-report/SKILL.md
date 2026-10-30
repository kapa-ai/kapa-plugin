---
name: kapa-analytics-report
description: Write a report on how a Kapa project is doing for a period, with the numbers, what changed, what people ask, where answers fall short and what to do about it. Use when the user wants a weekly or monthly summary, a report for their team, or to understand a change in the analytics.
---

# Report on a Kapa project

A report for the people who own the project: what happened, why it probably
happened, and what to do. Every claim carries its number.

## 1. Scope

1. `list_projects`, then ask which project, unless the user already said.
2. Agree on the period, by default the last full month, and the period before it
   for comparison. Ask who the report is for if it is not obvious.

## 2. Gather

- **Volume and quality:** `get_activity_over_time` for each of the two periods,
  `aggregation_period` matching the length (`DAY` for a week or month, `WEEK`
  for a quarter). Each response carries the series per integration and the
  period's totals: conversation questions, uncertain answers, upvotes,
  downvotes, languages and satisfaction ratings. Each point of the series
  carries its uncertain answers, votes and satisfaction ratings too. Compare the
  totals for the trend; the series shows when it moved and through which
  integration.
- **Satisfaction (CSAT):** from the ratings above, 1 to 5. Report the number of
  ratings and the share that are 4 or 5, and say so; with only a handful of
  ratings, give the counts rather than a percentage.
- **Value delivered,** as the dashboard shows it: `get_self_serve_rate`,
  `get_time_saved` and `get_users_and_deflections` for each period, with the
  `team_id` from `list_projects` and `project_filter` set to the project. Hours
  per person is `time_saved_hours` × `tracked_question_share` ÷
  `total_unique_users`. Employees added comes from support deflection, not time
  saved: `total_deflection_time_saved_hours` from `get_users_and_deflections` ÷
  days in the period, counting both the first and last day, × 365 ÷ 1,920.
  Time saved is an estimate: when `estimate_basis` is
  `per_question`, say the rate is not representative, and when
  `tracked_question_share` is under 0.9, say what share of traffic it covers.
- **What people ask:** `list_top_questions_periods`, then `get_top_questions` with
  the period's `id` and `threads_limit=0`, ranked by unique users.
- **Where answers fall short:** `list_coverage_gaps_periods`, then
  `get_coverage_gaps` with the period's `id` and `threads_limit=0`. Shorter periods are often empty;
  fall back to the quarterly period and say so. Add `search_conversations` with
  `confidence_filter=uncertain` and `page_size` 25 for the recent themes gaps
  do not cluster yet.
- **What people disliked:** `search_conversations` with `reaction_filter=DOWNVOTE`
  and `COMMENT`; read a few with `get_thread` and `include_source_content=false`.
- **What answered them:** `get_source_usage` for the period, one level deep.
- **What agents reported:** `list_agent_feedback` for the period: what agents
  using the project's hosted MCP servers said blocked them, by category and
  severity.

`list_integrations` names the integrations in the series.

## 3. Write

Keep it to a page:

1. **Headline numbers** against the previous period: questions, conversations,
   uncertain rate (uncertain answers over conversation questions), votes, CSAT
   and the self-serve rate.
2. **Value delivered:** hours saved and hours per person, then tickets
   deflected and the employees added they amount to, with the estimate's
   caveats.
3. **What changed and the likely reason.** Name the integration or topic that
   moved the numbers. Say when a reason is a guess.
4. **Top topics,** with unique users. Set aside one-person bursts, test traffic
   and agent traffic (requests that read like instructions).
5. **Where answers fall short:** the main gaps and uncertain themes, each with
   counts and one representative question, and what agents reported.
6. **Three to five recommendations,** each with its evidence. Documentation
   items can be worked through with the `kapa-improve-docs` skill.

Quote user questions only as short examples, and never include names, emails or
other personal data from conversations.

Where the client can draw charts, offer one: the series per period, stacked by
integration, and the uncertain rate for the two periods.

## Running unattended

In a scheduled task, use the project and periods named in the prompt, write the
report in full without asking, and state any fallback you took (such as
quarterly coverage gaps).
