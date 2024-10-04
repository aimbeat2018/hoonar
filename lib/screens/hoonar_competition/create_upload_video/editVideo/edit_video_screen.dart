import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/color_constants.dart';

class EditVideoScreen extends StatefulWidget {
  const EditVideoScreen({super.key});

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset('assets/images/video1.mp4');
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    if (_chewieController != null) _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        if (_videoPlayerController.value.isPlaying) {
                          _videoPlayerController.pause();
                          setState(() {
                            _isPaused = !_isPaused;
                          });
                        } else {
                          // If the video is paused, play it.
                          _videoPlayerController.play();

                          setState(() {
                            _isPaused = !_isPaused;
                          });
                        }
                        // _videoPlayerController.pause();
                      },
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          // Set the desired width
                          height: MediaQuery.of(context).size.width /
                              _videoPlayerController.value.aspectRatio,
                          // Calculate height based on aspect ratio
                          child: Chewie(
                            controller: _chewieController!,
                          ),
                        ),
                      ),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Loading...')
                      ],
                    ),
              Positioned(
                left: 15,
                top: 5,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/back_image.png',
                    height: 28,
                    width: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 15,
                right: 15,
                top: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          margin: const EdgeInsets.only(top: 15, bottom: 5),
                          decoration: ShapeDecoration(
                            color: purpleColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.music_note,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!.addMusic,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          margin: const EdgeInsets.only(top: 15, bottom: 5),
                          decoration: ShapeDecoration(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .save
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
