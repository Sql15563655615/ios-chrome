#include "cef_task.h"

#include <queue>
#include <utility>

namespace cef_lite {
namespace {

std::queue<CefTask>& PendingTasks() {
  static std::queue<CefTask> tasks;
  return tasks;
}

}  // namespace

bool CefPostTask(CefTask task) {
  if (!task) {
    return false;
  }

  PendingTasks().push(std::move(task));
  return true;
}

void CefDoMessageLoopWork() {
  auto& tasks = PendingTasks();
  if (tasks.empty()) {
    return;
  }

  CefTask task = std::move(tasks.front());
  tasks.pop();
  if (task) {
    task();
  }
}

}  // namespace cef_lite
