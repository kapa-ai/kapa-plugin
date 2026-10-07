---
name: kapa-setup
description: Set up a Kapa project by connecting a knowledge source and checking it ingests. Use when the user wants to set up Kapa but has not said which source type.
---

# Set up a Kapa project

1. Call `list_projects` to confirm the user is signed in. If it fails with an
   authentication error, tell them to run `/mcp` and sign in, then wait for
   them before you retry.
2. If there is more than one project, ask which one.
3. Ask what they want Kapa to answer questions about.
4. Load the matching `kapa-setup-*` skill for their choice. Do not work the
   calls out yourself.

Do not pick filters for the user. Show the options and ask.
