#!/usr/bin/env bash
# Copy the skills from kapa-mcp, which is where they are authored.
#
# They live there because the tool descriptions and the skills are written
# together, and a skill naming a tool that no longer exists is worse than no
# skill at all. This copies rather than symlinks so the published plugin is
# self-contained.
set -euo pipefail

SOURCE="${1:-../kapa-mcp/mcp-skills}"
DEST="$(cd "$(dirname "$0")/.." && pwd)/skills"

if [ ! -d "$SOURCE" ]; then
  echo "No skills at $SOURCE. Pass the path as the first argument." >&2
  exit 1
fi

rm -rf "${DEST:?}"/*
cp -r "$SOURCE"/* "$DEST"/
echo "Synced $(find "$DEST" -name SKILL.md | wc -l | tr -d ' ') skills from $SOURCE"
