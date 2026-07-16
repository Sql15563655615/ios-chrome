# Stage 3.2 GN Report

Stage 3.2 recovered the Chromium 72 source root enough for GN to identify `chromium/src` as a valid source tree. No Chromium source files were edited, no ARM patches were started, and no compilation was attempted.

## gclient configuration

`chromium/.gclient` now pins the source solution to Chromium 72 commit:

```text
029c7e1925ccccf13fcec39dd99d49946835ec28
```

The configuration keeps:

- Chromium 72 source checkout through `src`.
- `target_os = ["ios"]` for the iOS target dependency set.

The configuration continues to avoid:

- `src/third_party/devtools-node-modules`
- `src/third_party/ffmpeg`

## Sync result

Command:

```bash
cd chromium
PATH=/workspace/depot_tools:$PATH gclient sync --nohooks --no-history --revision src@029c7e1925ccccf13fcec39dd99d49946835ec28
```

Result: **PASS**.

Hooks were not run, preserving the known Stage 3 Python 2 hook workaround.

## Source tree status

| Path | Status |
| --- | --- |
| `chromium/src/.gn` | Present |
| `chromium/src/BUILD.gn` | Present |
| `chromium/src/build/` | Present |
| `chromium/src/base/` | Present |
| `chromium/src/third_party/` | Present |
| `chromium/src/v8/` | Present |
| `chromium/src/content/` | Present |

The source tree check is recorded separately in `docs/source-tree-check.md`.

## GN executable

The Chromium 72 pinned GN binary remains usable:

```text
1496 (0790d304)
```

## GN generation result

### Requested command without preseeded args

Command:

```bash
cd chromium/src
buildtools/linux64/gn/gn gen out/ios9_armv7
```

Result: **FAIL**.

Output:

```text
ERROR at //media/cast/BUILD.gn:285:15: Can't load input file.
    deps += [ "//third_party/ffmpeg" ]
              ^---------------------
Unable to load:
  /workspace/ios-chrome/chromium/src/third_party/ffmpeg/BUILD.gn
I also checked in the secondary tree for:
  /workspace/ios-chrome/chromium/src/build/secondary/third_party/ffmpeg/BUILD.gn
```

Classification: **A source tree**.

Reason: default GN generation still reaches a target path that references `//third_party/ffmpeg`, while `ffmpeg` is intentionally excluded by `chromium/.gclient`.

### Args parse check using the staged iOS ARMv7 args

To check the existing iOS ARMv7 args path without compiling, `build/args/ios9_armv7.gn` was copied into the ignored local output directory as `chromium/src/out/ios9_armv7/args.gn`, then the same GN generation command was retried.

Result: **FAIL**.

Output:

```text
ERROR at //build/config/ios/ios_sdk.gni:92:7: Operand of ! operator is not a boolean.
  if (!use_system_xcode) {
      ^----------------
Type is "string" instead.
See //remoting/remoting_enable.gni:8:3: whence it was imported.
  import("//build/config/ios/ios_sdk.gni")
  ^--------------------------------------
See //BUILD.gn:21:1: whence it was imported.
import("//remoting/remoting_enable.gni")
^--------------------------------------
```

Classification: **B GN args**.

Args parsing status: **reached iOS SDK arg evaluation, but failed before Ninja file generation because `use_system_xcode` evaluated as a string instead of a boolean in the current GN arg/environment setup.**

## Stop point

Per Stage 3.2 instructions, no Chromium source was modified after classification, no ARM patching was started, and `base` was not compiled.
