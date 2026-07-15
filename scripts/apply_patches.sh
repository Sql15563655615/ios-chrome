#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT/chromium/src"
PATCH_DIR="$ROOT/patches"
EXPECTED_MAJOR="72"
EXECUTE=0

if [[ "${1:-}" == "--execute" ]]; then
  EXECUTE=1
fi

if [[ ! -d "$SRC_DIR/.git" ]]; then
  echo "chromium/src checkout not found. Refusing to apply patches." >&2
  exit 2
fi

VERSION_FILE="$SRC_DIR/chrome/VERSION"
if [[ ! -f "$VERSION_FILE" ]]; then
  echo "missing Chromium version file: $VERSION_FILE" >&2
  exit 2
fi

MAJOR="$(awk -F= '/^MAJOR=/{print $2}' "$VERSION_FILE")"
if [[ "$MAJOR" != "$EXPECTED_MAJOR" ]]; then
  echo "expected Chromium major $EXPECTED_MAJOR, found ${MAJOR:-unknown}" >&2
  exit 3
fi

mapfile -t PATCHES < <(find "$PATCH_DIR" -type f -name '*.patch' | sort)
if [[ "${#PATCHES[@]}" -eq 0 ]]; then
  echo "no patches found under $PATCH_DIR" >&2
  exit 4
fi

printf 'Chromium major %s detected. Patch plan:\n' "$MAJOR"
for patch in "${PATCHES[@]}"; do
  rel="${patch#$ROOT/}"
  printf '  git -C chromium/src apply --check ../%s\n' "$rel"
done

if [[ "$EXECUTE" != "1" ]]; then
  printf '\nDry run only. Re-run with --execute after replacing framework patches with real git-apply hunks.\n'
  exit 0
fi

printf '\n--execute currently performs validation only and does not apply patches in Stage 2.5.\n'
for patch in "${PATCHES[@]}"; do
  git -C "$SRC_DIR" apply --check "$patch"
done
