# ARMv7 Support Map for Chromium 72

This file lists expected Chromium 72 areas that mention or affect ARMv7/iOS support. Status values:

- **KEEP**: likely usable as-is or conceptually required.
- **PATCH**: likely needs source changes for iOS 9 ARMv7.
- **REMOVE**: should be excluded from the CEF Lite target or low-memory profile.

## `build/config/`

| Area / file | Status | Reason |
| --- | --- | --- |
| `build/config/arm.gni` | PATCH | Verify `arm_version = 7` handling for `target_os = "ios"`; remove Android/Linux-only assumptions. |
| `build/config/compiler/BUILD.gn` | PATCH | Ensure clang target, minimum iOS version, and ARMv7 flags are valid for iPhoneOS9.3. |
| `build/config/ios/` | PATCH | Check for arm64-only defaults, modern SDK assumptions, bitcode, and code signing settings. |
| `build/config/sanitizers/` | REMOVE | Sanitizers are not part of the 512MB device feasibility profile. |
| `build/config/jumbo.gni` | KEEP | Jumbo build remains useful for build-time feasibility once compilation begins. |

## `ios/`

| Area / file | Status | Reason |
| --- | --- | --- |
| `ios/build/config.gni` | PATCH | Main place to validate deployment target and 32-bit device acceptance. |
| `ios/chrome/` | REMOVE | Full Chrome shell is explicitly out of scope. |
| `ios/web/` | PATCH | Chromium iOS historically wraps WebKit; must not become the renderer path for this project. |
| `ios/testing/` | REMOVE | Not needed for the initial CEF Lite runtime target. |
| `ios/third_party/` | PATCH | Audit any SDK/API assumptions when source is available. |

## `third_party/`

| Area / file | Status | Reason |
| --- | --- | --- |
| `third_party/blink/` | PATCH | Keep Blink engine, but reduce runtime features and memory pressure. |
| `third_party/skia/` | PATCH | Keep software raster path; remove GPU-heavy paths where practical. |
| `third_party/webrtc/` | REMOVE | WebRTC is disabled for memory and dependency reduction. |
| `third_party/pdfium/` | REMOVE | PDF is outside the CEF Lite target. |
| `third_party/ffmpeg/` | PATCH | Keep only minimal open-codec surface if media is retained at all. |
| `third_party/icu/` | PATCH | Consider reduced data packaging because V8 i18n is disabled in the GN profile. |
| `third_party/angle/` | REMOVE | GPU/ANGLE paths are not part of the initial software-rendered target. |
| `third_party/swiftshader/` | REMOVE | Software GPU emulation is too expensive for the 512MB target. |

## `v8/`

| Area / file | Status | Reason |
| --- | --- | --- |
| `v8/BUILD.gn` | PATCH | Confirm ARM backend source selection and disable unsupported optional features. |
| `v8/src/arm/` | KEEP | Required ARM32 backend. |
| `v8/src/arm64/` | REMOVE | ARM64 is explicitly out of scope. |
| `v8/src/wasm/` | PATCH | Audit executable memory and memory pressure before enabling WebAssembly. |
| `v8/src/snapshot/` | PATCH | Snapshot strategy affects startup memory and packaging. |
| `v8/src/base/platform/` | PATCH | Executable memory/JIT policy is a high-risk iOS 9 device area. |

## Source checkout audit commands for later

Do not run these until Chromium 72 has been checked out:

```bash
rg -n "armv7|arm_version|target_cpu.*arm|ARCHS|VALID_ARCHS|IPHONEOS_DEPLOYMENT_TARGET" chromium/src/build/config chromium/src/ios chromium/src/third_party chromium/src/v8
rg -n "arm64|ios.*10|API_AVAILABLE|WKWebView|WebKit" chromium/src/ios chromium/src/v8 chromium/src/third_party/blink
```
