# Stage 4.1 Chromium 72 Patch Audit Report

Audit target:

```text
Chromium: 72.0.3626.122
Commit: 029c7e1925ccccf13fcec39dd99d49946835ec28
```

This audit validates that the Stage 4-pre patch files are real patch hunks against the pinned Chromium 72 source checkout. No GN generation and no compilation were run.

## Validation summary

Command:

```bash
git apply --check patches/*.patch
```

Result: **PASS**.

All patch files now carry the Chromium version and commit metadata at the top of the file.

## Patch audit table

| Patch | Modified files | Purpose | Chromium 72 source location | Risk |
| --- | --- | --- | --- | --- |
| `0001-build-armv7-ios.patch` | `build/config/arm.gni`, `ios/build/config.gni` | Restore explicit ARMv7 iOS feasibility defaults: iOS softfp handling, NEON selection, and an `ios_enable_armv7` marker. | `chromium/src/build/config/arm.gni`, `chromium/src/ios/build/config.gni` | High: touches core target CPU/toolchain assumptions. |
| `0002-disable-ffmpeg.patch` | `media/BUILD.gn`, `media/cast/BUILD.gn` | Keep `third_party/ffmpeg` excluded while preventing GN from importing/parsing ffmpeg when `media_use_ffmpeg=false`. | `chromium/src/media/`, `chromium/src/media/cast/` | Medium: affects media feature graph and test support dependencies. |
| `0003-disable-gpu.patch` | `content/gpu/BUILD.gn`, `gpu/skia_bindings/BUILD.gn` | Prepare an iPod touch 5 / Apple A5 mode that omits the out-of-process GPU target and marks Skia GPU bindings as disableable for iOS ARMv7. | `chromium/src/content/gpu/`, `chromium/src/gpu/` | High: GPU process and Skia GPU backend removal can affect compositing assumptions. |
| `0004-disable-webrtc.patch` | `media/media_options.gni` | Disable media remoting/RPC in the iOS ARMv7 CEF Lite configuration and document that MediaStream, PeerConnection, and WebRTC are outside scope. | `chromium/src/media/media_options.gni`; related review area: `chromium/src/media/webrtc/` | Medium: avoids WebRTC surface but may require follow-up if other WebRTC imports remain reachable. |
| `0005-ios9-sdk-compat.patch` | `build/config/ios/ios_sdk.gni` | Add an optional `ios_sdk_overlay_path` so the port can point at `Chromium-iPhoneOS9.3.sdk` without modifying Xcode SDKs in place. | `chromium/src/build/config/ios/ios_sdk.gni` | Medium: changes SDK path selection during GN generation. |
| `0006-v8-arm32.patch` | `v8/BUILD.gn`, `v8/gni/v8.gni` | Add an explicit iOS ARM32 V8 mode and enable V8 lite mode for that target. | `chromium/src/v8/BUILD.gn`, `chromium/src/v8/gni/v8.gni`; related review area: `chromium/src/v8/src/` | High: V8 ARM32 behavior must be revalidated on macOS/iOS before build use. |
| `0007-memory-optimize.patch` | `content/public/common/content_switches.cc`, `content/public/common/content_switches.h`, `third_party/blink/renderer/platform/runtime_enabled_features.json5` | Add a low-memory switch/feature marker for the 512MB iPod touch 5 target. | `chromium/src/content/public/common/`, `chromium/src/third_party/blink/renderer/platform/` | Medium: introduces markers only; real cache/renderer/Blink tuning still needs runtime plumbing. |

## Focus area findings

### ARMv7

Reviewed paths:

- `chromium/src/build/config/arm.gni`
- `chromium/src/ios/build/config.gni`

The ARMv7 patch applies directly to Chromium 72 and targets existing ARM configuration branches. Risk remains high because iOS ARMv7 was removed from supported production configurations and requires macOS GN/build validation later.

### FFmpeg

Reviewed paths:

- `chromium/src/media/BUILD.gn`
- `chromium/src/media/cast/BUILD.gn`

The ffmpeg patch corresponds to existing Chromium 72 media files and guards the import/dependency path when `media_use_ffmpeg=false`. This matches the `.gclient` policy that does not download `third_party/ffmpeg`.

### GPU

Reviewed paths:

- `chromium/src/gpu/`
- `chromium/src/content/gpu/`

The requested `content/browser/gpu` review area does not exist in this Chromium 72 checkout; the matching Chromium 72 GPU process GN target is under `content/gpu/BUILD.gn`.

### WebRTC

Reviewed path:

- `chromium/src/media/webrtc/`

The current patch only updates `media/media_options.gni`; it does not yet patch files under `media/webrtc/`. Risk is medium because a future macOS GN pass may reveal additional reachable `media/webrtc` targets.

### V8

Reviewed paths:

- `chromium/src/v8/BUILD.gn`
- `chromium/src/v8/gni/v8.gni`
- `chromium/src/v8/src/`

The patch applies to V8 GN configuration files. It does not directly patch `v8/src/`, so runtime/compile behavior remains a high-risk follow-up item.

## CEF Lite audit addition

Stage 4.1 adds a minimal task API layer:

- `cef-lite/include/cef_task.h`
- `cef-lite/src/cef_task.cc`

The API provides:

- `CefPostTask()`
- `CefDoMessageLoopWork()`
