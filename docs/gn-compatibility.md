# GN Compatibility for Chromium 72 iOS 9.3 ARMv7

This document tracks the Stage 2 review of `build/args/ios9_armv7.gn`. The file should only contain arguments that Chromium 72 is expected to understand, plus clearly marked values that require repository patches.

## Kept arguments

| Argument | Status | Reason |
| --- | --- | --- |
| `target_os` | supported in chromium72 | Standard Chromium cross-build selector. |
| `target_cpu` | supported in chromium72 | Standard CPU selector; `arm` is required for ARMv7. |
| `arm_version` | supported in chromium72 | Used by ARM build config to select ARM architecture level. |
| `ios_deployment_target` | supported in chromium72 | iOS toolchain/deployment setting. |
| `is_debug` | supported in chromium72 | Standard build mode selector. |
| `is_component_build` | supported in chromium72 | Standard component/static build selector. |
| `is_chrome_branded` | supported in chromium72 | Standard branding selector. |
| `symbol_level` | supported in chromium72 | Standard symbol generation control. |
| `blink_symbol_level` | supported in chromium72 | Blink symbol generation control. |
| `use_jumbo_build` | supported in chromium72 | Chromium 72 era jumbo build flag. |
| `enable_nacl` | supported in chromium72 | Disables Native Client. |
| `enable_extensions` | supported in chromium72 | Disables extension support where honored. |
| `enable_printing` | supported in chromium72 | Disables printing targets/features where honored. |
| `enable_pdf` | supported in chromium72 | Disables PDF viewer/plugin targets where honored. |
| `enable_webrtc` | supported in chromium72 | Disables WebRTC targets/features where honored. |
| `proprietary_codecs` | supported in chromium72 | Standard media codec switch. |
| `ffmpeg_branding` | supported in chromium72 | Standard FFmpeg configuration switch. |
| `v8_target_cpu` | supported in chromium72 | V8 target CPU selector. |
| `v8_enable_i18n_support` | supported in chromium72 | V8 ICU/i18n feature selector. |
| `v8_use_external_startup_data` | supported in chromium72 | V8 startup data packaging selector. |

## Removed from Stage 1 args

| Argument | Status | Reason |
| --- | --- | --- |
| `arm_use_neon` | unsupported | Not safe to assume as a top-level Chromium 72 arg for iOS; ARM tuning should be handled in ARM build config patches. |
| `arm_float_abi` | unsupported | iOS ARM ABI is toolchain-controlled; keep out of top-level args. |
| `use_goma` | unsupported | Environment-specific build acceleration, not part of the port profile. |
| `use_gio` / `use_glib` | unsupported | Linux desktop toggles, not relevant to iOS. |
| `enable_plugins` | unsupported | Chromium plugin architecture differs by target; removal should be done by dependency pruning patches. |
| `enable_remoting` | unsupported | Not a reliable Chromium 72 global arg for this target. |
| `enable_service_discovery` | unsupported | Not a required iOS ARMv7 feasibility arg. |
| `enable_background_mode` | unsupported | Chrome product feature, not a minimal content-shell/CEF Lite GN control. |
| `use_ozone` / `use_x11` / `use_aura` | unsupported | Non-iOS window-system controls; do not belong in an iOS arg file. |
| `enable_gpu` / `disable_gpu` | unsupported | GPU disabling requires content/GPU dependency patches and runtime switches, not these top-level args. |
| `use_sandbox` | unsupported | Sandbox behavior for iOS must be addressed in source patches if needed. |
| `v8_enable_pointer_compression` | unsupported | Pointer compression is not a Chromium 72/V8 7.2 ARM32 port requirement. |
| `v8_enable_31bit_smis_on_64bit_arch` | unsupported | 64-bit-only concept and irrelevant to ARMv7. |
| `v8_enable_webassembly` | unsupported | Do not assume this exact arg exists in Chromium 72; WebAssembly policy belongs in V8 patch analysis. |
| `rtc_use_h264` | unsupported | WebRTC is disabled globally for the port; per-codec RTC flags are not part of Stage 2. |
| `use_kerberos` / `use_cups` | unsupported | Non-iOS service toggles; remove from iOS profile. |

## Requires patch

The GN file intentionally points at the ARMv7/iOS feasibility patch set instead of pretending all functionality is controlled by GN. The expected patch areas are documented in `patches/build/0001-enable-armv7-ios.patch`, `docs/v8-arm32.md`, and `docs/PATCH_PLAN.md`.
