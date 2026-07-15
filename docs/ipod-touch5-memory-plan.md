# iPod touch 5 Memory Plan

Target hardware: iPod touch 5 / Apple A5 / ARMv7 / 512MB RAM / iOS 9.3.5.

The practical app memory ceiling on this class of device is far below physical RAM because iOS, SpringBoard, system daemons, graphics buffers, and jetsam thresholds consume significant memory. Stage 2.5 therefore budgets for a single foreground browser with one active page.

## Initial memory budget

| Component | Target budget | Notes |
| --- | ---: | --- |
| Browser process / UIKit shell | 35-55 MB | Objective-C++ shell, navigation state, networking, cache metadata. |
| Renderer/content process | 65-95 MB | Prefer single renderer or single-process bring-up while feasibility is tested. |
| V8 heap | 24-48 MB | Must be aggressively capped; avoid multi-tab JS-heavy workloads. |
| Blink DOM/style/layout | 35-70 MB | Depends heavily on page complexity; disable nonessential features. |
| Skia/software surfaces | 24-64 MB | Keep viewport-sized buffers only; avoid GPU process and large tile caches. |
| Network/cache buffers | 8-24 MB | Prefer small in-memory cache and conservative disk cache. |
| Safety margin | 80-120 MB | Required for iOS jetsam, autorelease spikes, images, and transient parsing/layout allocations. |

## Feasibility target

A realistic first milestone is **one page, one visible viewport, no background tabs**, with total app footprint ideally below **180-220 MB** during steady-state browsing and below **260 MB** during page-load spikes.

## CEF Lite trimming strategy

- Keep only `content`, `blink`, `v8`, `net`, `cc`, `skia`, `mojo`, and `base` paths needed by an embedded browser.
- Use software compositing first; do not launch a GPU process.
- Disable WebRTC, PDF, extensions, plugins, printing, downloads, sync, remoting, and Chrome services.
- Limit browser API to `createBrowser()`, `loadURL()`, `executeJavaScript()`, and `closeBrowser()`.
- Use one request context initially; avoid per-tab profiles.
- Keep a single render handler path that paints into UIKit-managed buffers.
- Cap caches: V8 old-space, Blink memory cache, image cache, Skia glyph/resource caches, HTTP memory cache.
- Avoid background timers/services when the app is not active.

## High-risk memory areas

- V8 executable memory and heap growth under modern JavaScript pages.
- Blink image decoding and raster cache spikes.
- Skia surface duplication during rotation or viewport resize.
- Mojo/content multi-process overhead if a strict multi-process model is retained.
- Autorelease pool spikes in Objective-C++ bridge code.
