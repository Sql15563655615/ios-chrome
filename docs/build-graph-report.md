# Stage 4.5 BUILD Graph & Target Reachability Report

Audit scope:

- Chromium 72.0.3626.122 build graph
- `BUILD.gn`
- `.gni`
- `import()`
- `group()`
- `source_set()`
- `static_library()`
- `component()`
- `executable()`

This report summarizes the import graph and the target graph relevant to the Stage 4-pre patch series.

## Import graph

```text
//media/BUILD.gn
  ├─ import("//build/config/arm.gni")
  ├─ import("//media/media_options.gni")
  └─ import("//third_party/ffmpeg/ffmpeg_options.gni") [guarded by media_use_ffmpeg]

//media/cast/BUILD.gn
  ├─ import("//media/media_options.gni")
  └─ static_library("test_support")

//content/gpu/BUILD.gn
  ├─ import("//media/media_options.gni")
  └─ group("gpu")

//content/public/common/BUILD.gn
  ├─ import("//media/media_options.gni")
  ├─ source_set("static_switches")
  ├─ source_set("common_sources")
  └─ group("common")

//v8/BUILD.gn
  ├─ import("//build/config/arm.gni")
  ├─ import("gni/v8.gni")
  ├─ source_set("v8_maybe_snapshot")
  └─ group("gn_all")

//v8/gni/v8.gni
  └─ imported by //v8/BUILD.gn and V8 config consumers

//build/config/BUILD.gn
  ├─ import("//build/config/ios/ios_sdk_overrides.gni")
  └─ group("common_deps")

//build/config/ios/ios_sdk.gni
  └─ imported by iOS build configuration layers

//third_party/blink/renderer/platform/BUILD.gn
  ├─ action("runtime_enabled_features")
  ├─ group("make_platform_generated")
  ├─ source_set("platform_export")
  └─ group("blink_platform_public_deps")
```

## Build graph notes

- `media/media_options.gni` is the central fan-in for media and content build decisions.
- `build/config/arm.gni` is imported by both media and V8 build definitions, so ARM changes propagate to multiple major targets.
- `content/public/common/BUILD.gn` splits the public switch surface into `static_switches`, `static_features`, and `common_sources`, which makes `content_switches.cc/.h` reachable in both static and component configurations.
- `third_party/blink/renderer/platform/BUILD.gn` generates `runtime_enabled_features.*` from `runtime_enabled_features.json5`, so a JSON5 edit is build-reachable through code generation rather than being a stray data file.

## Target graph summary

```text
Patch inputs
  ↓
BUILD.gn / .gni / generated-feature inputs
  ↓
Target families
  ↓
Runtime or compile-time consumers
```

### Example target families

- `//media:media`
- `//media/cast:test_support`
- `//content/gpu:gpu`
- `//gpu/skia_bindings:skia_bindings`
- `//content/public/common:static_switches`
- `//content/public/common:common_sources`
- `//third_party/blink/renderer/platform:runtime_enabled_features`
- `//v8:gn_all` and V8 build consumers

## Build drift summary

- No isolated `BUILD.gn` introduced by the Stage 4-pre patch set.
- No isolated `.gni` introduced by the Stage 4-pre patch set.
- No isolated target was found for the audited patch set.
- The audited build graph remains connected through import edges into known Chromium 72 target families.
