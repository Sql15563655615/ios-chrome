#ifndef CEF_LITE_INCLUDE_CEF_BROWSER_H_
#define CEF_LITE_INCLUDE_CEF_BROWSER_H_

#include <memory>
#include <string>

namespace cef_lite {

class BrowserHost;
class Client;
class RenderHandler;
class RequestContext;

struct BrowserSettings {
  int width = 0;
  int height = 0;
  bool javascript_enabled = true;
};

class Browser {
 public:
  virtual ~Browser() = default;

  virtual BrowserHost* GetHost() = 0;
  virtual void loadURL(const std::string& url) = 0;
  virtual void executeJavaScript(const std::string& script) = 0;
  virtual void closeBrowser() = 0;
};

std::unique_ptr<Browser> createBrowser(Client* client,
                                       RenderHandler* render_handler,
                                       const BrowserSettings& settings);

}  // namespace cef_lite

#endif  // CEF_LITE_INCLUDE_CEF_BROWSER_H_
