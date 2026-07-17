# Stage 4.4 Patch Dependency Graph

This graph describes the intended application order and logical dependency relationships for the Stage 4-pre patch series.

## Primary dependency chain

```text
0001-build-armv7-ios.patch
    ↓
0005-ios9-sdk-compat.patch
    ↓
0006-v8-arm32.patch
```

### Why this chain exists

- `0001-build-armv7-ios.patch` establishes the ARMv7/iOS feasibility target and the build-time ARM defaults that later patches assume.
- `0005-ios9-sdk-compat.patch` adds the iOS 9.3 SDK overlay hook needed by the ARMv7 feasibility path.
- `0006-v8-arm32.patch` uses the ARMv7/iOS target definition to turn on the dedicated V8 ARM32 mode.

## Independent patches

These patches are logically independent and can be reviewed or applied separately, although they still belong to the same Stage 4-pre series:

- `0002-disable-ffmpeg.patch`
- `0003-disable-gpu.patch`
- `0004-disable-webrtc.patch`
- `0007-memory-optimize.patch`

## Patch coupling notes

### `0002-disable-ffmpeg.patch`

- Depends only on Chromium 72 media GN structure.
- Does not depend on the ARMv7/iOS chain.
- Could be split later into a pure `media/BUILD.gn` import guard and a separate `media/cast/BUILD.gn` test-support adjustment.

### `0003-disable-gpu.patch`

- Shares the `is_ios && target_cpu == "arm"` feasibility condition with the ARMv7 line.
- Is logically downstream of `0001` because it assumes the ARMv7 iOS build profile.
- Could be split later into a GPU-process target change and a Skia GPU backend gating change.

### `0004-disable-webrtc.patch`

- Independent from the ARMv7/V8 chain, but conceptually tied to the same iOS ARMv7 CEF Lite profile.
- Could later be split into remoting disablement and WebRTC scope documentation.

### `0007-memory-optimize.patch`

- Independent from the build-graph chain.
- Could later be split into a `content_switches` addition and a Blink runtime feature marker if the runtime plumbing grows.

## Summary of ordering rules

### Must be applied first

- `0001-build-armv7-ios.patch`

### Must follow the ARMv7 base line

- `0005-ios9-sdk-compat.patch`
- `0006-v8-arm32.patch`
- `0003-disable-gpu.patch` is best reviewed after `0001` because it shares the same iOS ARMv7 feasibility assumptions.

### Can be applied independently

- `0002-disable-ffmpeg.patch`
- `0004-disable-webrtc.patch`
- `0007-memory-optimize.patch`

