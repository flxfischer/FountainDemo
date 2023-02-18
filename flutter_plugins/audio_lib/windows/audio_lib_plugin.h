#ifndef FLUTTER_PLUGIN_AUDIO_LIB_PLUGIN_H_
#define FLUTTER_PLUGIN_AUDIO_LIB_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace audio_lib {

class AudioLibPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  AudioLibPlugin();

  virtual ~AudioLibPlugin();

  // Disallow copy and assign.
  AudioLibPlugin(const AudioLibPlugin&) = delete;
  AudioLibPlugin& operator=(const AudioLibPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace audio_lib

#endif  // FLUTTER_PLUGIN_AUDIO_LIB_PLUGIN_H_
