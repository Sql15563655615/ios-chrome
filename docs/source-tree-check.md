# Chromium 72 Source Tree Check

Stage 3.2 checked the local Chromium source root after recovering the `chromium/src` checkout.

## Checkout identity

```text
chromium/src HEAD: 029c7e1925ccccf13fcec39dd99d49946835ec28
Chromium version: 72.0.3626.122
```

## Required root entries

| Required path | Status | Notes |
| --- | --- | --- |
| `chromium/src/.gn` | Present | GN source-root marker exists. |
| `chromium/src/BUILD.gn` | Present | Root build file exists. |
| `chromium/src/build/` | Present | Build configuration tree exists. |
| `chromium/src/base/` | Present | Base source tree exists. |
| `chromium/src/third_party/` | Present | Third-party container exists. |
| `chromium/src/v8/` | Present | V8 source tree exists. |
| `chromium/src/content/` | Present | Content source tree exists. |

## Intentional exclusions

| Path | Status | Reason |
| --- | --- | --- |
| `chromium/src/third_party/devtools-node-modules/` | Missing | Intentionally excluded by `chromium/.gclient` `custom_deps`; not needed for iOS ARMv7 GN feasibility. |
| `chromium/src/third_party/ffmpeg/` | Missing | Intentionally excluded by `chromium/.gclient` `custom_deps`; this can still affect default GN targets that reference `//third_party/ffmpeg`. |

## Result

The Chromium source root itself is recovered: `.gn`, `BUILD.gn`, and the required top-level source directories are present. The only observed missing directories in this check are the intentionally excluded dependencies listed above.
