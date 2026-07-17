# Chromium 72 GN Args Compatibility Audit

Scope: `build/args/ios9_armv7_minimal.gn` against Chromium 72 GN/build files. No GN generation or compilation was run.

## Audit table

| 参数 | 是否存在 | 来源文件 | Chromium72支持 | 需要patch |
| --- | --- | --- | --- | --- |
| `target_os` | 是 | `build/config/BUILDCONFIG.gn` | 是 | 否 |
| `target_cpu` | 是 | `build/config/BUILDCONFIG.gn` | 是 | 否 |
| `arm_version` | 是 | `build/config/arm.gni` | 是 | 否 |
| `ios_deployment_target` | 是 | `build/config/ios/ios_sdk.gni` | 是 | 否 |
| `use_system_xcode` | 是 | `build/config/ios/ios_sdk.gni` | 是 | 否 |
| `is_debug` | 是 | `build/config/BUILDCONFIG.gn` | 是 | 否 |
| `is_component_build` | 是 | `build/config/BUILDCONFIG.gn` | 是 | 否 |
| `is_chrome_branded` | 是 | `build/config/chrome_build.gni` | 是 | 否 |
| `symbol_level` | 是 | `build/config/BUILDCONFIG.gn` | 是 | 否 |
| `blink_symbol_level` | 是 | `build/config/BUILDCONFIG.gn` | 是 | 否 |
| `use_jumbo_build` | 是 | `build/config/jumbo.gni` | 是 | 否 |
| `enable_nacl` | 是 | `build/config/BUILDCONFIG.gn` | 是 | 否 |
| `enable_extensions` | 是 | `chrome/common/features.gni` | 是 | 否 |
| `enable_basic_printing` | 是 | `printing/buildflags/buildflags.gni` | 是 | 否 |
| `enable_print_preview` | 是 | `printing/buildflags/buildflags.gni` | 是 | 否 |
| `enable_pdf` | 是 | `pdf/features.gni` | 是 | 否 |
| `enable_webrtc` | 是 | `build/config/features.gni` build-flag chain | 是 | 否 |
| `proprietary_codecs` | 是 | `build/config/features.gni` | 是 | 否 |
| `ffmpeg_branding` | 是 | `media/media_options.gni` | 是 | 否 |
| `media_use_ffmpeg` | 是 | `media/media_options.gni` | 是 | 否 |
| `enable_ffmpeg_video_decoders` | 是 | `media/media_options.gni` | 是 | 否 |
| `media_use_libvpx` | 是 | `media/media_options.gni` | 是 | 否 |
| `v8_target_cpu` | 是 | `build/config/v8_target_cpu.gni` | 是 | 否 |
| `v8_enable_i18n_support` | 是 | `third_party/v8` GN config chain | 是 | 否 |
| `v8_use_external_startup_data` | 是 | `third_party/v8` GN config chain | 是 | 否 |
| `v8_enable_lite_mode` | 是 | `third_party/v8` GN config chain | 是 | 是 |
| `disable_ios_armv7_gpu_process` | 否 | 无 GN 声明；仅在本仓库补丁计划中命名 | 否 | 是 |
| `disable_ios_armv7_skia_gpu_backend` | 否 | 无 GN 声明；仅在本仓库补丁计划中命名 | 否 | 是 |
| `disable_ios_armv7_webrtc` | 否 | 无 GN 声明；仅在本仓库补丁计划中命名 | 否 | 是 |
| `ios_sdk_overlay_path` | 否 | 无 GN 声明；本仓库补丁扩展项 | 否 | 是 |
| `v8_disable_modern_sandbox_for_ios_armv7` | 否 | 无 GN 声明；本仓库补丁扩展项 | 否 | 是 |

## Notes

- `use_gpu` was **not** added to `ios9_armv7_minimal.gn` because no Chromium 72 GN `declare_args()` definition was found for it during the audit. The name only showed up in runtime/source code, not as a build arg.
- `enable_printing` was replaced by the Chromium 72 printing args `enable_basic_printing` and `enable_print_preview`; the old name is not a top-level GN arg in the audited tag.
- `v8_enable_lite_mode` is kept in the build profile because `0006-v8-arm32.patch` already rewires it into the ARMv7/iOS feasibility gate, but the first compilation step should still treat it as patch-sensitive.
- The patch-only items remain in the args profile because they are part of the planned ARMv7/iOS bring-up path, not because Chromium 72 provides them out of the box.
