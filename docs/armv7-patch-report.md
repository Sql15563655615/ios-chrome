# ARMv7 Patch Report

This report records the Linux-side Chromium 72 source preparation for iOS 9.3 ARMv7. No GN generation or compilation is required for this stage.

## Inspected files

- `chromium/src/build/config/arm.gni`
- `chromium/src/build/config/compiler/BUILD.gn`
- `chromium/src/ios/build/config.gni`

## Patch

`patches/0001-build-armv7-ios.patch` is a real `git diff` patch that applies against the pinned Chromium 72 checkout under `chromium/src`.

## ARMv7 intent

The patch prepares the ARMv7 iOS configuration by:

- selecting iOS-specific ARM softfp defaults for ARMv7 and ARMv8 code paths when `target_os == "ios"` or `current_os == "ios"`;
- keeping NEON enabled for the ARMv7 iOS target;
- adding an explicit `ios_enable_armv7` marker in `ios/build/config.gni` for the iOS 9.3 ARMv7 feasibility target.

## Validation

The patch is validated with:

```bash
git apply --check patches/0001-build-armv7-ios.patch
```

The full patch set is validated with:

```bash
git apply --check patches/*.patch
```
