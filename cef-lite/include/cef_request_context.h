#ifndef CEF_LITE_INCLUDE_CEF_REQUEST_CONTEXT_H_
#define CEF_LITE_INCLUDE_CEF_REQUEST_CONTEXT_H_

#include <memory>
#include <string>

namespace cef_lite {

struct RequestContextSettings {
  std::string cache_path;
  bool persist_session_cookies = false;
  bool accept_language_list_is_default = true;
};

class RequestContext {
 public:
  virtual ~RequestContext() = default;

  virtual const RequestContextSettings& GetSettings() const = 0;
  virtual void ClearHttpCache() = 0;
};

std::shared_ptr<RequestContext> CreateRequestContext(
    const RequestContextSettings& settings);

}  // namespace cef_lite

#endif  // CEF_LITE_INCLUDE_CEF_REQUEST_CONTEXT_H_
