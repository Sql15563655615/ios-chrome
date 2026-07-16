# Stage 4.2 Feature Removal Audit

Target device: iPod touch 5, Apple A5, ARMv7, 512MB RAM.

Scope: Linux-side Chromium 72 source scan only. GN was not run, Ninja was not run, and macOS was not used.

## Component dependency scan

| Feature | Entry `BUILD.gn` / source entry | Observed dependency chain | Closure strategy |
| --- | --- | --- | --- |
| GPU process | `chromium/src/content/gpu/BUILD.gn`; browser references in `chromium/src/content/browser/BUILD.gn` | Root `//BUILD.gn` reaches GPU tests and `content/browser` depends on `//gpu`, GLES2 client interfaces, GPU IPC, and browser GPU files. | `0003-disable-gpu.patch` introduces `disable_ios_armv7_gpu_process` and `disable_ios_armv7_skia_gpu_backend`; minimal args set both true. |
| Skia GPU backend | `chromium/src/gpu/skia_bindings/BUILD.gn` | Skia bindings depend on GLES2 implementation/interface, GPU IPC interfaces, and Skia GPU-facing bindings. | `0003-disable-gpu.patch` adds an iOS ARMv7 Skia GPU backend cut marker. |
| WebRTC | `chromium/src/media/media_options.gni`; review area `chromium/src/media/webrtc/` and `chromium/src/third_party/webrtc/` | WebRTC-related code appears under `media/webrtc`, `media/remoting`, and the large `third_party/webrtc` checkout. | Minimal args set `enable_webrtc=false`; `0004-disable-webrtc.patch` disables media remoting/RPC for iOS ARMv7. Future macOS GN may reveal additional `media/webrtc` target cuts. |
| FFmpeg | `chromium/src/media/BUILD.gn`; `chromium/src/media/cast/BUILD.gn`; `chromium/src/media/media_options.gni` | `media_options.gni` controls `media_use_ffmpeg`; `media/BUILD.gn` imports `//third_party/ffmpeg/ffmpeg_options.gni`; filters include `media/ffmpeg` headers when ffmpeg is reachable. | Keep `third_party/ffmpeg` out of `.gclient`; set `media_use_ffmpeg=false`; `0002-disable-ffmpeg.patch` guards the import and cast test-support dependency. |
| Extensions | `chromium/src/BUILD.gn`; `chromium/src/extensions/BUILD.gn` | Root `//BUILD.gn` adds extension browser/unit/shell deps behind `enable_extensions`. | Minimal args set `enable_extensions=false`; no source patch needed unless later GN exposes unconditional extension deps. |
| Printing | `chromium/src/BUILD.gn`; `chromium/src/printing/BUILD.gn` | Root `//BUILD.gn` contains printing tests and PPAPI printing examples in broad non-iOS target sets. | Minimal args set `enable_printing=false`; iOS target pruning should avoid most printing targets. |
| PDF | `chromium/src/BUILD.gn`; `chromium/src/pdf/BUILD.gn`; `chromium/src/third_party/pdfium/` | Root contains PDFium sample/test entries in broad desktop/test groups. | Minimal args set `enable_pdf=false`; no source patch until GN proves unconditional PDF deps remain. |
| Media core | `chromium/src/media/BUILD.gn`; `chromium/src/media/media_options.gni` | Media core fans out to audio, filters, formats, muxers, renderers, video, GPU, WebRTC, and optional ffmpeg/libvpx paths. | Keep core media minimal with `media_use_ffmpeg=false`, `media_use_libvpx=false`, `enable_webrtc=false`, GPU cuts, and no proprietary codecs. |

## Linux scan notes

- The requested `content/browser/gpu` focus area exists as sources under `chromium/src/content/browser/gpu/` and is listed from `chromium/src/content/browser/BUILD.gn`.
- `media/webrtc/` exists and remains a follow-up risk area because Stage 4-pre only disables high-level media remoting/RPC and args-level WebRTC.
- `third_party/ffmpeg` remains intentionally excluded; ffmpeg source references under `media/filters` must stay unreachable when `media_use_ffmpeg=false`.

## Minimal args

The companion minimal profile is:

```text
build/args/ios9_armv7_minimal.gn
```

It records which flags are Chromium72-supported and which require Stage 4-pre patches.
