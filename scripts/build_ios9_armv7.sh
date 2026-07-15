#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHROMIUM_SRC="$ROOT/chromium/src"
OUT_DIR="${1:-$CHROMIUM_SRC/out/ios9_armv7}"
ARGS_FILE="$ROOT/build/args/ios9_armv7.gn"

if [[ ! -f "$CHROMIUM_SRC/buildtools/linux64/gn" && ! -x "$(command -v gn || true)" ]]; then
  cat >&2 <<MSG
Chromium 72 source and GN are not present yet.
Stage 1 intentionally does not download Chromium.
After checkout, run:
  gn gen "$OUT_DIR" --args="$(tr '\n' ' ' < "$ARGS_FILE")"
  ninja -C "$OUT_DIR" cef_lite ios_shell
MSG
  exit 2
fi

GN_BIN="$(command -v gn || true)"
if [[ -x "$CHROMIUM_SRC/buildtools/linux64/gn" ]]; then
  GN_BIN="$CHROMIUM_SRC/buildtools/linux64/gn"
fi

"$GN_BIN" gen "$OUT_DIR" --args="$(tr '\n' ' ' < "$ARGS_FILE")"
ninja -C "$OUT_DIR" cef_lite ios_shell
