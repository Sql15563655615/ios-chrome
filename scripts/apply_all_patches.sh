#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PATCHES=(
  patches/0001-build-armv7-ios.patch
  patches/0002-disable-ffmpeg.patch
  patches/0003-disable-gpu.patch
  patches/0004-disable-webrtc.patch
  patches/0005-ios9-sdk-compat.patch
  patches/0006-v8-arm32.patch
  patches/0007-memory-optimize.patch
)

for patch in "${PATCHES[@]}"; do
  echo "Checking ${patch}"
  git apply --check "$patch"
done

if [[ "${1:-}" == "--apply" ]]; then
  for patch in "${PATCHES[@]}"; do
    echo "Applying ${patch}"
    git apply "$patch"
  done
else
  echo "Patch check complete. Re-run with --apply to apply patches."
fi
