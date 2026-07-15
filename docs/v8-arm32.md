# V8 ARM32 Feasibility Notes for Chromium 72

Chromium 72 corresponds to the V8 7.2 release era. The exact V8 revision must be confirmed after `gclient sync` by reading `chromium/src/DEPS` and `chromium/src/v8/include/v8-version.h`.

## ARM backend

V8 in the Chromium 72 era still contains an ARM backend for 32-bit ARM. This is a prerequisite for `target_cpu = "arm"` and `v8_target_cpu = "arm"`.

Stage 2 checks after source checkout:

- Confirm `src/v8/src/arm/` exists.
- Confirm ARM builtins/codegen files are included in V8 GN targets for `v8_target_cpu = "arm"`.
- Confirm no iOS-specific build guard excludes ARM32.

## JIT dependency

V8 JavaScript execution normally depends on executable memory for JIT-generated code. On iOS, executable writable memory and JIT policy are constrained by platform entitlements and OS version.

Stage 2 conclusion:

- ARM backend existence is likely not the blocker.
- iOS 9.3 JIT policy and memory allocation paths are the high-risk area.
- Feasibility patches must inspect V8 platform allocation, code range, and simulator/device differences before attempting a full build.

## Pointer compression

Pointer compression is not a Chromium 72/V8 7.2 ARM32 feature requirement and should not be present as a required GN toggle for this port. The Stage 1 `v8_enable_pointer_compression` and `v8_enable_31bit_smis_on_64bit_arch` args were removed from the GN profile because they are unsupported/irrelevant for ARMv7 Chromium 72 feasibility.

## WebAssembly

WebAssembly may exist in V8 7.2, but Stage 2 does not assume a stable global `v8_enable_webassembly` GN flag. If disabling WebAssembly is required for memory or executable allocation reasons, it should be handled by an inspected V8 patch against the Chromium 72 source tree.

## Required follow-up once Chromium is checked out

1. Record V8 version from `v8/include/v8-version.h`.
2. Inspect `v8/BUILD.gn` and ARM source lists.
3. Inspect iOS platform memory allocation code paths.
4. Decide whether ARM32 device builds require interpreter-only mode, JIT entitlement assumptions, or a custom allocator patch.
