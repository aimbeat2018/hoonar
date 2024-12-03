import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:custom_social_share/custom_social_share.dart';

// import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/profile_screen.dart';
import 'package:hoonar/screens/reels/video_comment_screen.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../constants/common_widgets.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../model/success_models/home_post_success_model.dart';
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

  // late FijkPlayer _fijkPlayer;
  late Chewie _chewie;
  bool _isPaused = false;
  bool isFollow = false, isFollowLoading = false;
  List<bool> isDismissed = [false, false];
  final GlobalKey<VideoCommentScreenState> _bottomSheetKey = GlobalKey();

  SessionManager sessionManager = SessionManager();

  int modelLikeStatus = 0;
  PostsListData? model;

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
              widget.model.videoLikesOrNot = 1;
            });
          } else {
            setState(() {
              isDismissed[1] = true;
              widget.model.videoLikesOrNot = 1;
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

  Future<void> addVote(BuildContext context, int postId) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
          postId: postId,
          userId: int.parse(sessionManager.getString(SessionManager.userId)!));

      await homeProvider.addVote(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.likeUnlikeVideoModel?.status == '200') {
          setState(() {
            widget.model.hasVoted = 1;
          });
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

  void _onTap() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
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
        backgroundColor: Colors.black,
        body: Stack(
          // fit: StackFit.expand,
          children: [
            InkWell(
              onTap: _onTap,
              child: VisibilityDetector(
                onVisibilityChanged: (VisibilityInfo info) {
                  var visiblePercentage = info.visibleFraction * 100;
                  if (visiblePercentage > 50) {
                    _videoPlayerController.play();
                  } else {
                    _videoPlayerController.pause();
                  }
                },
                key: Key('ke1' + widget.model.postId!.toString()),
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: (_videoPlayerController.value.size.width ?? 0) <
                            (_videoPlayerController.value.size.height ?? 0)
                        ? BoxFit.cover
                        : BoxFit.fitWidth,
                    child: SizedBox(
                      width: _videoPlayerController.value.size.width ?? 0,
                      height: _videoPlayerController.value.size.height ?? 0,
                      child: _videoPlayerController != null
                          ? VideoPlayer(_videoPlayerController)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10),
                                Text('Loading...')
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),

            /*_chewieController != null &&
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
                        height: MediaQuery.of(context).size.height /
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
                  ),*/
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
                                                                        .white)
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
                                                                : Colors.white)),
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
                                                                          .white)
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
                            if (widget.model.canVote == 1)
                              Column(
                                children: [
                                  SwipeTo(
                                    onRightSwipe: (details) {
                                      if (widget.model.hasVoted == 0) {
                                        addVote(context, widget.model.postId!);
                                      }
                                    },
                                    iconSize: 5,
                                    iconOnRightSwipe:
                                        CupertinoIcons.arrow_2_circlepath,
                                    onLeftSwipe: (details) {
                                      if (widget.model.hasVoted == 0) {
                                        addVote(context, widget.model.postId!);
                                      }
                                    },
                                    iconOnLeftSwipe:
                                        CupertinoIcons.arrow_2_circlepath,
                                    child: Image.asset(
                                        widget.model.hasVoted == 0
                                            ? 'assets/images/vote_not_given.png'
                                            : 'assets/images/vote_given.png',
                                        width: 33,
                                        height: 33),
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
                                _openCommentBottomSheet(context,
                                    myLoading.isDark, widget.model.postId!);
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
                            InkWell(
                              onTap: () {
                                CustomSocialShare()
                                    .toAll(widget.model.postVideo ?? '');
                              },
                              child: Column(
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
                                  const SizedBox(
                                    height: 65,
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
              ),
            ),
          ],
        ),
      );
    });
  }

  void _openCommentBottomSheet(
      BuildContext context, bool isDarkMode, int postId) {
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
                postId: postId,
              ),
            ));
      },
    );
  }
}
