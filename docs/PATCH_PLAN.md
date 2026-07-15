# Chromium 72 iOS 9.3 ARMv7 Patch Plan

Patch application order is numeric across subsystem directories. Stage 1 contains patch plans/placeholders only; real Chromium hunks are added after the Chromium 72 source checkout is confirmed.

| Order | Subsystem | Patch | Purpose |
| --- | --- | --- | --- |
| 0001 | build | `patches/build/0001-enable-armv7-ios.patch` | Allow GN/build files to accept iOS 9.3 ARMv7 configuration. |
| 0002 | content | `patches/content/0002-disable-gpu.patch` | Force software compositing and remove GPU process assumptions. |
| 0003 | v8 | `patches/v8/0001-v8-arm32-ios9.patch` | Tune V8 for ARM32/low-memory iOS devices. |
| 0004 | sdk | `patches/sdk/0004-ios-sdk-compat.patch` | Add SDK overlay include paths and compatibility hooks. |
| 0005 | blink | `patches/blink/0005-low-memory-blink.patch` | Reduce cache pressure and disable unneeded runtime features. |
| 0006 | mojo | `patches/mojo/0006-single-process-mojo.patch` | Adapt Mojo assumptions for the constrained single-app target. |
| 0007 | ios | `patches/ios/0007-uikit-shell-hooks.patch` | Add hooks needed by the Objective-C++ UIKit shell. |

## Patch rules

- Use `git format-patch` style headers when possible.
- Keep one logical concern per patch.
- Include a rationale and testing notes in the commit message or patch body.
- Verify with `git apply --check <patch>` against the intended Chromium 72 tree before marking a patch ready.
