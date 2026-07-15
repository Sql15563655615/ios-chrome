#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

printf 'Stage 1 bootstrap: no Chromium download is performed.\n'
mkdir -p chromium/src cef-lite ios-shell sdk/iPhoneOS9.3.patch patches scripts docs build/args
printf 'Repository skeleton is present.\n'
