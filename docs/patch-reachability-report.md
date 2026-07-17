# Stage 4.5 Patch Reachability Report

This report classifies each Stage 4-pre patch by whether its modified location is reachable from the Chromium 72 build/runtime graph.

## Classification legend

- **Reachable** — the edited file is directly imported or compiled by a known Chromium 72 target family.
- **Potentially Reachable** — the edited file is a config or support file that is likely consumed, but the current audit cannot point to a single direct consuming target in the local snapshot.
- **Dead** — no known build/runtime path uses the edited file.
- **Unknown** — the snapshot is insufficient to prove reachability.

## Patch-by-patch reachability

| Patch | Modified files | Reachability | Why |
| --- | --- | --- | --- |
| `0001-build-armv7-ios.patch` | `build/config/arm.gni`, `ios/build/config.gni` | **Potentially Reachable** | `build/config/arm.gni` is imported by `//media/BUILD.gn` and `//v8/BUILD.gn`; the `ios/build/config.gni` edit is an iOS config hook, but no direct import edge was found in the audited snapshot. |
| `0002-disable-ffmpeg.patch` | `media/BUILD.gn`, `media/cast/BUILD.gn` | **Reachable** | Both files are active build definitions. `media/BUILD.gn` controls the `//media` component and `media/cast/BUILD.gn` defines `test_support`, `cast_sender`, and `cast_receiver`. |
| `0003-disable-gpu.patch` | `content/gpu/BUILD.gn`, `gpu/skia_bindings/BUILD.gn` | **Reachable** | `content/gpu/BUILD.gn` defines `group("gpu")`; `gpu/skia_bindings/BUILD.gn` defines `source_set("skia_bindings")`. |
| `0004-disable-webrtc.patch` | `media/media_options.gni` | **Reachable** | `media/media_options.gni` is imported by `media/BUILD.gn`, `media/cast/BUILD.gn`, `content/gpu/BUILD.gn`, and `content/public/common/BUILD.gn`. |
| `0005-ios9-sdk-compat.patch` | `build/config/ios/ios_sdk.gni` | **Reachable** | The file participates in the iOS SDK configuration layer that is imported by Chromium build configuration. |
| `0006-v8-arm32.patch` | `v8/BUILD.gn`, `v8/gni/v8.gni` | **Reachable** | `v8/BUILD.gn` imports `gni/v8.gni`, and both files are part of the active V8 build graph. |
| `0007-memory-optimize.patch` | `content/public/common/content_switches.cc`, `content/public/common/content_switches.h`, `third_party/blink/renderer/platform/runtime_enabled_features.json5` | **Reachable** | `content/public/common/BUILD.gn` exposes `static_switches`/`common_sources`, and Blink `BUILD.gn` generates `runtime_enabled_features.*` from the JSON5 file. |

## Reachability findings

- **Reachable:** `0002`, `0003`, `0004`, `0005`, `0006`, `0007`
- **Potentially Reachable:** `0001`
- **Dead:** none identified
- **Unknown:** none required for the current snapshot

## Notes

- `0001` is conservative because the iOS config hook is real but the local snapshot does not show a direct `import("//ios/build/config.gni")` edge.
- `0007` is build-reachable even though its runtime behavior remains a later-stage wiring task.
