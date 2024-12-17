import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_social_share/custom_social_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/profile_screen.dart';
import 'package:hoonar/screens/reels/more_options_list_screen.dart';
import 'package:hoonar/screens/reels/video_comment_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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
  bool isFollow = false, isFollowLoading = false;
  List<bool> isDismissed = [false, false];
  final GlobalKey<VideoCommentScreenState> _bottomSheetKey = GlobalKey();
  bool _showLikeAnimation = false, _showLottie = false;
  SessionManager sessionManager = SessionManager();
  int likeOrVote = -1;
  int modelLikeStatus = 0;
  PostsListData? model;
  late Animation<double> _fadeAnimation;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isMute = false;
  double _progress = 0.0;
  String userId = "";

  @override
  void initState() {
    super.initState();
    initializePlayer();
    sessionManager.initPref();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = sessionManager.getString(SessionManager.userId)!;
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  Future<void> updateVideoCount(BuildContext context, int postId) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(postId: postId);

      await homeProvider.updatePostViewCount(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.videoCountModel?.status == '200') {
        } else if (homeProvider.videoCountModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.videoCountModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
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
              widget.model.videoLikesOrNot = 0;
              _showLikeAnimation = false; // No animation for unlike
            });
          } else {
            setState(() {
              widget.model.videoLikesOrNot = 1;
              likeOrVote = 1;
              _showLikeAnimation = true; // Trigger animation for like
              _controller.forward().then((_) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  _controller.reverse();
                  _showLikeAnimation = false;
                });
              });
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
            likeOrVote = 0;
            _showLikeAnimation = true; // Trigger animation for like
            _controller.forward().then((_) {
              Future.delayed(const Duration(milliseconds: 300), () {
                _controller.reverse();
                _showLikeAnimation = false;
              });
            });
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
    await Future.wait([_videoPlayerController.initialize()]).then((_) {});
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

  void _hideLottieAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showLottie = false;
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _controller.dispose();

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
        /* bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom slider container
            Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2.5),
              ),
              child: Stack(
                children: [
                  // Active progress
                  FractionallySizedBox(
                    widthFactor: _videoPlayerController.value.isInitialized
                        ? _progress /
                            _videoPlayerController.value.duration.inMilliseconds
                                .toDouble()
                        : 0.0,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  // Draggable thumb
                  Positioned(
                    left: (_videoPlayerController.value.isInitialized
                            ? _progress /
                                _videoPlayerController
                                    .value.duration.inMilliseconds
                                    .toDouble()
                            : 0.0) *
                        MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        final newPosition = (details.localPosition.dx /
                                MediaQuery.of(context).size.width) *
                            _videoPlayerController
                                .value.duration.inMilliseconds;
                        _videoPlayerController.seekTo(Duration(
                            milliseconds: newPosition.toInt().clamp(
                                0,
                                _videoPlayerController
                                    .value.duration.inMilliseconds)));
                      },
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),*/
        body: Stack(
          // fit: StackFit.expand,
          children: [
            InkWell(
              onTap: _onTap,
              onDoubleTap: () {
                setState(() {
                  _showLottie = true;
                });
                likeUnlikeVideo(context, widget.model.postId!);

                _hideLottieAfterDelay();
              },
              child: VisibilityDetector(
                onVisibilityChanged: (VisibilityInfo info) {
                  var visiblePercentage = info.visibleFraction * 100;
                  if (visiblePercentage > 50) {
                    _videoPlayerController.play();

                    _videoPlayerController.setLooping(true);

                    _videoPlayerController.addListener(() {
                      setState(() {
                        _progress = _videoPlayerController
                            .value.position.inMilliseconds
                            .toDouble();
                      });
                    });

                    updateVideoCount(context, widget.model.postId!);
                  } /*else {
                    _videoPlayerController.pause();
                  }*/
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

            /*video player sound volume*/
            Positioned(
                top: 10,
                right: 15,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isMute = !isMute;
                      _videoPlayerController.setVolume(isMute ? 0.0 : 1.0);
                    });
                  },
                  child: Image.asset(
                    isMute
                        ? 'assets/images/speaker_mute.png'
                        : 'assets/images/speaker.png',
                    height: 28,
                    width: 28,
                    color: Colors.white,
                  ),
                )),

            /*Reels right side options*/
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
                                  /* SwipeTo(
                                    onRightSwipe: (details) {
                                      if (widget.model.hasVoted == 0) {
                                        addVote(context, widget.model.postId!);
                                      }
                                    },
                                    iconSize: 5,
                                    iconOnRightSwipe:
                                        CupertinoIcons.arrow_2_circlepath,
                                    onLeftSwipe: (details) {},
                                    iconOnLeftSwipe:
                                        CupertinoIcons.arrow_2_circlepath,
                                    child: Image.asset(
                                        widget.model.hasVoted == 0
                                            ? 'assets/images/vote_not_given.png'
                                            : 'assets/images/vote_given.png',
                                        width: 33,
                                        height: 33),
                                  ),*/
                                  InkWell(
                                    onTap: () {
                                      if (widget.model.hasVoted == 0) {
                                        addVote(context, widget.model.postId!);
                                      }
                                    },
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
                                InkWell(
                                  onTap: () {
                                    likeUnlikeVideo(
                                        context, widget.model.postId!);

                                    _hideLottieAfterDelay();
                                  },
                                  child: Image.asset(
                                    widget.model.videoLikesOrNot == 0
                                        ? 'assets/images/unlike.png'
                                        : 'assets/images/like.png',
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
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                _moreOptionsBottomSheet(
                                    context,
                                    myLoading.isDark,
                                    widget.model.postId!,
                                    widget.model.userId!,
                                    widget.model.followOrNot!.toString());
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.more_vert,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
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

            /*Like and vote animation*/
            if (_showLikeAnimation)
              Positioned.fill(
                child: likeOrVote == 1 && _showLottie
                    ? Opacity(
                        opacity: 0.5,
                        child: Lottie.asset(
                          'assets/lottie_json/like_anim.json',
                          /*  width: 50,
                          height: 50,*/
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: /*Icon(
                      Icons.favorite,
                      color: Colors.red.withOpacity(0.8),
                      // Slightly transparent
                      size: 100,
                    )*/
                              Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              /* likeOrVote == 1
                            ? 'assets/images/like.png'
                            :*/
                              'assets/images/vote_given.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      ),
              ),

            /*  Video player control seekbar  */
            if (_videoPlayerController.value.isInitialized)
              Positioned(
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      trackHeight: 5,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 0.0),
                    ),
                    child: Builder(builder: (context) {
                      return Slider(
                        value: _progress,
                        min: 0,
                        max: _videoPlayerController
                            .value.duration.inMilliseconds
                            .toDouble(),
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {
                            _progress = value;
                          });
                          _videoPlayerController
                              .seekTo(Duration(milliseconds: value.toInt()));
                        },
                      );
                    }),
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
              borderRadius: const BorderRadius.only(
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

  void _moreOptionsBottomSheet(BuildContext context, bool isDarkMode,
      int postId, int postUserId, String followStatus) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  child: MoreOptionsListScreen(
                    key: _bottomSheetKey,
                    postId: postId,
                    followStatus: followStatus,
                    postUserId: postUserId,
                    userId: sessionManager.getString(SessionManager.userId)!,
                  ),
                ))
          ],
        );
      },
    );
  }
}
