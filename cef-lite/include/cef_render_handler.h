#ifndef CEF_LITE_INCLUDE_CEF_RENDER_HANDLER_H_
#define CEF_LITE_INCLUDE_CEF_RENDER_HANDLER_H_

#include <cstdint>

namespace cef_lite {

struct Rect {
  int x = 0;
  int y = 0;
  int width = 0;
  int height = 0;
};

class RenderHandler {
 public:
  virtual ~RenderHandler() = default;

  virtual void GetViewRect(Rect* rect) = 0;
  virtual void OnPaint(const void* pixels,
                       int width,
                       int height,
                       int stride) = 0;
  virtual void OnCursorChanged(int cursor_type) {}
};

}  // namespace cef_lite

#endif  // CEF_LITE_INCLUDE_CEF_RENDER_HANDLER_H_
