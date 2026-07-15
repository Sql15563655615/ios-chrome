# CEF Lite

CEF Lite is the planned minimal Chromium embedding layer for this repository. It is intentionally not a copy of full CEF.

## Initial API surface

The public C++ headers live in `cef-lite/include/` and expose only the first-stage embedding operations:

- `createBrowser()`
- `loadURL()`
- `executeJavaScript()`
- `closeBrowser()`

## Headers

- `cef_app.h` defines process-wide initialization settings.
- `cef_browser.h` defines the minimal browser object and compatibility factory.
- `cef_browser_host.h` defines the host-facing control surface closer to Chromium 72 `content::WebContents` embedding needs.
- `cef_client.h` defines lifecycle/load callbacks.
- `cef_render_handler.h` defines view geometry and software paint callbacks needed by the UIKit shell.
- `cef_request_context.h` defines a minimal profile/cache context for networking state.

## Excluded areas

- extensions
- printing
- media-heavy browser services
- downloads
- plugin hosting
