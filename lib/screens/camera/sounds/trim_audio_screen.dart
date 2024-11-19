import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../model/success_models/sound_list_model.dart';

class TrimAudioScreen extends StatefulWidget {
  final String audioFilePath;
  final int selectedDuration;
  final SoundList model;

  const TrimAudioScreen(
      {Key? key,
      required this.audioFilePath,
      required this.selectedDuration,
      required this.model})
      : super(key: key);

  @override
  _TrimAudioScreenState createState() => _TrimAudioScreenState();
}

class _TrimAudioScreenState extends State<TrimAudioScreen> {
  final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0; // Set the end value to 15 seconds
  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  void _loadAudio() async {
    setState(() {
      isLoading = true;
    });
    await _trimmer.loadAudio(audioFile: File(widget.audioFilePath));
    setState(() {
      isLoading = false;
    });

    _playAudio();
  }

  _saveAudio() {
    setState(() {
      _progressVisibility = true;
    });
    _trimmer.saveTrimmedAudio(
      startValue: _startValue,
      endValue: _endValue,
      audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });
        Navigator.pop(context, outputPath);
        // debugPrint('OUTPUT PATH: $outputPath');
      },
    );
  }

  void _playAudio() async {
    bool playbackState = await _trimmer.audioPlaybackControl(
      startValue: _startValue,
      endValue: _endValue,
    );
    setState(() => _isPlaying = playbackState);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Consumer<MyLoading>(builder: (context, myLoading, child) {
          return WillPopScope(
            onWillPop: () async {
              if (Navigator.of(context).userGestureInProgress) {
                return false;
              } else {
                return true;
              }
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: myLoading.isDark ? Colors.black : Colors.white,
                  // Adjust as per your theme
                  border: Border(
                    top: BorderSide(
                        color: myLoading.isDark ? Colors.white : Colors.black,
                        width: 1.5), // Top border
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.model.soundImage ?? '',
                                      // Replace with your image URL
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.model.soundTitle ?? '',
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        widget.model.singer ?? '',
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: myLoading.isDark
                                              ? Colors.white70
                                              : Colors.black26,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TrimViewer(
                                    trimmer: _trimmer,
                                    viewerHeight: 70,
                                    viewerWidth:
                                        MediaQuery.of(context).size.width,
                                    maxAudioLength: Duration(
                                        seconds: widget.selectedDuration),
                                    durationStyle: DurationStyle.FORMAT_MM_SS,
                                    backgroundColor: Colors.transparent,
                                    barColor: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    // durationTextStyle:
                                    //     const TextStyle(color: Colors.teal),
                                    allowAudioSelection: true,
                                    editorProperties: TrimEditorProperties(
                                      circleSize: 10,
                                      borderPaintColor: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      borderWidth: 2,
                                      borderRadius: 5,
                                      circlePaintColor: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    areaProperties: TrimAreaProperties.edgeBlur(
                                        blurEdges: true),
                                    onChangeStart: (value) {
                                      setState(() => _startValue = value);
                                      _playAudio(); // Restart playback on change
                                    },
                                    onChangeEnd: (value) {
                                      setState(() => _endValue = value);
                                      _playAudio(); // Restart playback on change
                                    },
                                    onChangePlaybackState: (value) {
                                      if (mounted) {
                                        setState(() => _isPlaying = value);
                                      }
                                    },
                                  )),
                            ),
                            Visibility(
                              visible: _progressVisibility,
                              child: LinearProgressIndicator(
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                              ),
                            ),
                            InkWell(
                              onTap: _progressVisibility
                                  ? null
                                  : () => _saveAudio(),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                margin: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 30, right: 30),
                                decoration: ShapeDecoration(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.done,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: myLoading.isDark
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
          );
        }),
      ],
    );
  }
}
