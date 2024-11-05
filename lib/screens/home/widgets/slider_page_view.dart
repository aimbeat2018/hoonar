import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/model/slider_model.dart';
import 'package:hoonar/screens/customSlider/carousel_item.dart';
import 'package:hoonar/screens/customSlider/carousel_slider.dart';
import 'package:hoonar/screens/customSlider/enums.dart';
import 'package:hoonar/screens/customSlider/models.dart';
import 'package:hoonar/screens/home/category_wise_videos_list_screen.dart';
import 'package:hoonar/screens/home/widgets/options_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../model/success_models/home_post_success_model.dart';
import '../../../providers/user_provider.dart';

class SliderPageView extends StatefulWidget {
  final List<PostsListData> sliderModelList;
  final bool isDarkMode;

  const SliderPageView(
      {super.key, required this.sliderModelList, required this.isDarkMode});

  @override
  _SliderPageViewState createState() => _SliderPageViewState();
}

class _SliderPageViewState extends State<SliderPageView>
    with SingleTickerProviderStateMixin {
  int activePage = 1;
  int previousPage = 0;
  Duration animationDuration = const Duration(milliseconds: 100);
  late AnimationController controller;
  SwiperController controllerS = SwiperController();
  List<Widget> children = [];
  bool _isPaused = false;
  bool isLoading = false;
  bool isFollow = false, isFollowLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setChildrenDataWidget();
    });

    controller = AnimationController(vsync: this, duration: animationDuration);
    controller.addListener(() {
      setState(() {});
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      }
    });
  }

  setChildrenDataWidget() async {
    setState(() {
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    for (var data in widget.sliderModelList) {
      late VideoPlayerController _videoPlayerController;
      ChewieController? _chewieController;
      // Initialize the VideoPlayerController with the video asset
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(data.postVideo!));

      // Wait for the video to initialize
      await _videoPlayerController.initialize();

      // Set the aspect ratio to fit the video player's aspect ratio
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        showControls: false,
        looping: true,
      );

      String initials = data.fullName != null || data.fullName != ""
          ? data.fullName!
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
          : '';

      children.add(Container(
        width: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35), color: Colors.white),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Display the video when it's initialized
            // _chewieController != null &&
            _chewieController.videoPlayerController.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      if (_videoPlayerController.value.isPlaying) {
                        _videoPlayerController.pause();
                        setState(() {
                          _isPaused = !_isPaused;
                        });
                      } else {
                        _videoPlayerController.play();
                        setState(() {
                          _isPaused = !_isPaused;
                        });
                      }
                    },
                    onDoubleTap: () {
                      _videoPlayerController.pause();
                      setState(() {
                        _isPaused = !_isPaused;
                      });
                      Navigator.push(
                        context,
                        SlideRightRoute(page: CategoryWiseVideosListScreen()),
                      );
                    },
                    // Use Chewie player to play the video
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: 250,
                        // Set the desired width
                        height: 250 / _videoPlayerController.value.aspectRatio,
                        // Calculate height based on aspect ratio
                        child: Chewie(
                          controller: _chewieController,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: widget.isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200,
                              child: ClipOval(
                                child: data.userProfile != ""
                                    ? CachedNetworkImage(
                                        imageUrl: data.userProfile!,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            buildInitialsAvatar(initials,
                                                fontSize: 10),
                                        fit: BoxFit.cover,
                                        width: 20,
                                        height: 20,
                                      )
                                    : buildInitialsAvatar(initials,
                                        fontSize: 10),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      data.userName ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Ensure text truncation
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: ValueListenableBuilder<int?>(
                                        valueListenable:
                                            userProvider.followStatusNotifier,
                                        builder:
                                            (context, followStatus, child) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                followUnFollowUser(
                                                    context, data.userId!);
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: data.followOrNot ==
                                                                  1 ||
                                                              followStatus == 1
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      width: 1),
                                                  color:
                                                      data.followOrNot == 1 ||
                                                              followStatus == 1
                                                          ? Colors.transparent
                                                          : Colors.white),
                                              child: isFollowLoading
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : Text(
                                                      data.followOrNot == 1 ||
                                                              followStatus == 1
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .unfollow
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .follow,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 8,
                                                        color: data.followOrNot ==
                                                                    1 ||
                                                                followStatus ==
                                                                    1
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                            ),
                                          );
                                        }),
                                  ),
                                  /*     Flexible(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Text(
                                        AppLocalizations.of(context)!.follow,
                                        style: GoogleFonts.poppins(
                                          fontSize: 8,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Ensure text truncation
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      // Wrap OptionsScreen to handle any overflow
                      child: OptionsScreen(model: data),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ));
    }

    // set the active page
    double length = children.length / 2;
    activePage = children.length - length.round();
    previousPage = activePage - length.round();
    isLoading = false;
    setState(() {});
  }

  // @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   if (_chewieController != null) _chewieController!.dispose();
  //   super.dispose();
  // }

  /* @override
  void didUpdateWidget() {
    super.didUpdateWidget(oldWidget);
    activePage = children.length - 1;
    previousPage = activePage - 1;
    setState(() {});
  }*/

  Future<void> followUnFollowUser(BuildContext context, int toUserId) async {
    ListCommonRequestModel requestModel = ListCommonRequestModel(
      toUserId: toUserId,
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return isLoading
          ? Center(
              child: SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator()))
          : SizedBox(
              height: screenHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onHorizontalDragEnd: ((details) {
                      if (details.velocity.pixelsPerSecond.dx > 0) {
                        _leftSwipe();
                      } else {
                        _rightSwipe();
                      }
                    }),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 400,
                      child: Stack(
                        children: children.isNotEmpty ? stackItems() : [],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (children.length > 1)
                    CarouselSlider(
                      position: activePage,
                      amount: children.length,
                      isDarkMode: myLoading.isDark,
                    )
                ],
              ),
            );
    });
  }

  List<Widget> stackItems() {
    List<CarouselData> beforeActive = children
        .sublist(0, activePage)
        .map((e) => CarouselData(e, PagePos.farBefore))
        .toList();
    List<CarouselData> afterActive = children
        .sublist(activePage + 1, children.length)
        .reversed
        .map((e) => CarouselData(e, PagePos.farAfter))
        .toList();

    CarouselData currentPage =
        CarouselData(children[activePage], PagePos.current);

    if (afterActive.isNotEmpty) {
      afterActive.last.setCurrent(PagePos.after);
    }

    if (beforeActive.isNotEmpty) {
      beforeActive.last.setCurrent(PagePos.before);
    }

    List<CarouselData> currentItemList = [
      ...beforeActive,
      ...afterActive,
      currentPage,
    ];

    return currentItemList.map((item) {
      return CarouselItem(
          bigItemWidth: 250,
          bigItemHeight: MediaQuery.of(context).size.height,
          smallItemWidth: 250,
          smallItemHeight: 300,
          animation: 1 - controller.value,
          forward: activePage > previousPage,
          startAnimating: controller.isAnimating,
          data: item);
    }).toList();
  }

  void _rightSwipe() {
    setState(() {
      if (activePage < children.length - 1) {
        previousPage = activePage;
        activePage += 1;
        controller.forward();
      }
    });
  }

  void _leftSwipe() {
    setState(() {
      if (activePage > 0) {
        previousPage = activePage;
        activePage -= 1;
        controller.forward();
      }
    });
  }
}
