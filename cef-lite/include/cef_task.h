#ifndef CEF_LITE_INCLUDE_CEF_TASK_H_
#define CEF_LITE_INCLUDE_CEF_TASK_H_

#include <functional>

namespace cef_lite {

using CefTask = std::function<void()>;

bool CefPostTask(CefTask task);
void CefDoMessageLoopWork();

}  // namespace cef_lite

#endif  // CEF_LITE_INCLUDE_CEF_TASK_H_
