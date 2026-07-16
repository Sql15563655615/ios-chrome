# Stage 3.4 macOS iOS Toolchain GN Report

Stage 3.4 defines the required macOS validation environment for Chromium 72 iOS ARMv7 GN generation. This repository session is running on Linux, so the macOS `gn gen` validation command could not be completed here without entering unsupported host-toolchain patching. No compilation was attempted.

## Host OS

Current session host:

```text
Linux x86_64
```

Required host for Chromium 72 iOS GN:

```text
macOS, with GN seeing host_os = "mac"
```

Result: **not validated in this Linux session**.

## Xcode version

Command to run on macOS:

```bash
xcodebuild -version
```

Current session result: **not available** because this host is Linux.

## SDK path

Command to run on macOS:

```bash
xcrun --sdk iphoneos --show-sdk-path
```

Current session result: **not available** because this host is Linux.

Overlay SDK policy:

```text
SDKROOT=/path/to/Chromium-iPhoneOS9.3.sdk
```

The Xcode SDK must not be modified in place. The iOS 9.3 compatibility files belong in the `Chromium-iPhoneOS9.3.sdk` overlay.

## Tool paths to record on macOS

```bash
xcrun --sdk iphoneos --find clang
xcrun --sdk iphoneos --find clang++
```

Record both resolved paths before running GN.

## GN version

The Chromium 72 pinned GN version already recovered for the Linux checkout is:

```text
1496 (0790d304)
```

On macOS, verify the macOS buildtools GN binary after `gclient sync --nohooks`:

```bash
cd chromium/src
buildtools/mac/gn --version
```

## args.gn status

`build/args/ios9_armv7.gn` now contains the required boolean Xcode host-tooling setting:

```gn
use_system_xcode = true
```

The existing iOS ARMv7 settings remain:

```gn
is_component_build = false
ios_deployment_target = "9.3"
```

## GN generation command for macOS

Run only GN generation; do not run Ninja:

```bash
cd chromium/src
buildtools/mac/gn gen out/ios9_armv7
```

Success criterion:

```text
chromium/src/out/ios9_armv7/build.ninja exists
```

## Current GN result

Result in this Linux session: **blocked by host OS**.

Classification: **toolchain / host environment**.

Reason: Chromium 72 iOS GN evaluates `build/toolchain/mac`, `build/config/mac`, and Xcode probing logic during generation. That path requires macOS and is not a supported Linux-host GN generation flow.

## Stop point

No `ninja` command was run. No ARM patching was started.
