#include "include/audio_lib/audio_lib_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "audio_lib_plugin.h"

void AudioLibPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  audio_lib::AudioLibPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
