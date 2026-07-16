#include "cef_browser_host.h"

#include <utility>

#include "cef_client.h"
#include "cef_render_handler.h"
#include "cef_request_context.h"

namespace cef_lite {
namespace {

class BrowserHostImpl final : public BrowserHost {
 public:
  BrowserHostImpl(Client* client,
                  RenderHandler* render_handler,
                  const BrowserHostSettings& settings)
      : browser_(createBrowser(client, render_handler, settings.browser)),
        render_handler_(render_handler),
        request_context_(settings.request_context) {}

  Browser* GetBrowser() override { return browser_.get(); }

  void CloseBrowser() override {
    if (browser_) {
      browser_->closeBrowser();
    }
  }

  void WasResized(int width, int height) override {
    view_rect_.width = width;
    view_rect_.height = height;
    if (render_handler_) {
      render_handler_->GetViewRect(&view_rect_);
    }
  }

  void SendFocusEvent(bool focused) override { focused_ = focused; }

 private:
  std::unique_ptr<Browser> browser_;
  RenderHandler* render_handler_ = nullptr;
  std::shared_ptr<RequestContext> request_context_;
  Rect view_rect_;
  bool focused_ = false;
};

}  // namespace

std::unique_ptr<BrowserHost> CreateBrowserHost(
    Client* client,
    RenderHandler* render_handler,
    const BrowserHostSettings& settings) {
  return std::make_unique<BrowserHostImpl>(client, render_handler, settings);
}

}  // namespace cef_lite
