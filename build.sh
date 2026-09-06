#!/usr/bin/env bash
# Single-skill Claude Desktop bundle. Standalone installs still use skills/*.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/skills"
DISPATCHER="$ROOT/dist/dispatcher/SKILL.md"
STAGE="$ROOT/dist/build/management-consulting"
REFS="$STAGE/references"
ZIP="$ROOT/dist/management-consulting.skill"

# Reject malformed input instead of emitting a silently empty reference.
body() {
  awk -v name="$2" '
    { sub(/\r$/, "") }
    NR==1 { if ($0 != "---") exit 2; next }
    !closed { if ($0 == "---") closed=1; next }
    {
      gsub(/\]\(references\//, "](" name "/references/")
      gsub(/\]\(scripts\//, "](" name "/scripts/")
      gsub(/\]\(assets\//, "](" name "/assets/")
      print
    }
    END { if (!closed) exit 2 }
  ' "$1"
}
[[ -f "$DISPATCHER" ]] || { echo "Missing dispatcher: $DISPATCHER" >&2; exit 1; }
rm -rf "$STAGE"
mkdir -p "$REFS"
style="$ROOT/dist/build/writing-style.md"
body "$SRC/writing-style/SKILL.md" writing-style > "$style"
# One maintained source for writing guidance, embedded for the single-skill host.
while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%$'\r'}"
  if [[ "$line" == '<!-- WRITING_STYLE -->' ]]; then
    cat "$style"
  else
    printf '%s\n' "$line"
  fi
done < "$DISPATCHER" > "$STAGE/SKILL.md"

count=0
for dir in "$SRC"/*/; do
  name="$(basename "$dir")"
  [[ -f "$dir/SKILL.md" ]] || { echo "Missing skill: $dir" >&2; exit 1; }
  if [[ "$name" != writing-style ]]; then
    body "$dir/SKILL.md" "$name" > "$REFS/$name.md"
    count=$((count + 1))
  fi
  # Namespace resources so same-named files cannot overwrite each other.
  # Preserve nested relative links and executable helpers, including binary assets.
  for resource in references scripts assets; do
    [[ -d "$dir/$resource" ]] || continue
    mkdir -p "$REFS/$name"
    cp -R "$dir/$resource" "$REFS/$name/"
  done
done
while IFS= read -r -d '' file; do
  case "$file" in
    *.md|*.cjs|*.js|*.py|*.sh|*.json|*.yaml|*.yml|*.txt|*.csv|*.svg)
      awk '{ sub(/\r$/, ""); print }' "$file" > "$file.normalized"
      cat "$file.normalized" > "$file"
      rm "$file.normalized" ;;
  esac
done < <(find "$REFS" -type f -print0)
if [[ "$(find "$STAGE" -name SKILL.md | wc -l | tr -d ' ')" != 1 ]]; then
  echo 'Desktop requires exactly one SKILL.md.' >&2
  exit 1
fi
rm -f "$ZIP"
( cd "$ROOT/dist/build" && zip -qr "$ZIP" management-consulting/ )
echo "Built $ZIP with $count topic references, writing guidance, and namespaced resources."
