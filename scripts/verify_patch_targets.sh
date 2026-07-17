#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PATCH_DIR="$ROOT/patches"
LOCAL_SRC_DIR="$ROOT/chromium/src"
TAG="${CHROMIUM72_TAG:-72.0.3626.122}"
REMOTE_BASE="https://chromium.googlesource.com/chromium/src/+/${TAG}"

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
