#include "cef_app.h"

namespace cef_lite {
namespace {

bool g_initialized = false;
AppSettings g_settings;

}  // namespace

bool CefInitialize(const AppSettings& settings) {
  if (g_initialized) {
    return true;
  }

  g_settings = settings;
  g_initialized = true;
  return true;
}

void CefShutdown() {
  g_settings = AppSettings();
  g_initialized = false;
}

bool CefIsInitialized() {
  return g_initialized;
}

const AppSettings& CefGetSettings() {
  return g_settings;
}

}  // namespace cef_lite
