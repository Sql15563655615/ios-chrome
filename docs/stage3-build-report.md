# Stage 3 Chromium72 Source Integration Build Report

Stage 3 attempted source integration and the first base-only build validation. The goal was to verify the toolchain path without building Chrome, Blink, Content, or CEF Lite.

## Source checkout

| Step | Result | Notes |
| --- | --- | --- |
| `scripts/fetch_chromium72.sh --execute` | FAILED initially | `fetch chromium` first refused to run while `.gclient` already existed. The script was updated to move pre-existing `.gclient` during first fetch and to use `--no-history`. |
| Chromium source checkout | PARTIAL SUCCESS | The repository was checked out to Chromium `72.0.3626.122` at commit `029c7e1925ccccf13fcec39dd99d49946835ec28`. |
| `gclient sync --with_branch_heads --with_tags --nohooks --no-history` | SUCCESS WITH CUSTOM DEPS | `src/third_party/devtools-node-modules` and `src/third_party/ffmpeg` failed from historical dependency URLs and were excluded via `.gclient` `custom_deps` because they are not needed for the base-only validation. |
| `gclient runhooks` | FAILED | Host `python` is Python 3.14. Chromium 72 hooks include Python 2 syntax, so hooks failed in `src/build/get_landmines.py` and `src/build/download_nacl_toolchains.py`. |

## Version record

```text
Chromium version: 72.0.3626.122
Chromium commit: 029c7e1925ccccf13fcec39dd99d49946835ec28
V8 version: 7.2.502.28
```

The same information is recorded in `chromium_version.txt`.

## GN generation

Command attempted from `chromium/src`:

```bash
PATH=/workspace/depot_tools:$PATH gn gen out/ios9_armv7
```

Result: **FAILED**.

Error:

```text
gn.py: Could not find gn executable at: ['/workspace/ios-chrome/chromium/src/buildtools/linux64/gn/gn', '/workspace/ios-chrome/chromium/src/buildtools/linux64/gn']
Either GN isn't installed on your system, or you're not running in a checkout with a preinstalled gn binary.
```

Classification: **B. SDK/dependency/tool download missing** plus **A. GN environment error**.

Reason: `gclient runhooks` could not complete under Python 3.14, and direct `download_from_google_storage.py --bucket chromium-gn -s chromium/src/buildtools/linux64/gn.sha1` did not finish in this environment before interruption. Therefore the Chromium 72-pinned GN binary was not installed.

## Base compile

Command not attempted:

```bash
ninja -C chromium/src/out/ios9_armv7 base
```

Result: **NOT RUN**.

Reason: `gn gen` did not produce a Ninja build directory. Per Stage 3 instructions, the build stopped after recording the generation failure rather than modifying large amounts of Chromium source.

## Error classification

| Class | Status | Evidence |
| --- | --- | --- |
| A. GN parameter error | NOT REACHED | GN did not reach args parsing because the GN executable was missing. |
| B. SDK/dependency missing | HIT | GN binary and some historical deps/hooks were unavailable without Python 2-compatible hooks and successful storage downloads. |
| C. ARMv7 toolchain error | NOT REACHED | Toolchain generation did not start. |
| D. C++ compatibility error | NOT REACHED | No compile action was started. |

## Next action

Install or provide a Chromium 72-compatible Python 2.7 runtime and complete `gclient runhooks`, or manually install the GN binary matching `buildtools/linux64/gn.sha1`. After that, re-run only:

```bash
cd chromium/src
PATH=/workspace/depot_tools:$PATH gn gen out/ios9_armv7
ninja -C out/ios9_armv7 base
```
