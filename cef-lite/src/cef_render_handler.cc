#include "cef_render_handler.h"

namespace cef_lite {
namespace {

class NullRenderHandler final : public RenderHandler {
 public:
  void GetViewRect(Rect* rect) override {
    if (rect) {
      *rect = Rect();
    }
  }

  void OnPaint(const void*, int, int, int) override {}
};

}  // namespace

RenderHandler* GetNullRenderHandlerForTesting() {
  static NullRenderHandler handler;
  return &handler;
}

}  // namespace cef_lite
