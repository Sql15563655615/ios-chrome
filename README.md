# Chromium72-iOS9-ARMv7-CEF-Lite (`ios-chrome`)

This repository is a staged open-source porting workspace for a lightweight Chromium 72 based browser targeting legacy ARMv7 iOS devices such as iPod touch 5, iPhone 4s, and iPad 2.

> **Stage 1 status:** this repo intentionally does **not** vendor or download full Chromium yet. It provides the project layout, GN argument seed, patch plan, SDK compatibility overlay layout, build scripts, and CI skeleton. Chromium source checkout starts only after maintainer confirmation.

## Goal

Run a minimal browser stack on:

- **Devices:** iPod touch 5 / iPhone 4s / iPad 2 class hardware
- **SoC:** Apple A5 / ARMv7
- **Memory target:** 512 MB RAM
- **OS target:** iOS 9.3.5
- **Deployment target:** iOS 9.3
- **Rendering engine:** Chromium Blink + V8, not system WebKit
- **Embedding layer:** CEF Lite style C++ API
- **Shell:** UIKit Objective-C++ app shell

## Non-goals

- Do not build full Google Chrome.
- Do not upgrade to Chromium 80+.
- Do not target ARM64.
- Do not depend on iOS 10+ APIs.
- Do not use Swift.
- Do not use system `WKWebView` / WebKit for page rendering.

## Repository layout

```text
Chromium72-iOS9-ARMv7-CEF-Lite/
├── chromium/
│   └── src/                 # Future Chromium 72 checkout root; empty in stage 1
├── cef-lite/                # Minimal CEF-like public API and browser host layer
├── ios-shell/               # UIKit Objective-C++ shell
├── sdk/
│   └── iPhoneOS9.3.patch/   # Compatibility overlay; never modify original SDK
├── patches/                 # Numbered Chromium patch series, grouped by subsystem
├── scripts/                 # Bootstrap/build/validation helpers
├── docs/                    # Porting notes and plans
├── build/args/              # GN arg presets
└── README.md
```

## Build strategy

The intended build keeps only the libraries needed by an embedded browser:

- `base`
- `content`
- `blink`
- `v8`
- `net`
- `cc`
- `skia`
- `mojo`
- `cef-lite`

The following Chromium components are excluded or stubbed where possible:

- `chrome/`
- `chromeos/`
- `extensions/`
- `printing/`
- `sync/`
- `google_apis/`
- `webrtc/`
- PDF, plugins, downloads, and background service features

## GN target profile

The primary configuration is `build/args/ios9_armv7.gn`.

Key properties:

- `target_os = "ios"`
- `target_cpu = "arm"`
- `arm_version = 7`
- `ios_deployment_target = "9.3"`
- GPU process disabled
- WebRTC disabled
- extensions disabled
- printing disabled
- PDF disabled
- sandbox disabled for legacy iOS bring-up
- ARM32 V8 optimization enabled
- `symbol_level = 0`
- `blink_symbol_level = 0`
- `use_jumbo_build = true`

## SDK compatibility policy

The original iPhoneOS9.3 SDK must remain immutable. Compatibility is layered through `sdk/iPhoneOS9.3.patch/` and applied by scripts or include path ordering during the build.

Planned overlay areas:

- `Availability.h`
- `os/availability.h`
- Network.framework weak-link/stub declarations
- UIKit API availability guards and compatibility declarations

## Patch policy

Patch files live under `patches/<subsystem>/` and are numbered in application order. Each patch must include:

1. A numeric prefix, for example `0001-`.
2. A short description in the patch subject/body.
3. A diff that can be applied with `git apply` to the intended Chromium 72 tree or this repo if explicitly marked as a repository-local patch.

See `docs/PATCH_PLAN.md` for the first-stage patch queue.

## CEF Lite API target

`cef-lite/` will expose a deliberately small API similar to the embedding surface of `WKWebView` while using Chromium internals:

- `createBrowser()`
- `loadURL()`
- `executeJavaScript()`

Out of scope for CEF Lite:

- extensions
- printing
- media pipeline beyond minimal HTML rendering bring-up
- downloads
- plugin hosting

## UIKit shell target

`ios-shell/` will contain Objective-C++ only:

- `AppDelegate.mm`
- `BrowserViewController.mm`
- `ChromiumView.mm`
- `TouchHandler.mm`
- `KeyboardHandler.mm`

Its purpose is to display Chromium-rendered content through UIKit and forward touch/keyboard events into the Chromium content layer.

## Stage plan and commit plan

1. **Initialize project structure** — create repository layout and documentation skeleton.
2. **Add GN configuration** — add iOS 9.3 ARMv7 build arguments and validation scripts.
3. **Add SDK compatibility layer** — add SDK overlay layout and compatibility notes.
4. **Add Chromium patch queue** — add numbered patch plan and initial patch placeholders.
5. **Add CEF Lite** — add minimal browser API and host abstraction.
6. **Add iOS UIKit Shell** — add Objective-C++ UIKit shell files.

## Stage 4.4 status

Stage 4.4 focuses on Chromium 72 patch impact auditing rather than build execution.

### Completed

- Patch impact audit documentation for the Stage 4-pre series.
- Patch dependency graph documentation.
- Patch coverage audit documentation.
- CEF Lite implementation correspondence audit.
- Patch-target verification script.

### Current completion

- The repository now has audit coverage for the Stage 4-pre patch series and the local CEF Lite API surface.

### Still pending

- GN generation.
- Ninja build.
- macOS validation.
- Chromium source modification.
- Chromium runtime integration.

### Explicitly not entered yet

- GN generation.
- Ninja build.
- macOS validation.

## Stage 1 build/check workflow

```bash
scripts/bootstrap_stage1.sh
scripts/validate_stage1.sh
```

These checks validate repository shape and configuration only. They do not download Chromium and do not compile a browser yet.
