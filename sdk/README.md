# iPhoneOS9.3 SDK Overlay

This directory contains compatibility overlays for building Chromium 72 derived code against an iPhoneOS9.3 SDK profile.

## Policy

- Do not edit or replace the Xcode-provided SDK.
- Do not copy a full proprietary SDK into this repository.
- Keep compatibility declarations in `sdk/iPhoneOS9.3.patch/`.
- Add the overlay through include path ordering or targeted build patches.
- Runtime code must still guard or avoid APIs unavailable on iOS 9.3.5.

## Overlay contents

- `Availability.h` supplies modern availability macro fallbacks before delegating to the next SDK header.
- `os/availability.h` supplies fallback availability macros for code that includes the newer path.
- `Network.framework.stub.h` provides minimal opaque types so newer network declarations can be compiled out or weak-linked.
- `UIKitCompatibility.h` forward-declares scene-related UIKit symbols such as `UIScene` and `UIWindowScene` and defines availability macro fallbacks for code that must compile while not using those APIs at runtime.

## Intended build integration

After the Chromium 72 source checkout is available, build patches should add the overlay include directory before the SDK include paths only for the iOS 9.3 ARMv7 configuration:

```text
-I//sdk/iPhoneOS9.3.patch
```

This approach keeps the original Xcode SDK immutable and makes every compatibility shim reviewable in git.
