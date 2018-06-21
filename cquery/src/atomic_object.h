#pragma once

#include <algorithm>
#include <condition_variable>
#include <memory>
#include <mutex>

// A object which can be stored and taken from atomically.
template <class T>
struct AtomicObject {
  void Set(std::unique_ptr<T> t) {
    std::lock_guard<std::mutex> lock(mutex_);
    value_ = std::move(t);
    cv_.notify_one();
  }

  void SetIfEmpty(std::unique_ptr<T> t) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (value_)
      return;

    value_ = std::move(t);
    cv_.notify_one();
  }

  std::unique_ptr<T> Take() {
    std::unique_lock<std::mutex> lock(mutex_);
    while (!value_) {
      // release lock as long as the wait and reaquire it afterwards.
      cv_.wait(lock);
    }

    return std::move(value_);
  }

  template <typename TAction>
  void WithLock(TAction action) {
    std::unique_lock<std::mutex> lock(mutex_);
    bool had_value = !!value_;
    action(value_);
    bool has_value = !!value_;

    if (had_value != has_value)
      cv_.notify_one();
  }

 private:
  std::unique_ptr<T> value_;
  mutable std::mutex mutex_;
  std::condition_variable cv_;
};