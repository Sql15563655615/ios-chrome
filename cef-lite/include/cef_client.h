#ifndef CEF_LITE_INCLUDE_CEF_CLIENT_H_
#define CEF_LITE_INCLUDE_CEF_CLIENT_H_

#include <string>

namespace cef_lite {

class Browser;

class Client {
 public:
  virtual ~Client() = default;

  virtual void OnBrowserCreated(Browser* browser) {}
  virtual void OnBrowserClosed(Browser* browser) {}
  virtual void OnLoadStarted(Browser* browser, const std::string& url) {}
  virtual void OnLoadFinished(Browser* browser, const std::string& url) {}
  virtual void OnLoadFailed(Browser* browser, const std::string& url, int error_code) {}
};

}  // namespace cef_lite

#endif  // CEF_LITE_INCLUDE_CEF_CLIENT_H_
