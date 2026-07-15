# Chromium 72 Dependency Audit for iOS 9 ARMv7

Stage 2.5 validates the route before any `gclient sync` or full source download.

## Known release anchors

| Item | Finding | Evidence / note |
| --- | --- | --- |
| Chromium/Chrome 72 release | Chrome 72.0.3626.81 was promoted to stable on 2019-01-29. The project remains pinned to the 72.0.x line, with `72.0.3626.122` as the current proposed checkout tag. | Chrome Releases stable post: https://chromereleases.googleblog.com/2019/01/stable-channel-update-for-desktop.html |
| V8 version | Chrome 72 ships V8 7.2. | Chrome Developers says V8 7.2 ships with Chrome 72; V8 release post published 2018-12-18. Sources: https://developer.chrome.com/blog/new-in-chrome-72 and https://v8.dev/blog/v8-release-72 |
| Blink version | Blink is not a separately shipped semantic version in Chromium 72. Treat Blink as the `third_party/blink/` revision contained by the pinned Chromium 72 commit. | Must be confirmed after checkout by recording the Chromium commit and `third_party/blink/` tree state. |
| GN version | Use the GN binary from Chromium 72 `depot_tools`/`buildtools` matching the checkout. Do not assume a modern standalone GN is compatible. | Confirm after checkout with `gn --version` from `chromium/src/buildtools/*/gn`. |
| Python version | Chromium 72 build tooling is Python 2.7 era with incremental Python 3 support incomplete. Stage 2.5 assumes Python 2.7 is required for maximum compatibility. | Confirm after checkout by inspecting `depot_tools`, `build`, `tools`, and shebangs. |
| clang version | Use Chromium 72's pinned clang toolchain if possible. A newer host clang may compile some code, but the first feasibility pass should avoid mixing unvalidated compiler behavior with ARMv7/iOS patches. | Confirm after checkout through `tools/clang/scripts/update.py` and build config. |
| Xcode version | iOS 9.3 SDK availability implies an older Xcode SDK or a preserved SDK path. Modern Xcode can be used as a host only if the build is forced to the iPhoneOS9.3 SDK plus overlay and does not require iOS 10+ SDK symbols. | Requires local toolchain validation; do not modify Xcode SDK contents. |

## clang + iPhoneOS9.3 SDK overlay feasibility

Preliminary answer: **possible but high-risk**.

The preferred route is:

1. Use a modern-enough clang only as the compiler driver if Chromium 72's pinned clang cannot target the host environment.
2. Force the sysroot to an iPhoneOS9.3 SDK path.
3. Add `sdk/iPhoneOS9.3.patch/` before SDK include paths.
4. Patch Chromium 72 iOS build files to avoid iOS 10+ and 64-bit-only assumptions.
5. Verify every availability shim is compile-time only; runtime paths must not call unavailable APIs on iOS 9.3.5.

Risk areas:

- Chromium 72 may assume newer Xcode/iOS SDK declarations in `ios/` or Objective-C++ files.
- Modern clang defaults may emit warnings/errors or ARM codegen choices not expected by Chromium 72.
- ARMv7 iOS device code signing and bitcode settings may conflict with historical Chromium iOS assumptions.
- V8 JIT/executable memory policy is likely a larger blocker than the ARM backend itself.

## Gate before source download

Proceed to source checkout only after accepting these constraints:

- The Blink version will be pinned by Chromium commit, not a separate release number.
- Python 2.7 compatibility may be required.
- The iPhoneOS9.3 SDK overlay is a build compatibility layer, not a guarantee of runtime API safety.
- Full Chromium compile is still explicitly out of scope until after source audit patches exist.
