---
name: kapa-setup-file-upload
description: Upload local files, such as PDFs or Word documents, to Kapa as File Upload sources. Use when the user wants Kapa to answer from files on their machine rather than from a connected system.
---

# Upload files

One File Upload source holds exactly one file, so three files means three
sources. The upload itself is a plain HTTP `PUT` from your shell, so this
needs an agent that can read local files and run `curl` or similar, such as
Claude Code, Cursor or Codex. A chat client without file access cannot do it:
tell the user to upload in the Kapa dashboard instead.

Repeat these steps for each file.

## 1. Create the source

`create_file_upload_source` with `project` and `name`. Name it after the file,
such as `pricing-guide.pdf`, unless the user asks for something else. Keep the
returned id.

## 2. Get an upload URL

`presign_file_upload` with the source id and `content_type`, the file's MIME
type, such as `application/pdf` or
`application/vnd.openxmlformats-officedocument.wordprocessingml.document`. It
returns `blob_id`, `upload_url`, `content_type` and `required_headers`.

## 3. Upload the bytes

Send one `-H` per `required_headers` entry. Today that is the size range:

```bash
curl -X PUT \
  -H "Content-Type: <content_type>" \
  -H "x-goog-content-length-range: 0,104857600" \
  --data-binary @<file> "<upload_url>"
```

**Send `Content-Type` and every entry in `required_headers` exactly as
returned.** They are part of the URL's signature, so a missing or changed
header fails with a 403 from storage, not from Kapa. Use the `content_type`
from the response, not one you guessed again.

The URL expires after 30 minutes, and a file can be at most 100 MB. If the URL
expires, presign again.

## 4. Save the configuration

`create_file_upload_config` with `source_file_upload` (the source id),
`blob_id`, `file_name` and `file_type`. `linked_url` is optional: a public URL
for the same document, shown as the citation link in answers.

`file_type` comes from the extension: `pdf`, `word` (`.docx`), `markdown`
(`.md`), `mdx`, `text` (`.txt`), `yaml`, `openapi` (`.json` OpenAPI specs) and
`stackoverflow` (`.csv` Q&A exports). Code files are accepted too, such as
`python`, `javascript`, `typescript`, `tsx`, `go`, `java`, `rust`, `c_cpp`,
`terraform`, `swift`, `kotlin` and `csharp`. Notebooks, HTML and images are
not.

A `blob_id` can be used once. If this call fails after the upload, presign and
upload again rather than retrying with the same id.

## Finish the job

Saving the configuration starts ingestion. There is no separate publish step.
Confirm with the user before uploading a batch, since every file spends
quota.

Then call `list_sources` with `project_id` to confirm one source per file, and
`get_source` on any that look stuck to see its ingestion state.
