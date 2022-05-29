
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_example/models/song.dart';

import '../constants.dart';


//@isPlaying: This allows you to toggle the Play/Pause button icon.
//@onPlayStateChanged: The widget notifies you when the user presses the Play/Pause button.
//@currentTime: By using Duration here, rather than String or Text, you don’t need to worry about setting the current time text and the Slider thumb position separately. The widget will handle both of these.
//@onSeekBarMoved: This updates you when the user chooses a new location.
//@totalTime: Like currentTime, this can also be a Duration.
class AudioWidget extends StatefulWidget {

  const AudioWidget({
    Key? key,
    // this.isPlaying = false,
    this.onPlayStateChanged,
    this.currentTime,
    this.onSeekBarMoved,
    required this.totalTime,
    required this.song,
    required this.audioPlayer,
    required this.trackSelected,
  }) : super(key: key);

  // final bool isPlaying;
  final ValueChanged<bool>? onPlayStateChanged;
  final Duration? currentTime;
  final ValueChanged<Duration>? onSeekBarMoved;
  final Duration totalTime;
  final Song song;
  final AudioPlayer audioPlayer;
  final int trackSelected;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  //Add two state variables
  late double _sliderValue;
  late bool _userIsMovingSlider;
  bool isPlaying = false;
  //Init Audio Player

  @override
  void initState() {
    //init default state
    super.initState();
    _sliderValue = _getSliderValue();
    _userIsMovingSlider = false; // flag helps to check user input
  }

  @override
  Widget build(BuildContext context) {
    if (!_userIsMovingSlider) {
      _sliderValue = _getSliderValue();
    }
    return Container(
      height: 200,
      color: BasePalette.accent,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(widget.song.trackName,
                  style: TextStyle(
                  fontSize: 16.0,
                  color: BasePalette.primary,
                  fontFamily: "NeoSansBold")
              )
          ),
          Row(
            //
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
                color: BasePalette.primary,
                iconSize: 50,
                onPressed: () {  },
              ),
              _buildPlayPauseButton(),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                color: BasePalette.primary,
                iconSize: 50,
                onPressed: () {  },
              ),
            ],
          ),
          Container(
            color: BasePalette.primary,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                //Dynamic current time
                Text(_getTimeString(_sliderValue),),
                //Make dynamic slider based on state
                Slider(
                  value: _sliderValue,
                  // The user is starting to manually move the Slider thumb.
                  onChangeStart: (value) {
                    _userIsMovingSlider = true;
                  },
                  // Whenever the Slider thumb moves, _sliderValue needs to update.
                  // This will affect the UI by updating the visual position of the thumb on the slider.
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  // When the user finishes moving the thumb, turn the flag off
                  // to start moving it based on the play position again.
                  // Then notify any listeners of the new seek position.
                  onChangeEnd: (value) {
                    _userIsMovingSlider = false;
                    if (widget.onSeekBarMoved != null) {
                      final currentTime = _getDuration(value);
                      widget.onSeekBarMoved!(currentTime);
                    }
                  },

                ),
                //Total Duration
                Text(_getTimeString(1.0)),
              ],
            ),
          )
        ]
      )
    );
  }

  // Dynamic play button method
  IconButton _buildPlayPauseButton() {
    return IconButton(
      icon:
      isPlaying
          ? const Icon(Icons.pause)
          :const Icon(Icons.play_arrow_rounded),
      color: BasePalette.primary,
      iconSize: 50,
      onPressed: () {
        setState(() {
          isPlaying = !isPlaying;
        });
        if(isPlaying) {
          play(widget.song.previewUrl);
        } else {
          pausePlayer();
        }
        // if (widget.onPlayStateChanged != null) {
        //   widget.onPlayStateChanged!(!widget.isPlaying);
        // }
      },
    );
  }

  play(url) async {
    widget.audioPlayer.setUrl(url, isLocal: false);
    // int durationMilisecond = await audioPlayer.getDuration();
    // Duration duration = Duration(milliseconds: durationMilisecond);
    // print("sukses"+duration.inSeconds.toString());
    if(widget.audioPlayer.state == AudioPlayerState.PAUSED){
      widget.audioPlayer.resume();
    } else if(widget.audioPlayer.state == AudioPlayerState.PLAYING) {
      widget.audioPlayer.release();
      int result = await widget.audioPlayer.play(url);
      if (result == 1) {
        // success
      }
    } else {
      int result = await widget.audioPlayer.play(url);
      // int a = await audioPlayer.getDuration();
      // print("onDurationChange "+a.toString());
      if (result == 1) {
        // success
        // int duration = await audioPlayer.getDuration();
        // int cur = await audioPlayer.getCurrentPosition();
        // print("sukses " + duration.toString()+ " cur: "+ cur.toString());
      }
    }

  }

  pausePlayer() async {
    int result = await widget.audioPlayer.pause();
    if(result == 1){

    }
  }
  //Getter value of current slider
  double _getSliderValue() {
    if (widget.currentTime == null) {
      return 0;
    }
    return widget.currentTime!.inMilliseconds / widget.totalTime.inMilliseconds;
  }

  //Getter value based on duration
  Duration _getDuration(double sliderValue) {
    final seconds = widget.totalTime.inSeconds * sliderValue;
    return Duration(seconds: seconds.toInt());
  }

  //Convert Duration to String Minute:Second
  String _getTimeString(double sliderValue) {
    final time = _getDuration(sliderValue);

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final minutes = twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));
    final seconds = twoDigits(time.inSeconds.remainder(Duration.secondsPerMinute));

    final hours = widget.totalTime.inHours > 0 ? '${time.inHours}:' : '';
    return "$hours$minutes:$seconds";
  }
}

