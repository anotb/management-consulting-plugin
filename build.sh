#!/usr/bin/env bash
# Build dist/management-consulting.skill for Claude Desktop install.
#
# Format: single-skill dispatcher bundle. Claude Desktop's "Upload skill" UI
# rejects ZIPs containing more than one SKILL.md, so we consolidate the 15
# consulting skills into one skill called `management-consulting`. Its
# top-level SKILL.md is a hand-curated dispatcher that lists per-topic
# reference files; references/<name>.md contains each skill's body.
#
# After upload, Desktop registers one skill (/management-consulting). To get
# individual slash commands per skill, use the alternative Desktop install
# documented in the README (clone or unzip directly into ~/.claude/skills/).
#
# Other install paths (Claude Code, Cowork, Codex, Gemini CLI, npx skills add)
# read skills/<name>/SKILL.md from the repo directly and don't need this.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/skills"
DISPATCHER="$ROOT/dist/dispatcher/SKILL.md"
STAGE="$ROOT/dist/build/management-consulting"
REFS="$STAGE/references"
ZIP="$ROOT/dist/management-consulting.skill"

# writing-style is shipped as a standalone skill for npx installs but its content
# is already inlined in the dispatcher SKILL.md, so we don't duplicate it here.
SKIP=(writing-style)

if [[ ! -f "$DISPATCHER" ]]; then
  echo "missing dispatcher source at $DISPATCHER" >&2
  exit 1
fi

rm -rf "$STAGE"
mkdir -p "$REFS"
# Normalize CRLF checkouts so Windows/WSL builds match Linux builds.
awk '{ sub(/\r$/, ""); print }' "$DISPATCHER" > "$STAGE/SKILL.md"

generated=()
copied=()
skipped=()

for dir in "$SRC"/*/; do
  name="$(basename "$dir")"
  if printf '%s\n' "${SKIP[@]}" | grep -qx "$name"; then
    skipped+=("$name")
    continue
  fi
  src="$dir/SKILL.md"
  if [[ ! -f "$src" ]]; then
    echo "skip: $name has no SKILL.md" >&2
    continue
  fi
  # Strip only the first frontmatter block (between the first two --- lines).
  # Normalize CRLF while preserving --- section separators inside the body.
  awk '{ line=$0; sub(/\r$/, "", line); if(n<2) { if(line=="---") n++; next } print line }' "$src" > "$REFS/$name.md"
  generated+=("$name")
  if [[ -d "$dir/references" ]]; then
    for sub in "$dir/references"/*.md; do
      [[ -e "$sub" ]] || continue
      awk '{ sub(/\r$/, ""); print }' "$sub" > "$REFS/$(basename "$sub")"
      copied+=("$(basename "$sub")")
    done
  fi
done

rm -f "$ZIP"
( cd "$ROOT/dist/build" && zip -qr "$ZIP" management-consulting/ )

echo "generated references (${#generated[@]}): ${generated[*]}"
echo "copied sub-references (${#copied[@]}): ${copied[*]}"
echo "skipped (${#skipped[@]}): ${skipped[*]}"
echo "wrote $ZIP ($(wc -c < "$ZIP") bytes)"
