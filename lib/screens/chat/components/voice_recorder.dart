import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:file/local.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tinh/screens/chat/components/voice_chat_widget.dart';

class ChatAudioRecorderWidget extends StatefulWidget {
  final Function(File file) sendVoidCallBack;

  ChatAudioRecorderWidget({required this.sendVoidCallBack});

  @override
  _ChatAudioRecorderWidgetState createState() => _ChatAudioRecorderWidgetState();
}

class _ChatAudioRecorderWidgetState extends State<ChatAudioRecorderWidget> {
  final LocalFileSystem localFileSystem = LocalFileSystem();

  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Stopped;

  String customPath = '';
  Directory? appDocDirectory;

  AudioPlayer audioPlayer = AudioPlayer();

  ChatAudioPlayerState _playerState = ChatAudioPlayerState.stopped;
  get _isPlaying => _playerState == ChatAudioPlayerState.playing;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _playerState = ChatAudioPlayerState.stopped;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            _printDuration(_current != null && _current!.duration != null ? _current!.duration! : Duration.zero),
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStatus == RecordingStatus.Stopped) {
                        setState(() {
                          _currentStatus = RecordingStatus.Recording;
                        });
                        _start();
                      } else {
                        setState(() {
                          _currentStatus = RecordingStatus.Stopped;
                        });
                        _stop();
                      }
                    },
                    child: Icon(
                      _currentStatus == RecordingStatus.Stopped ? Icons.record_voice_over : Icons.stop,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: ElevatedButton(
                    onPressed: (_currentStatus == RecordingStatus.Stopped && _current != null && _current!.duration! > Duration.zero)
                        ? () {
                            if (!_isPlaying) {
                              onPlayAudio();
                            } else {
                              onPauseAudio();
                            }
                          }
                        : null,
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_circle_filled,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: ElevatedButton(
                    onPressed: (_currentStatus == RecordingStatus.Stopped && _current != null && _current!.duration! > Duration.zero)
                        ? () {
                            setState(() {
                              _stop();
                              widget.sendVoidCallBack(File(_current!.path!));
                              _recorder = null;
                              _current = null;
                            });
                          }
                        : null,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder2.hasPermissions ?? false) {
        customPath = '/voice_record_';
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        customPath = appDocDirectory!.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();

        _recorder = FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);

        await _recorder!.initialized;
      }
    } catch (e) {
      print(e);
    }
  }

  void _start() async {
    try {
      _init().then((res) async {
        await _recorder!.start();
        Recording? recording = await _recorder!.current(channel: 0);
        setState(() {
          _current = recording;
        });

        const tick = const Duration(milliseconds: 50);
        new Timer.periodic(tick, (Timer t) async {
          if (_currentStatus == RecordingStatus.Stopped) {
            t.cancel();
          }
          Recording? current = await _recorder!.current(channel: 0);
          setState(() {
            _current = current;
            _currentStatus = _current!.status!;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    if (_recorder != null) {
      Recording? result = await _recorder!.stop();
      print("Stop recording: ${result!.path}");
      print("Stop recording: ${result.duration}");
      File file = localFileSystem.file(result.path);
      print("File length: ${await file.length()}");
      setState(() {
        _current = result;
        _currentStatus = _current!.status!;
      });
    }
  }

  String _printDuration(Duration? duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration != null ? duration.inMinutes.remainder(60) : 0);
    String twoDigitSeconds = twoDigits(duration != null ? duration.inSeconds.remainder(60) : 0);
    return duration != null ? "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds" : "";
  }

  void onPlayAudio() async {
    final result = await audioPlayer.play(_current!.path!, isLocal: true);
    if (result == 1) setState(() => _playerState = ChatAudioPlayerState.playing);
  }

  void onPauseAudio() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => _playerState = ChatAudioPlayerState.paused);
  }
}
