import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audio_lib/audio_lib.dart';

String url =
    "https://www.mediacollege.com/downloads/sound-effects/nature/forest/rainforest-ambient.mp3";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
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
        ));
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
