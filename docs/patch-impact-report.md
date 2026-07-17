# Stage 4.4 Chromium 72 Patch Impact Audit

Audit target:

- Chromium: `72.0.3626.122`
- Commit: `029c7e1925ccccf13fcec39dd99d49946835ec28`

Scope:

- Stage 4-pre patch series under `patches/`
- Chromium 72.0.3626.122 source-path verification
- No GN generation
- No Ninja build
- No Chromium source modification

## Validation summary

- `git apply --check patches/*.patch` passes against the patch series in this repository.
- The patch targets are anchored to Chromium 72 source paths that exist in the pinned checkout layout.
- No patch in this series references Chromium 80+ directory layouts, Chromium 90+ API additions, or Chromium 100+ `BUILD.gn` constructs.

## Patch-by-patch impact table

| Patch | Modified files | BUILD.gn | .gni | .cc | .h | Purpose | Impacted modules | Impacted targets | GN impact | Compile impact | Runtime impact | Risk | Dead patch | Duplicate patch |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `0001-build-armv7-ios.patch` | `build/config/arm.gni`, `ios/build/config.gni` | No | Yes | No | No | Restore explicit iOS ARMv7 feasibility defaults and add an `ios_enable_armv7` marker for iOS 9.3. | `build/`, `ios/` | Toolchain/config propagation, iOS ARM feature gating | Yes: changes arm ABI defaults and iOS config branching. | Medium: alters ARM FPU/ABI assumptions. | Medium: changes how later targets are configured, but not runtime code directly. | High | No | No |
| `0002-disable-ffmpeg.patch` | `media/BUILD.gn`, `media/cast/BUILD.gn` | Yes | No | No | No | Keep FFmpeg excluded from the build graph and prevent cast test support from assuming FFmpeg-enabled media. | `media/`, `media/cast/`, `third_party/ffmpeg/` | Media library graph, cast test support | Yes: guards `ffmpeg_options.gni` import and dependent sources. | Medium: may change symbol availability in media targets. | Low to medium: mostly removes optional media paths. | Medium | No | No |
| `0003-disable-gpu.patch` | `content/gpu/BUILD.gn`, `gpu/skia_bindings/BUILD.gn` | Yes | No | No | No | Omit the out-of-process GPU target for iOS ARMv7 feasibility builds and mark Skia GPU backend selection as disableable. | `content/`, `gpu/` | `//content/gpu:gpu`, `//gpu/skia_bindings:skia_bindings` | Yes: changes public deps for the content GPU group and adds a new build arg. | Medium to high: can affect GPU-specific source inclusion. | Medium to high: impacts compositor/GPU process routing and runtime rendering mode. | High | No | No |
| `0004-disable-webrtc.patch` | `media/media_options.gni` | No | Yes | No | No | Disable media remoting/RPC for the iOS ARMv7 CEF Lite target and document that WebRTC is out of scope. | `media/`, `third_party/webrtc/` | Media remoting / WebRTC feature gating | Yes: changes media configuration defaults used by downstream targets. | Low to medium: mostly compile-time option gating. | Medium: reduces reachable remoting/WebRTC code paths. | Medium | No | No |
| `0005-ios9-sdk-compat.patch` | `build/config/ios/ios_sdk.gni` | No | Yes | No | No | Allow GN to point at an immutable iPhoneOS9.3 overlay SDK without altering the host Xcode installation. | `build/config/ios/` | iOS SDK selection and sysroot resolution | Yes: adds an alternate SDK path input to iOS configuration. | Low: build settings only. | Low: affects compile environment, not app behavior directly. | Medium | No | No |
| `0006-v8-arm32.patch` | `v8/BUILD.gn`, `v8/gni/v8.gni` | Yes | Yes | No | No | Enable a dedicated ARM32 iOS V8 mode and tie V8 lite mode to the ARMv7 feasibility flag. | `v8/` | V8 feature flags, ARM32 configuration | Yes: introduces a new V8 arg consumed by the build graph. | High: changes V8 mode selection and compile-time feature surface. | High: influences runtime memory usage, sandboxing expectations, and JS engine behavior. | High | No | No |
| `0007-memory-optimize.patch` | `content/public/common/content_switches.cc`, `content/public/common/content_switches.h`, `third_party/blink/renderer/platform/runtime_enabled_features.json5` | No | No | Yes | Yes | Add low-memory markers for the 512MB iPod touch 5 feasibility target. | `content/`, `third_party/blink/` | Content switches and Blink runtime feature registry | Limited: no GN graph change, but runtime feature generation is affected. | Low: new exported switch/constant and runtime feature entry only. | Medium: the marker is intended for later runtime wiring and cache tuning. | Medium | No | No |

## Source verification findings

### Chromium 72 path anchoring

Every patch file in the current series targets existing Chromium 72.0.3626.122 source paths:

- `build/config/arm.gni`
- `ios/build/config.gni`
- `media/BUILD.gn`
- `media/cast/BUILD.gn`
- `content/gpu/BUILD.gn`
- `gpu/skia_bindings/BUILD.gn`
- `media/media_options.gni`
- `build/config/ios/ios_sdk.gni`
- `v8/BUILD.gn`
- `v8/gni/v8.gni`
- `content/public/common/content_switches.cc`
- `content/public/common/content_switches.h`
- `third_party/blink/renderer/platform/runtime_enabled_features.json5`

These paths are valid for the Chromium 72 tree layout and do not require later Chromium 80+/90+/100+ directories.

### Version drift review

- `0001-build-armv7-ios.patch`: no drift to newer directory layouts. The affected files are present in Chromium 72 and remain in the pre-`build/config` iOS tree.
- `0002-disable-ffmpeg.patch`: no drift. The patch continues to target `media/BUILD.gn` and `media/cast/BUILD.gn`, both present in Chromium 72.
- `0003-disable-gpu.patch`: no drift. The patch uses `content/gpu/BUILD.gn` rather than newer content GPU layout names.
- `0004-disable-webrtc.patch`: no drift. The patch touches `media/media_options.gni`, which exists in Chromium 72.
- `0005-ios9-sdk-compat.patch`: no drift. The patch updates the Chromium 72 iOS SDK GN layer only.
- `0006-v8-arm32.patch`: no drift. The patch targets the Chromium 72 V8 GN files and does not rely on post-72 pointer compression or sandbox layout.
- `0007-memory-optimize.patch`: no drift. The patch uses the Chromium 72 content switch registry and Blink runtime feature file.

## Risk and follow-up notes

- `0001` and `0006` are the highest-risk patches because they alter fundamental ARM/iOS/V8 build assumptions.
- `0003` is high-risk because it changes the GPU process target and could affect compositor and rendering assumptions.
- `0002`, `0004`, `0005`, and `0007` are lower-risk build or feature-gating changes, but they still need a later macOS GN pass once source checkout and toolchain validation are allowed.
- No dead patch was identified.
- No duplicate patch was identified.

