# iPod touch 5 Memory Trim Plan

Target: iPod touch 5, Apple A5, ARMv7, 512MB RAM.

Scope: Linux source audit only. GN and compilation were not run.

## Renderer count

Goal: keep renderer process count minimal.

Plan:

- Prefer CEF Lite single-process or one-renderer operation for the initial feasibility shell.
- Keep extensions, printing, PDF, WebRTC, GPU process, and ffmpeg disabled to reduce renderer-side service fan-out.
- Add runtime plumbing in a later stage for `kIpodTouch5MemoryMode` from `0007-memory-optimize.patch` to cap renderer creation.

Relevant areas:

- `chromium/src/content/browser/`
- `chromium/src/content/renderer/`
- `chromium/src/content/public/common/content_switches.*`

## Cache

Goal: reduce HTTP/resource/cache pressure.

Plan:

- Default CEF Lite cache path should be optional and small.
- Prefer in-memory or aggressively bounded cache during early feasibility.
- Tie cache policy to the low-memory switch introduced by `0007-memory-optimize.patch`.

Relevant areas:

- `chromium/src/content/`
- `chromium/src/net/`
- `cef-lite/include/cef_app.h`

## Image cache and Blink memory

Goal: reduce Blink decoded image and resource cache growth.

Plan:

- Use `iOSArmv7LowMemoryMode` from `0007-memory-optimize.patch` as the feature marker.
- Later patch Blink cache sizing behind that marker after macOS GN confirms target reachability.
- Avoid enabling GPU raster and accelerated canvas for the iPod touch 5 profile.

Relevant areas:

- `chromium/src/third_party/blink/renderer/platform/`
- `chromium/src/third_party/blink/renderer/core/`

## V8 heap

Goal: keep V8 viable on ARM32 without modern high-memory assumptions.

Plan:

- Use `v8_enable_lite_mode=true` in `build/args/ios9_armv7_minimal.gn`.
- Keep `v8_enable_i18n_support=false` and `v8_use_external_startup_data=false` for the first feasibility pass.
- Use `v8_disable_modern_sandbox_for_ios_armv7=true` from `0006-v8-arm32.patch` as the Stage 4-pre marker.

Relevant areas:

- `chromium/src/v8/BUILD.gn`
- `chromium/src/v8/gni/v8.gni`
- `chromium/src/v8/src/`

## Current status

This plan establishes the Linux-auditable trimming strategy only. Runtime enforcement and GN/build validation remain later-stage work on the proper macOS iOS toolchain.
