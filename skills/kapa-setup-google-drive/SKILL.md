---
name: kapa-setup-google-drive
description: Set up a Kapa Google Drive source so documents in a Drive are ingested. Use when the user wants Kapa to answer from files in Google Drive or a shared drive.
---

# Set up Google Drive

Connects through OAuth, so the user approves it in their browser.

Unlike the other OAuth sources, the grant belongs to the **signed-in user, not
the source**. Connect once and it serves every Google Drive source that user
sets up next. It also means two Google Drive setups cannot run at the same
time, so finish one before starting another.

## 1. Create the source

`create_google_drive_source` with `project` and `name`. Keep the returned id.

## 2. Connect the Drive

`connect_google_drive` takes no arguments and returns the URL the user
approves at.

**Open that URL in the user's browser** and ask them to approve it.

## 3. Wait for the user, then check once

The approval happens in the browser, so there is nothing to poll. Ask the user
to tell you when they have approved it, then call
`check_google_drive_connection` **once**. It answers with the Google account
that approved, or nothing if they have not finished.

## 4. Choose what to ingest

`list_google_drive_folders` and `list_google_drive_files` show what the
connected account can see. Both answer with at most 20 results, so pass `name`
to search rather than expecting the whole Drive back.

Ask the user which folders or files to ingest, and use these tools to turn
their answer into ids. Taking everything the account can see is a valid choice,
so offer it alongside picking specific folders rather than assuming either.

## 5. Configure it

`configure_google_drive` with `source_google_drive` and the ids:

- `folder_ids_include` and `file_ids_include` take what to read.
- `folder_ids_exclude` and `file_ids_exclude` drop things from a wider set.
- Leaving all four out ingests everything the connected account can see.

No credential travels here. The connection supplies the token and the account
email, so never ask the user for either.

## What gets ingested

Google Docs, Sheets and Slides are read as documents. A file the connected
account cannot open is skipped.

## When it ingests nothing

The approving account cannot see the folders you configured. Drive permissions
belong to the person who approved, so a folder shared with the team but not
with them is invisible. Have the user check their own access before changing
the configuration.

## Finish the job

Saving the configuration starts ingestion. There is no separate publish step.

Then call `list_sources` with `project_id` to confirm what the project holds.
