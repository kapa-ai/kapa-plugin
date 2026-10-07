---
name: kapa-check
description: Check what a Kapa project holds and whether it answers. Use when the user wants to see their sources, their ingestion state, or test a question against their project.
---

# Check a Kapa project

1. Call `list_sources` for the project. Show what it holds and where each
   source has got to.
2. Ask the user for a question their content should answer.
3. Call `search_project_knowledge` with it and show what comes back.

If the answer is thin or wrong, say what would cause that. Do not declare
success.
