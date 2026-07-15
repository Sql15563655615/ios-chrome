#ifndef CEF_LITE_INCLUDE_CEF_APP_H_
#define CEF_LITE_INCLUDE_CEF_APP_H_

namespace cef_lite {

struct AppSettings {
  const char* cache_path = nullptr;
  bool single_process = true;
  bool disable_gpu = true;
};

class App {
 public:
  virtual ~App() = default;

  virtual bool Initialize(const AppSettings& settings) = 0;
  virtual void Shutdown() = 0;
};

}  // namespace cef_lite

#endif  // CEF_LITE_INCLUDE_CEF_APP_H_
