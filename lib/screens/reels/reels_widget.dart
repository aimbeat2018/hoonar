import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/profile_screen.dart';
import 'package:hoonar/screens/reels/video_comment_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../constants/common_widgets.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../../model/success_models/post_list_success_model.dart';
import '../../providers/home_provider.dart';
import '../../providers/user_provider.dart';
import '../auth_screen/login_screen.dart';

class ReelsWidget extends StatefulWidget {
  final PostsListData model;

  const ReelsWidget({super.key, required this.model});

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPaused = false;
  bool isFollow = false, isFollowLoading = false;
  List<bool> isDismissed = [false, false];
  final GlobalKey<VideoCommentScreenState> _bottomSheetKey = GlobalKey();

  SessionManager sessionManager = SessionManager();

  int modelLikeStatus = 0;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    sessionManager.initPref();
    setState(() {
      if (widget.model.videoLikesOrNot == 0) {
        isDismissed[1] = false;
      } else {
        isDismissed[1] = true;
      }
    });
  }

  Future<void> likeUnlikeVideo(BuildContext context, int postId) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(postId: postId);

      await homeProvider.likeUnlikeVideo(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.likeUnlikeVideoModel?.status == '200') {
          if (homeProvider.likeUnlikeVideoModel?.message ==
              'Post Unlike Successful') {
            setState(() {
              isDismissed[1] = false;
            });
          } else {
            setState(() {
              isDismissed[1] = true;
            });
          }
        } else if (homeProvider.likeUnlikeVideoModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.likeUnlikeVideoModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.model.postVideo ?? ''));
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  Future<void> followUnFollowUser(BuildContext context) async {
    ListCommonRequestModel requestModel = ListCommonRequestModel(
      toUserId: widget.model.userId,
    );

    isFollowLoading = true;
    final authProvider = Provider.of<UserProvider>(context, listen: false);

    await authProvider.followUnfollowUser(requestModel);

    if (authProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
    }

    isFollowLoading = false;
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
    final userProvider = Provider.of<UserProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      String initials =
          widget.model.fullName != null || widget.model.fullName != ""
              ? widget.model.fullName!
                  .trim()
                  .split(' ')
                  .map((e) => e[0])
                  .take(2)
                  .join()
                  .toUpperCase()
              : '';

      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      page: ProfileScreen(
                                    from: 'profile',
                                    userId: widget.model.userId.toString(),
                                  )),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: myLoading.isDark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade200,
                                    child: ClipOval(
                                      child: widget.model.userProfile != ""
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  widget.model.userProfile!,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  buildInitialsAvatar(initials,
                                                      fontSize: 14),
                                              fit: BoxFit.cover,
                                              width: 20,
                                              // Match the size of the CircleAvatar
                                              height: 20,
                                            )
                                          : buildInitialsAvatar(initials,
                                              fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            widget.model.userName ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: ValueListenableBuilder<int?>(
                                              valueListenable: userProvider
                                                  .followStatusNotifier,
                                              builder: (context, followStatus,
                                                  child) {
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      followUnFollowUser(
                                                          context);
                                                    });
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15),
                                                        border: Border.all(
                                                            color: widget.model.followOrNot ==
                                                                        1 ||
                                                                    followStatus ==
                                                                        1
                                                                ? (myLoading.isDark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)
                                                                : Colors
                                                                    .transparent,
                                                            width: 1),
                                                        color: widget.model
                                                                        .followOrNot ==
                                                                    1 ||
                                                                followStatus ==
                                                                    1
                                                            ? Colors.transparent
                                                            : (myLoading.isDark
                                                                ? Colors.white
                                                                : Colors.black)),
                                                    child: isFollowLoading
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                        : Text(
                                                            widget.model.followOrNot ==
                                                                        1 ||
                                                                    followStatus ==
                                                                        1
                                                                ? AppLocalizations.of(
                                                                        context)!
                                                                    .unfollow
                                                                : AppLocalizations.of(
                                                                        context)!
                                                                    .follow,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12,
                                                              color: widget.model
                                                                              .followOrNot ==
                                                                          1 ||
                                                                      followStatus ==
                                                                          1
                                                                  ? (myLoading.isDark
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)
                                                                  : (myLoading.isDark
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.model.postDescription ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              widget.model.postHashTag ?? '',
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
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, right: 8),
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
                                          width: 30,
                                          height: 30,
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
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.votes,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                !isDismissed[1]
                                    ? Dismissible(
                                        key: const Key('2'),
                                        onDismissed: (direction) {
                                          likeUnlikeVideo(
                                              context, widget.model.postId!);
                                        },
                                        child: Image.asset(
                                          'assets/images/unlike.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                      )
                                    : Dismissible(
                                        key: const Key('3'),
                                        onDismissed: (direction) {
                                          likeUnlikeVideo(
                                              context, widget.model.postId!);
                                        },
                                        child: Image.asset(
                                          'assets/images/like.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.likes,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                _openCommentBottomSheet(
                                    context, myLoading.isDark);
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/comment.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.comments,
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
                              height: 15,
                            ),
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/share.png',
                                  width: 25,
                                  height: 25,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.share,
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
    });
  }

  void _openCommentBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
              // Adjust as per your theme
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
