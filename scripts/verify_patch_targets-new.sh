#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PATCH_DIR="$ROOT/patches"
LOCAL_SRC_DIR="$ROOT/chromium/src"
TAG="${CHROMIUM72_TAG:-72.0.3626.122}"
REMOTE_BASE="https://chromium.googlesource.com/chromium/src/+/${TAG}"
GRAPH_MODE=0

if [[ "${1:-}" == "--graph" ]]; then
  GRAPH_MODE=1
fi

status=0
warning=0

mapfile -t patches < <(find "$PATCH_DIR" -maxdepth 1 -type f -name '*.patch' | sort)
if [[ "${#patches[@]}" -eq 0 ]]; then
  echo "FAIL: no patch files found under $PATCH_DIR"
  exit 2
fi

declare -a targets=()
for patch in "${patches[@]}"; do
while IFS= read -r line; do
  if [[ $line == diff\ --git\ a/*\ b/* ]]; then
    old_path="${line#diff --git a/}"
    old_path="${old_path%% b/*}"
    new_path="${line##* b/}"
    targets+=("$old_path" "$new_path")
  fi
done < "$patch"
done

declare -A seen=()
unique_targets=()
for target in "${targets[@]}"; do
  [[ -n "$target" ]] || continue
  target="${target#chromium/src/}"
  if [[ -z "${seen[$target]:-}" ]]; then
    seen["$target"]=1
    unique_targets+=("$target")
  fi
done

check_local_target() {
  local rel="$1"
  [[ -e "$LOCAL_SRC_DIR/$rel" ]]
}

check_remote_target() {
  local rel="$1"
  local url="$REMOTE_BASE/$rel?format=TEXT"
  curl -fsI "$url" >/dev/null
}

graph_target_for_patch() {
  case "$1" in
    0001-build-armv7-ios.patch) echo "ARM defaults / iOS config" ;;
    0002-disable-ffmpeg.patch) echo "media / media_cast" ;;
    0003-disable-gpu.patch) echo "content gpu / skia_bindings" ;;
    0004-disable-webrtc.patch) echo "media options / WebRTC gating" ;;
    0005-ios9-sdk-compat.patch) echo "iOS SDK selection" ;;
    0006-v8-arm32.patch) echo "V8 ARM32 config" ;;
    0007-memory-optimize.patch) echo "content switches / blink runtime features" ;;
    *) echo "unknown" ;;
  esac
}

graph_build_file_for_patch() {
  case "$1" in
    0001-build-armv7-ios.patch) echo "build/config/arm.gni, ios/build/config.gni" ;;
    0002-disable-ffmpeg.patch) echo "media/BUILD.gn, media/cast/BUILD.gn" ;;
    0003-disable-gpu.patch) echo "content/gpu/BUILD.gn, gpu/skia_bindings/BUILD.gn" ;;
    0004-disable-webrtc.patch) echo "media/media_options.gni" ;;
    0005-ios9-sdk-compat.patch) echo "build/config/ios/ios_sdk.gni" ;;
    0006-v8-arm32.patch) echo "v8/BUILD.gn, v8/gni/v8.gni" ;;
    0007-memory-optimize.patch) echo "content/public/common/BUILD.gn, third_party/blink/renderer/platform/BUILD.gn" ;;
    *) echo "unknown" ;;
  esac
}

if [[ "$GRAPH_MODE" -eq 1 ]]; then
  for patch in "${patches[@]}"; do
    name="$(basename "$patch")"
    printf 'Patch: %s\n' "$name"
    printf '  ↓\n'
    printf 'BUILD.gn/.gni: %s\n' "$(graph_build_file_for_patch "$name")"
    printf '  ↓\n'
    printf 'Target: %s\n' "$(graph_target_for_patch "$name")"
    printf '\n'
  done
  exit 0
fi

if [[ -d "$LOCAL_SRC_DIR" ]] && [[ -n "$(find "$LOCAL_SRC_DIR" -mindepth 1 -maxdepth 1 | head -n 1)" ]]; then
  for rel in "${unique_targets[@]}"; do
    if check_local_target "$rel"; then
      echo "PASS: $rel"
    else
      echo "FAIL: missing target in local Chromium checkout: $rel"
      status=1
    fi
  done
else
  warning=1
  for rel in "${unique_targets[@]}"; do
    if check_remote_target "$rel"; then
      echo "WARNING: local Chromium checkout missing; verified remotely for $rel"
    else
      echo "FAIL: target not found in Chromium 72 source tree: $rel"
      status=1
    fi
  done
fi

if [[ "$status" -eq 0 ]]; then
  if [[ "$warning" -eq 1 ]]; then
    echo "WARNING"
  else
    echo "PASS"
  fi
else
  echo "FAIL"
fi

exit "$status"
