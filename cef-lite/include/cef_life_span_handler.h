#ifndef CEF_LITE_INCLUDE_CEF_LIFE_SPAN_HANDLER_H_
#define CEF_LITE_INCLUDE_CEF_LIFE_SPAN_HANDLER_H_

namespace cef_lite {

class Browser;

class LifeSpanHandler {
 public:
  virtual ~LifeSpanHandler() = default;

  virtual void OnAfterCreated(Browser* browser) {}
  virtual bool DoClose(Browser* browser) { return false; }
  virtual void OnBeforeClose(Browser* browser) {}
};

}  // namespace cef_lite

#endif  // CEF_LITE_INCLUDE_CEF_LIFE_SPAN_HANDLER_H_
