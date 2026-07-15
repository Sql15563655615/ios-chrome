#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

required_dirs=(
  chromium/src cef-lite ios-shell sdk/iPhoneOS9.3.patch
  patches/build patches/v8 patches/content patches/blink patches/mojo patches/ios patches/sdk
  scripts docs build/args
)
for dir in "${required_dirs[@]}"; do
  [[ -d "$dir" ]] || { echo "missing directory: $dir" >&2; exit 1; }
done

required_files=(
  README.md build/args/ios9_armv7.gn docs/PATCH_PLAN.md
  sdk/iPhoneOS9.3.patch/Availability.h
  sdk/iPhoneOS9.3.patch/os/availability.h
  sdk/iPhoneOS9.3.patch/Network.framework.stub.h
  sdk/iPhoneOS9.3.patch/UIKitCompatibility.h
)
for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || { echo "missing file: $file" >&2; exit 1; }
done

for token in 'target_os = "ios"' 'target_cpu = "arm"' 'arm_version = 7' 'ios_deployment_target = "9.3"' 'enable_webrtc = false' 'enable_pdf = false' 'symbol_level = 0'; do
  grep -Fq "$token" build/args/ios9_armv7.gn || { echo "missing GN token: $token" >&2; exit 1; }
done

find patches -name '*.patch' -print | sort | while read -r patch; do
  base="$(basename "$patch")"
  [[ "$base" =~ ^[0-9]{4}-[a-z0-9-]+\.patch$ ]] || { echo "bad patch name: $patch" >&2; exit 1; }
done

printf 'Stage 1 validation passed.\n'
