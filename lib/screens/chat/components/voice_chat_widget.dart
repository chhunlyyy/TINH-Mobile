import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ChatAudioPlayerState { stopped, playing, paused }
enum ChatAudioPlayerRouteState { speakers, earpiece }
enum ChatAudioPlayerType { mini, slider }

class ChatAudioPlayer extends StatefulWidget {
  final String url;
  final PlayerMode mode;
  final ChatAudioPlayerType type;

  ChatAudioPlayer({Key? key, required this.url, this.mode = PlayerMode.MEDIA_PLAYER, this.type = ChatAudioPlayerType.slider}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatAudioPlayerState(url, mode);
  }
}

class _ChatAudioPlayerState extends State<ChatAudioPlayer> {
  String? url;
  PlayerMode? mode;

  late AudioPlayer _audioPlayer;
  // late PlayerState _audioPlayerState;
  Duration? _duration;
  Duration? _position;

  ChatAudioPlayerState _playerState = ChatAudioPlayerState.stopped;
  // ChatAudioPlayerRouteState _playingRouteState = ChatAudioPlayerRouteState.speakers;
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _playerCompleteSubscription;
  late StreamSubscription _playerErrorSubscription;
  late StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == ChatAudioPlayerState.playing;
  // get _isPaused => _playerState == ChatAudioPlayerState.paused;
  get _durationText => _duration.toString().split('.').first;
  get _positionText => _position.toString().split('.').first;

  // get _isPlayingThroughEarpiece => _playingRouteState == ChatAudioPlayerRouteState.earpiece;

  _ChatAudioPlayerState(this.url, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _playerCompleteSubscription.cancel();
    _playerErrorSubscription.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == ChatAudioPlayerType.mini) {
      return InkWell(
        onTap: _isPlaying ? () => _pause() : () => _play(),
        child: _isPlaying
            ? Icon(
                Icons.pause,
                key: Key('pause_button'),
              )
            : Icon(
                Icons.play_arrow,
                key: Key('play_button'),
              ),
      );
    } else {
      return Column(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _isPlaying ? () => _pause() : () => _play(),
                child: _isPlaying
                    ? Icon(
                        Icons.pause,
                        key: Key('pause_button'),
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.play_arrow,
                        key: Key('play_button'),
                        color: Colors.white,
                      ),
              ),
              Slider(
                thumbColor: Colors.white,
                activeColor: Colors.white,
                inactiveColor: Colors.orange.withOpacity(.5),
                onChanged: (v) {
                  if (_duration != null) {
                    final position = v * _duration!.inMilliseconds;
                    _audioPlayer.seek(Duration(milliseconds: position.round()));
                  }
                },
                value: (_position != null && _duration != null && _position!.inMilliseconds > 0 && _position!.inMilliseconds < _duration!.inMilliseconds)
                    ? _position!.inMilliseconds / _duration!.inMilliseconds
                    : 0.0,
                label: _position != null ? '${_positionText ?? ''} / ${_durationText ?? ''}' : (_duration != null ? _durationText : ''),
              ),
            ],
          ),
          _position != null
              ? Text(
                  _position != null
                      ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                      : _duration != null
                          ? _durationText
                          : '',
                  style: TextStyle(fontSize: 12.0, color: Colors.white),
                )
              : SizedBox.shrink()
        ],
      );
    }
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode!);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.notificationService.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.notificationService.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _position = p;
        }));

    _playerCompleteSubscription = _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = ChatAudioPlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        //  _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      // setState(() => _audioPlayerState = state);
    });

    // _playingRouteState = ChatAudioPlayerRouteState.speakers;
  }

  Future<int> _play() async {
    final playPosition = (_position != null && _duration != null && _position!.inMilliseconds > 0 && _position!.inMilliseconds < _duration!.inMilliseconds) ? _position : null;
    final result = await _audioPlayer.play(url ?? '', position: playPosition);
    if (result == 1) setState(() => _playerState = ChatAudioPlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = ChatAudioPlayerState.paused);
    return result;
  }

  // Future<int> _earpieceOrSpeakersToggle() async {
  //   final result = await _audioPlayer.earpieceOrSpeakersToggle();
  //   if (result == 1)
  //     setState(() => _playingRouteState =
  //         _playingRouteState == PlayingRouteState.speakers
  //             ? PlayingRouteState.earpiece
  //             : PlayingRouteState.speakers);
  //   return result;
  // }

  // Future<int> _stop() async {
  //   final result = await _audioPlayer.stop();
  //   if (result == 1) {
  //     setState(() {
  //       _playerState = ChatAudioPlayerState.stopped;
  //       _position = Duration();
  //     });
  //   }
  //   return result;
  // }

  void _onComplete() {
    setState(() => _playerState = ChatAudioPlayerState.stopped);
  }
}
