import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:audio_lib/audio_lib.dart';

String url =
    "https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _audioLibPlugin = AudioLib();
  late StreamSubscription _stateSubscription;

  AudioState _state = AudioState.stopped;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.text = url;

    _stateSubscription = _audioLibPlugin.onStateChange.listen((event) {
      setState(() {
        _state = event;
      });
    }, onError: (msg) {
      _state = AudioState.stopped;
    });
  }

  Future<void> togglePlayPauseStop() async {
    switch (_state) {
      case AudioState.stopped:
        url = textController.text;
        await _audioLibPlugin.play(url);
        break;
      case AudioState.paused:
        await _audioLibPlugin.resume();
        break;
      case AudioState.playing:
        await _audioLibPlugin.pause();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: TextField(controller: textController))
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: togglePlayPauseStop, icon: buttonIcon(_state))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonIcon(AudioState state) {
    switch (state) {
      case AudioState.paused:
        return const Icon(Icons.play_arrow);
      case AudioState.playing:
        return const Icon(Icons.pause_circle);
      case AudioState.stopped:
        return const Icon(Icons.play_arrow);
    }
  }
}
