#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHROMIUM_DIR="$ROOT/chromium"
SRC_DIR="$CHROMIUM_DIR/src"
TAG="${CHROMIUM72_TAG:-72.0.3626.122}"
EXECUTE=0

if [[ "${1:-}" == "--execute" ]]; then
  EXECUTE=1
fi

cat > "$CHROMIUM_DIR/.gclient.chromium72.template" <<'GCLIENT'
solutions = [
  {
    "name": "src",
    "url": "https://chromium.googlesource.com/chromium/src.git",
    "deps_file": "DEPS",
    "managed": False,
    "custom_deps": {
      "src/third_party/devtools-node-modules": None,
      "src/third_party/ffmpeg": None,
    },
    "custom_vars": {},
  },
]
target_os = ["ios"]
GCLIENT

cat <<MSG
Chromium 72 source preparation plan.
No download occurs unless this script is run with --execute.

Pinned Chromium tag: $TAG
Checkout directory: $SRC_DIR

Commands:
  cd "$CHROMIUM_DIR"
  cp .gclient.chromium72.template .gclient
  fetch --nohooks --no-history chromium  # documented depot_tools bootstrap path
  git -C src fetch --depth 1 origin "refs/tags/$TAG:refs/tags/$TAG"
  git -C src checkout "$TAG"
  gclient sync --with_branch_heads --with_tags --nohooks --no-history
  gclient runhooks
MSG

if [[ "$EXECUTE" != "1" ]]; then
  exit 0
fi

command -v fetch >/dev/null || { echo "fetch not found; add depot_tools to PATH" >&2; exit 1; }
command -v gclient >/dev/null || { echo "gclient not found; add depot_tools to PATH" >&2; exit 1; }

mkdir -p "$CHROMIUM_DIR"
cd "$CHROMIUM_DIR"

if [[ ! -d "$SRC_DIR/.git" ]]; then
  if [[ -d "$SRC_DIR" ]]; then
    rmdir "$SRC_DIR" 2>/dev/null || { echo "chromium/src exists but is not an empty checkout" >&2; exit 5; }
  fi
  if [[ -f .gclient ]]; then
    mv .gclient .gclient.pre-fetch
  fi
  git clone --depth 1 --branch "$TAG" https://chromium.googlesource.com/chromium/src.git src
fi

cp .gclient.chromium72.template .gclient
git -C src fetch --depth 1 origin "refs/tags/$TAG:refs/tags/$TAG"
git -C src checkout "$TAG"
gclient sync --with_branch_heads --with_tags --nohooks --no-history
gclient runhooks
