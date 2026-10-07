---
name: kapa-gaps
description: Show what people ask that a Kapa project cannot answer. Use when the user wants coverage gaps, top questions, or ideas for what content to add.
---

# Find gaps in a Kapa project

1. Call `list_coverage_gaps_periods`, then `get_coverage_gaps` with the most
   recent period id. This shows what people asked that the content does not
   cover.
2. Call `list_top_questions_periods`, then `get_top_questions` with the most
   recent period id. This shows what people ask most.
3. Summarise both. Suggest the content that closes the biggest gaps.
