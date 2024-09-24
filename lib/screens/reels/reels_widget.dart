import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/model/slider_model.dart';
import 'package:hoonar/screens/reels/video_comment_screen.dart';
import 'package:video_player/video_player.dart';

class ReelsWidget extends StatefulWidget {
  final SliderModel model;

  const ReelsWidget({super.key, required this.model});

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPaused = false;
  bool isFollow = false;
  List<bool> isDismissed = [false, false];
  final GlobalKey<VideoCommentScreenState> _bottomSheetKey = GlobalKey();

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
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20.0, // size of the avatar
                                backgroundImage: NetworkImage(
                                    'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg'), // or AssetImage('assets/avatar.png')
                              ),
                              const SizedBox(
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isFollow = !isFollow;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: isFollow
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                width: 1),
                                            color: isFollow
                                                ? Colors.transparent
                                                : Colors.white),
                                        child: Text(
                                          isFollow ? unfollow : follow,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: isFollow
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
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
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              isDismissed[0]
                                  ? Dismissible(
                                      key: const Key('1'),
                                      onDismissed: (direction) {
                                        setState(() {
                                          // Mark the item as dismissed
                                          isDismissed[0] = false;
                                        });
                                      },
                                      child: Image.asset(
                                        // 'assets/images/vote_not_given.png',
                                        'assets/images/vote_given.png',
                                        width: 35,
                                        height: 35,
                                      ),
                                    )
                                  : Dismissible(
                                      key: const Key('0'),
                                      onDismissed: (direction) {
                                        setState(() {
                                          // Mark the item as dismissed
                                          isDismissed[0] = true;
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/vote_not_given.png',
                                        // 'assets/images/vote_given.png',
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                votes,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              isDismissed[1]
                                  ? Dismissible(
                                      key: const Key('2'),
                                      onDismissed: (direction) {
                                        setState(() {
                                          // Mark the item as dismissed
                                          isDismissed[1] = false;
                                        });
                                      },
                                      child: Image.asset(
                                        // 'assets/images/like.png',
                                        'assets/images/unlike.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                    )
                                  : Dismissible(
                                      key: const Key('3'),
                                      onDismissed: (direction) {
                                        setState(() {
                                          // Mark the item as dismissed
                                          isDismissed[1] = true;
                                        });
                                      },
                                      child: Image.asset(
                                        'assets/images/like.png',
                                        // 'assets/images/unlike.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                likes,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              _openCommentBottomSheet(context);
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/comment.png',
                                  width: 28,
                                  height: 28,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  comments,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/share.png',
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                share,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  void _openCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.black, // Adjust as per your theme
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: VideoCommentScreen(
                key: _bottomSheetKey,
              ),
            ));
      },
    );
  }
}
