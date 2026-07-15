#ifndef CEF_LITE_INCLUDE_CEF_BROWSER_HOST_H_
#define CEF_LITE_INCLUDE_CEF_BROWSER_HOST_H_

#include <memory>
#include <string>

#include "cef_browser.h"

namespace cef_lite {

class Client;
class RenderHandler;
class RequestContext;

struct BrowserHostSettings {
  BrowserSettings browser;
  std::shared_ptr<RequestContext> request_context;
};

class BrowserHost {
 public:
  virtual ~BrowserHost() = default;

  virtual Browser* GetBrowser() = 0;
  virtual void CloseBrowser() = 0;
  virtual void WasResized(int width, int height) = 0;
  virtual void SendFocusEvent(bool focused) = 0;
};

std::unique_ptr<BrowserHost> CreateBrowserHost(
    Client* client,
    RenderHandler* render_handler,
    const BrowserHostSettings& settings);

}  // namespace cef_lite

#endif  // CEF_LITE_INCLUDE_CEF_BROWSER_HOST_H_
