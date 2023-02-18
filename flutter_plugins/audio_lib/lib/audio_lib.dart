import 'dart:async';

import 'package:flutter/services.dart';

enum AudioState { stopped, playing, paused }

const MethodChannel channel = MethodChannel("flx.fischer/audio");

class AudioLib {
  final StreamController<AudioState> stateController =
      StreamController.broadcast();
  AudioState state = AudioState.stopped;

  AudioLib() {
    channel.setMethodCallHandler(stateChange);
  }

  Stream<AudioState> get onStateChange => stateController.stream;

  Future<void> stateChange(MethodCall call) async {
    switch (call.method) {
      case "audio.onStart":
        state = AudioState.playing;
        stateController.add(state);
        break;

      case "audio.onPause":
        state = AudioState.paused;
        stateController.add(state);
        break;

      case "audio.onComplete":
        state = AudioState.stopped;
        stateController.add(state);
        break;

      case "audio.onResume":
        state = AudioState.playing;
        stateController.add(state);
        break;

      default:
        throw ArgumentError("Unknown method called.");
    }
  }

  Future<void> play(String url) async {
    await channel.invokeMethod("play", {"url": url});
  }

  Future<void> pause() async {
    await channel.invokeMethod("pause");
  }

  Future<void> resume() async {
    await channel.invokeMethod("resume");
  }
}
