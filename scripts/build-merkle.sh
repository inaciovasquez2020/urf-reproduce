#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

mkdir -p manifest
TMP_FILES="$(mktemp)"
TMP_LEAVES="$(mktemp)"

{
  find ../urf-verifier -type f 2>/dev/null || true
  find ../urf-counterexamples -type f 2>/dev/null || true
  find . -type f 2>/dev/null || true
} | grep -v "/.git/" | grep -v "/.lake/" | sed 's#^\./##' | LC_ALL=C sort > "$TMP_FILES"

: > manifest/files.sha256
: > "$TMP_LEAVES"

while IFS= read -r f; do
  [ -f "$f" ] || continue
  h="$(shasum -a 256 "$f" | awk '{print $1}')"
  printf "%s  %s\n" "$h" "$f" >> manifest/files.sha256
  leaf="$(printf "%s\0%s" "$f" "$h" | shasum -a 256 | awk '{print $1}')"
  echo "$leaf" >> "$TMP_LEAVES"
done < "$TMP_FILES"

build_level() {
  infile="$1"
  outfile="$2"
  : > "$outfile"

  prev=""
  while IFS= read -r line; do
    if [ -z "$prev" ]; then
      prev="$line"
    else
      printf "%s%s" "$prev" "$line" | shasum -a 256 | awk '{print $1}' >> "$outfile"
      prev=""
    fi
  done < "$infile"

  if [ -n "$prev" ]; then
    printf "%s%s" "$prev" "$prev" | shasum -a 256 | awk '{print $1}' >> "$outfile"
  fi
}

CUR="$TMP_LEAVES"
NEXT="$(mktemp)"

while true; do
  LINES="$(wc -l < "$CUR" | tr -d ' ')"
  if [ "$LINES" -le 1 ]; then
    break
  fi
  build_level "$CUR" "$NEXT"
  mv "$NEXT" "$CUR"
  NEXT="$(mktemp)"
done

ROOT_HASH="$(cat "$CUR")"
echo "$ROOT_HASH" > manifest/merkle.root

rm -f "$TMP_FILES" "$TMP_LEAVES" "$NEXT" 2>/dev/null || true

echo "Merkle root:"
cat manifest/merkle.root

