#include "cef_request_context.h"

#include <memory>
#include <utility>

namespace cef_lite {
namespace {

class RequestContextImpl final : public RequestContext {
 public:
  explicit RequestContextImpl(RequestContextSettings settings)
      : settings_(std::move(settings)) {}

  const RequestContextSettings& GetSettings() const override { return settings_; }
  void ClearHttpCache() override {}

 private:
  RequestContextSettings settings_;
};

}  // namespace

std::shared_ptr<RequestContext> CreateRequestContext(
    const RequestContextSettings& settings) {
  return std::make_shared<RequestContextImpl>(settings);
}

}  // namespace cef_lite
