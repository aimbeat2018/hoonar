import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hoonar/screens/camera/wave_slider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class TrimAudioScreen extends StatefulWidget {
  final String audioFilePath;

  // final double totalDuration;

  TrimAudioScreen({required this.audioFilePath /*, required this.totalDuration*/
      });

  @override
  _TrimAudioScreenState createState() => _TrimAudioScreenState();
}

class _TrimAudioScreenState extends State<TrimAudioScreen> {
  // late FlutterSoundPlayer _soundPlayer;
  late AudioPlayer _audioPlayer;
  late AudioWaveforms _waveformWidget;
  double _startTrim = 0.0;
  double _endTrim = 10.0; // Default end time in seconds
  double _totalDuration = 0.0; // Total audio duration
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   _totalDuration = widget.totalDuration;
    // });
    // _soundPlayer = FlutterSoundPlayer();
    _audioPlayer = AudioPlayer();
    // _waveformWidget = AudioWaveforms();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    // await _soundPlayer.openPlayer();

    // Load audio and calculate total duration
    await _audioPlayer.setSource(UrlSource(widget.audioFilePath));
    final duration = await _audioPlayer.getDuration();
    setState(() {
      _totalDuration = duration != null
          ? duration.inMilliseconds / 1000.0
          : 0.0; // Convert to seconds
      _endTrim = _totalDuration; // Set default end trim to full duration
    });

    // await _waveformWidget.loadAudio(widget.audioFilePath);
  }

  Future<void> _playSelectedAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.play(
        UrlSource(widget.audioFilePath),
        position: Duration(
            seconds: _startTrim
                .toInt()), /*duration: Duration(seconds: (_endTrim - _startTrim).toInt()*/
      );
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _trimAudio() async {
    final tempDir = await getTemporaryDirectory();
    final outputFilePath = '${tempDir.path}/trimmed_audio.mp3';

    final command =
        '-i ${widget.audioFilePath} -ss $_startTrim -to $_endTrim -c copy $outputFilePath';

    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print('Audio trimmed successfully: $outputFilePath');
      } else {
        print('Error trimming audio');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trim Audio'),
      ),
      body: Column(
        children: [
          // Waveform placeholder
          Container(
            height: 150,
            color: Colors.grey[300],
            child: Center(
                child: WaveSlider(
              backgroundColor: Colors.grey.shade300,
              heightWaveSlider: 100,
              widthWaveSlider: 300,
              duration: _totalDuration,
              callbackStart: (duration) {
                print("Start $duration");
              },
              callbackEnd: (duration) {
                print("End $duration");
              },
            )),
          ),
          const SizedBox(height: 20),

          // Start and End sliders
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text('Trim Start: ${_startTrim.toStringAsFixed(1)}s'),
                Slider(
                  min: 0,
                  max: _totalDuration,
                  value: _startTrim,
                  onChanged: (value) {
                    if (value < _endTrim) {
                      setState(() {
                        _startTrim = value;
                      });
                    }
                  },
                ),
                Text('Trim End: ${_endTrim.toStringAsFixed(1)}s'),
                Slider(
                  min: 0,
                  max: _totalDuration,
                  value: _endTrim,
                  onChanged: (value) {
                    if (value > _startTrim) {
                      setState(() {
                        _endTrim = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // Playback and Trim buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _playSelectedAudio,
                child: Text(_isPlaying ? 'Stop' : 'Play'),
              ),
              ElevatedButton(
                onPressed: _trimAudio,
                child: Text('Trim Audio'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _soundPlayer.closePlayer();
    _audioPlayer.dispose();
    super.dispose();
  }
}
