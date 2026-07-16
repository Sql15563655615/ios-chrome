#include "cef_browser.h"

#include <utility>

#include "cef_browser_host.h"
#include "cef_client.h"
#include "cef_render_handler.h"

namespace cef_lite {
namespace {

class BrowserImpl final : public Browser {
 public:
  BrowserImpl(Client* client,
              RenderHandler* render_handler,
              const BrowserSettings& settings)
      : client_(client), render_handler_(render_handler), settings_(settings) {}

  BrowserHost* GetHost() override { return host_; }

  void loadURL(const std::string& url) override {
    current_url_ = url;
    if (client_) {
      client_->OnLoadStarted(this, current_url_);
      client_->OnLoadFinished(this, current_url_);
    }
  }

  void executeJavaScript(const std::string& script) override {
    last_script_ = script;
  }

  void closeBrowser() override {
    if (!closed_ && client_) {
      client_->OnBrowserClosed(this);
    }
    closed_ = true;
  }

  void set_host(BrowserHost* host) { host_ = host; }
  const BrowserSettings& settings() const { return settings_; }
  RenderHandler* render_handler() const { return render_handler_; }

 private:
  Client* client_ = nullptr;
  RenderHandler* render_handler_ = nullptr;
  BrowserSettings settings_;
  BrowserHost* host_ = nullptr;
  std::string current_url_;
  std::string last_script_;
  bool closed_ = false;
};

}  // namespace

std::unique_ptr<Browser> createBrowser(Client* client,
                                       RenderHandler* render_handler,
                                       const BrowserSettings& settings) {
  auto browser = std::make_unique<BrowserImpl>(client, render_handler, settings);
  if (client) {
    client->OnBrowserCreated(browser.get());
  }
  return browser;
}

}  // namespace cef_lite
