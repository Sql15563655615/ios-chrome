# macOS Build Host for Chromium 72 iOS ARMv7

Chromium 72 iOS GN generation must run on a macOS host. The iOS toolchain path imports macOS-specific GN files and probes Xcode during generation, so a Linux host is not a supported validation environment for `target_os = "ios"`.

## Host policy

| Host | Chromium 72 iOS GN support | Reason |
| --- | --- | --- |
| Linux | Unsupported | Chromium 72 iOS GN reaches `build/toolchain/mac`, `build/config/mac`, and Xcode probing scripts. These paths expect `host_os = "mac"` and Python 2-era Chromium 72 helper scripts. |
| macOS | Required target environment | Provides `xcrun`, Xcode SDK metadata, Apple clang, platform toolchains, and the expected `host_os = "mac"` GN behavior. |

## Why macOS is required

Chromium 72's iOS configuration imports and evaluates:

- `build/toolchain/mac/BUILD.gn`
- `build/config/mac/mac_sdk.gni`
- `build/config/ios/ios_sdk.gni`

Those files are not just compile-time settings; they are evaluated during `gn gen`. They query Xcode and SDK metadata with helper scripts and assume the Apple toolchain layout is present.

## Required macOS checks

Run these on the macOS host before GN generation:

```bash
sw_vers
xcodebuild -version
xcrun --sdk iphoneos --show-sdk-path
xcrun --sdk iphoneos --find clang
xcrun --sdk iphoneos --find clang++
```

Record the outputs in `docs/stage3.4-macos-gn-report.md`.

## iOS 9.3 SDK overlay strategy

Do not modify the installed Xcode SDK in place. The compatibility strategy is an overlay SDK named:

```text
Chromium-iPhoneOS9.3.sdk
```

The overlay should be a separate filesystem tree that supplies the iOS 9.3 headers, SDK settings, and compatibility shims needed by the port while leaving Xcode's original SDK immutable.

Recommended environment variables on macOS:

```bash
export SDKROOT=/path/to/Chromium-iPhoneOS9.3.sdk
export DEVELOPER_DIR=$(xcode-select -p)
export CHROMIUM_IOS93_SDK_OVERLAY=$SDKROOT
```

Use `xcrun` to resolve the actual Apple tool paths rather than hard-coding tool binaries:

```bash
export IOS_CLANG=$(xcrun --sdk iphoneos --find clang)
export IOS_CLANGXX=$(xcrun --sdk iphoneos --find clang++)
```

The Stage 3.4 validation only runs `gn gen`; it must not compile with `ninja`.

## GN command

From the macOS Chromium source checkout:

```bash
cd chromium/src
buildtools/mac/gn gen out/ios9_armv7
```

If the local checkout uses the Linux GN path only because it was prepared on Linux, first allow `gclient sync --nohooks` on macOS to populate the macOS buildtools, then rerun the command with the macOS GN binary.
