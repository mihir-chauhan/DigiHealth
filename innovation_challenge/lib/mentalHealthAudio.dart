import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'appPrefs.dart';
import 'mentalHealthAudioBuilder.dart';
import 'package:rxdart/rxdart.dart';

class MentalHealthAudio extends StatefulWidget {
  final AudioPlayer _player;

  const MentalHealthAudio(this._player);

  @override
  _MentalHealthAudioState createState() => _MentalHealthAudioState();
}


class _MentalHealthAudioState extends State<MentalHealthAudio> {
  final _playlist = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/innov8rz-innovation-challenge.appspot.com/o/Stress%20and%20the%20Mind%20-%20Quick%20Fix%20Relaxation%20Exercise.mp3?alt=media&token=0466efc4-94d6-40ed-99cd-8b94f156ea88"),
      tag: AudioMetadata(
        album: "Stress Relief",
        title: "Stress & Mind: Quick Relaxation",
        artwork:
        "https://firebasestorage.googleapis.com/v0/b/innov8rz-innovation-challenge.appspot.com/o/Podcast%20Icon%20(7).png?alt=media&token=81baffdc-638b-4532-bb7c-4414e4844b8f",
      ),
    )
  ]);

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("Global Data")
        .doc("Mental Health Podcasts")
        .get()
        .then((DocumentSnapshot doc) {
      Map<String, dynamic> map = doc.data();
      map.forEach((key, value) {
        setState(() {
          Map<String, dynamic> map = value;
          print(map.toString());
          _playlist.add(AudioSource.uri(
            Uri.parse(map["mp3"]),
            tag: AudioMetadata(
              album: map["album"],
              title: map["title"],
              artwork: map["image"],
            ),
          ));
        });
      });
    });

    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    widget._player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await widget._player.setAudioSource(_playlist);
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    print("aksjdfnjalfnasdnfsdajfsanldfkj");
    widget._player.pause();
    widget._player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
          widget._player.positionStream,
          widget._player.bufferedPositionStream,
          widget._player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        heroTag: "mentalHealthAudio",
        middle: Text(("Podcasts"),
            style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          child: Icon(
            Icons.circle,
            color: secondaryColor,
            size: 30,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<SequenceState>(
                  stream: widget._player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state == null) return SizedBox();
                    final metadata = state.currentSource.tag as AudioMetadata;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Center(child: Image.network(metadata.artwork)),
                          ),
                        ),
                        Text(metadata.album,
                            style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize, fontFamily: 'Nunito', color: Colors.white)),
                        Text(metadata.title,
                            style: TextStyle(fontFamily: 'Nunito', color: Colors.white)),
                      ],
                    );
                  },
                ),
              ),
              ControlButtons(widget._player),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: (newPosition) {
                      widget._player.seek(newPosition);
                    },
                  );
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  StreamBuilder<LoopMode>(
                    stream: widget._player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.white),
                        Icon(Icons.repeat_on_outlined, color: Colors.white),
                        Icon(Icons.repeat_one_on_outlined, color: Colors.white),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          widget._player.setLoopMode(cycleModes[
                              (cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Playlist",
                      style: TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize, fontFamily: 'Nunito', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: widget._player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(Icons.shuffle_on_outlined, color: Colors.white)
                            : Icon(Icons.shuffle, color: Colors.white),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await widget._player.shuffle();
                          }
                          await widget._player.setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
                ],
              ),
              Container(
                height: 240.0,
                child: StreamBuilder<SequenceState>(
                  stream: widget._player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final sequence = state?.sequence ?? [];
                    return SingleChildScrollView(
                      child: Column(
                        children: elements(sequence, state),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> elements(var sequence, var state) {
    List<Widget> list = [];
    for (var i = 0; i < sequence.length; i++) {
      list.add(Material(
        color: i == state.currentIndex ? secondaryColor : tertiaryColor,
        child: ListTile(
          title: Text(sequence[i].tag.title as String, style: TextStyle(fontFamily: 'Nunito', color: Colors.white),),
          onTap: () {
            widget._player.seek(Duration.zero, index: i);
          },
        ),
      ));
    }
    return list;
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up, color: Colors.white),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous_rounded, color: Colors.white),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow_rounded),
                iconSize: 64.0,
                color: Colors.white,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause_rounded),
                iconSize: 64.0,
                color: Colors.white,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay_rounded),
                iconSize: 64.0,
                color: Colors.white,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next_rounded, color: Colors.white),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Nunito', color: Colors.white)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    @required this.album,
    @required this.title,
    @required this.artwork,
  });
}
