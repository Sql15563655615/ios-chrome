# Stage 4.5 Target Impact Report

This report maps each Stage 4-pre patch to the Chromium 72 target families it can affect.

## Patch-to-target mapping

| Patch | Impacted targets / target families | Notes |
| --- | --- | --- |
| `0001-build-armv7-ios.patch` | `//build/config` ARM defaults, iOS config layers, `//media:media`, `//v8:*` ARM consumers | The ARM ABI defaults propagate into media and V8 build selection. |
| `0002-disable-ffmpeg.patch` | `//media:media`, `//media/cast:test_support`, `//media/cast:cast_sender`, `//media/cast:cast_receiver` | FFmpeg gating changes media library wiring and test-support reachability. |
| `0003-disable-gpu.patch` | `//content/gpu:gpu`, `//content/gpu:gpu_sources`, `//gpu/skia_bindings:skia_bindings` | The GPU process group and Skia GPU bindings are directly affected. |
| `0004-disable-webrtc.patch` | `//media:media_buildflags`, `//media:media`, `//content/public/common:static_switches`, `//content/public/common:common_sources` | Media remoting and WebRTC-related defaults flow into public content/media targets. |
| `0005-ios9-sdk-compat.patch` | iOS SDK configuration targets in `//build/config` and downstream iOS toolchain consumers | This changes sysroot selection and SDK overlay behavior. |
| `0006-v8-arm32.patch` | `//v8:v8`, `//v8:gn_all`, `//v8` ARM32 configuration consumers | ARM32 V8 mode affects the core V8 build graph. |
| `0007-memory-optimize.patch` | `//content/public/common:static_switches`, `//content/public/common:common_sources`, `//third_party/blink/renderer/platform:runtime_enabled_features`, `//third_party/blink/renderer/platform:blink_platform_public_deps` | The switch constant and runtime feature marker are both build-visible. |

## Directory impact summary

| Directory | Patches touching it | Impact |
| --- | --- | --- |
| `build/` | `0001`, `0005` | ARM defaults and iOS SDK selection. |
| `content/` | `0003`, `0007` | GPU group wiring and content switch surface. |
| `gpu/` | `0003` | Skia GPU binding target. |
| `media/` | `0001`, `0002`, `0004` | Media build options and media/cast reachability. |
| `ios/` | `0001`, `0005` | iOS configuration and SDK compatibility. |
| `v8/` | `0001`, `0006` | ARM defaults and V8 ARM32/lite-mode behavior. |
| `blink/` | `0007` | Generated runtime feature list. |

## Target impact observations

- The heaviest target-impact patches are `0001`, `0003`, and `0006` because they influence the ARM, GPU, and V8 build cores.
- `0002` and `0004` primarily affect media target composition and optional media feature availability.
- `0007` is small in surface area but important because it touches exported content constants and Blink generated feature plumbing.
