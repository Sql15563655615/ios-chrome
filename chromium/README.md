# Chromium 72 Source Management

This directory is reserved for the Chromium source checkout used by the iOS 9.3 ARMv7 port.

## Version policy

- The Chromium version is fixed to the **72.0.x** release line.
- Do **not** track Chromium `main`, `master`, or `HEAD`.
- Do **not** upgrade this port to Chromium 80 or newer.
- All feasibility work must be performed against a pinned Chromium 72 tag or commit.

Recommended starting tag:

```text
72.0.3626.122
```

The exact commit should be recorded after checkout with:

```bash
git -C chromium/src rev-parse HEAD
```

## Required tooling

Use `depot_tools` and Chromium's `gclient` workflow. The repository does not vendor `depot_tools`.

Expected setup:

```bash
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git "$HOME/depot_tools"
export PATH="$HOME/depot_tools:$PATH"
```

## Checkout flow

The helper script `scripts/fetch_chromium72.sh` generates the `.gclient` file and prints the exact `fetch`, `git checkout`, and `gclient sync` sequence. It does not run network downloads unless invoked with `--execute`.

```bash
scripts/fetch_chromium72.sh
scripts/fetch_chromium72.sh --execute
```

The intended checkout root is:

```text
chromium/src/
```
