# Stage 3.1 Buildtools Recovery Report

Stage 3.1 recovered the missing GN tool needed before `gn gen` for the Chromium 72 iOS 9 ARMv7 feasibility checkout. No Chromium source files were edited; only the ignored local `chromium/src/buildtools/` tool area was populated and this report was added to the repository.

## Initial state

The repository checkout did not contain `chromium/src/` at the start of this stage, so `chromium/src/buildtools/` was absent. This matched the Stage 3 failure mode where `gn.py` could not find `buildtools/linux64/gn/gn`.

| Tool | Local Chromium buildtools status after recovery | Notes |
| --- | --- | --- |
| `gn` | Present at `chromium/src/buildtools/linux64/gn/gn` | Restored from the Chromium 72 buildtools pinned SHA-1. |
| `clang` | Not present in `chromium/src/buildtools/` | No Chromium checkout hooks were run in this stage; host `clang` exists but is not a Chromium 72 pinned toolchain. |
| `ninja` | Not present in `chromium/src/buildtools/` | Host `/usr/bin/ninja` version `1.11.1` is available. |

## Root cause

Stage 3 stopped before GN generation because Chromium 72's pinned GN binary had not been downloaded into `chromium/src/buildtools/linux64/gn/gn`. The earlier `gclient runhooks` path was blocked by Python 2-era Chromium 72 hook scripts running under the host Python 3.14 environment, so the normal buildtools population step did not complete.

## Recovery method

The preferred Chromium 72 pinned revision was used. The pinned Linux GN SHA-1 for the Chromium 3620/72-era buildtools branch is:

```text
3523d50538357829725d4ed74b777a572ce0ac74
```

That object was downloaded directly from the `chromium-gn` Google Storage bucket into:

```text
chromium/src/buildtools/linux64/gn/gn
```

The matching SHA-1 marker was written to:

```text
chromium/src/buildtools/linux64/gn.sha1
```

The fallback to a current system GN was not needed.

## GN version

Command:

```bash
chromium/src/buildtools/linux64/gn/gn --version
```

Output:

```text
1496 (0790d304)
```

## Chromium 72 compatibility

This GN is considered compatible with Chromium 72 because it was restored from the Chromium 72-era pinned `buildtools/linux64/gn.sha1` object rather than from a modern host GN package. It is therefore the correct GN generation binary to use before testing Chromium 72 GN args.

## Verification

### `gn --version`

Result: **PASS**.

```text
1496 (0790d304)
```

### `gn gen out/ios9_armv7`

Command run from `chromium/src`:

```bash
buildtools/linux64/gn/gn gen out/ios9_armv7
```

Result: **BLOCKED BY MISSING SOURCE CHECKOUT, NOT BY GN**.

Output:

```text
ERROR Can't find source root.
I could not find a ".gn" file in the current directory or any parent,
and the --root command-line argument was not specified.
```

Interpretation: the restored GN executable starts successfully, but the repository currently lacks the Chromium source root files such as `chromium/src/.gn`. A full `gn gen out/ios9_armv7` validation requires the Chromium 72 source checkout to be present. Per the Stage 3.1 constraint, no Chromium source files were modified or synthesized to bypass this.

## Next action

Restore or re-sync the Chromium 72 source checkout at `chromium/src` without changing Chromium source contents, then rerun:

```bash
cd chromium/src
buildtools/linux64/gn/gn --version
buildtools/linux64/gn/gn gen out/ios9_armv7
```
