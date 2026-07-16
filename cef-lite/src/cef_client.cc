#include "cef_client.h"

namespace cef_lite {
namespace {

class NullClient final : public Client {};

}  // namespace

Client* GetNullClientForTesting() {
  static NullClient client;
  return &client;
}

}  // namespace cef_lite
