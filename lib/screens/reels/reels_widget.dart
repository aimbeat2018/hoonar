import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/model/slider_model.dart';
import 'package:hoonar/screens/home/widgets/options_screen.dart';
import 'package:video_player/video_player.dart';

class ReelsWidget extends StatefulWidget {
  final SliderModel model;

  const ReelsWidget({super.key, required this.model});

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    // _videoPlayerController =
    //     VideoPlayerController.networkUrl(Uri.parse(widget.model.video));
    _videoPlayerController = VideoPlayerController.asset(widget.model.video);
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
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
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
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading...')
                  ],
                ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20.0, // size of the avatar
                              backgroundImage: NetworkImage(
                                  'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg'), // or AssetImage('assets/avatar.png')
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    widget.model.userName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Text(
                                      follow,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              // 'assets/images/vote_not_given.png',
                              'assets/images/vote_given.png',
                              scale: 5,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              votes,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/like.png',
                              // 'assets/images/unlike.png',
                              scale: 5,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              likes,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/comment.png',
                              scale: 5,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              comments,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/share.png',
                              scale: 5,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              share,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
