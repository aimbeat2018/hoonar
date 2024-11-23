import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/customSlider/carousel_item.dart';
import 'package:hoonar/screens/customSlider/carousel_slider.dart';
import 'package:hoonar/screens/customSlider/enums.dart';
import 'package:hoonar/screens/customSlider/models.dart';
import 'package:hoonar/screens/home/widgets/options_screen.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
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
  List<VideoPlayerController> videoControllers = [];
  List<ChewieController> chewieControllers = [];

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

    // for (var controller in videoControllers) {
    //   await controller.dispose();
    // }
    // for (var chewieController in chewieControllers) {
    //   chewieController.dispose();
    // }
    videoControllers.clear();
    chewieControllers.clear();
    children.clear();

    for (var data in widget.sliderModelList) {
      final _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(data.postVideo!));

      await _videoPlayerController.initialize();

      videoControllers.add(_videoPlayerController); // Track the controller

      final _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        showControls: false,
        looping: false,
      );
      chewieControllers.add(_chewieController); // Track the Chewie controller

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
            _videoPlayerController.value.isInitialized
                ? VisibilityDetector(
                    key: Key(data.postVideo!),
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (info.visibleFraction > 0.5) {
                        _videoPlayerController.play();
                        _videoPlayerController.setVolume(0.0);
                      } else {
                        _videoPlayerController.pause();
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        /*  if (_videoPlayerController.value.isPlaying) {
                          _videoPlayerController.pause();
                          setState(() {
                            _isPaused = !_isPaused;
                          });
                        } else {
                          _videoPlayerController.play();
                          setState(() {
                            _isPaused = !_isPaused;
                          });
                        }*/
                        _videoPlayerController.pause();
                        setState(() {
                          _isPaused = !_isPaused;
                        });
                        Navigator.push(
                          context,
                          SlideRightRoute(
                              page: ReelsListScreen(
                            postList: widget.sliderModelList,
                            index: widget.sliderModelList.indexOf(data),
                          )),
                        );
                      },

                      // Use Chewie player to play the video
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: 250,
                          // Set the desired width
                          height:
                              250 / _videoPlayerController.value.aspectRatio,
                          // Calculate height based on aspect ratio
                          child: Chewie(
                            controller: _chewieController,
                          ),
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
                    Expanded(
                      flex: 3,
                      child: Align(
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
                                            return Container(
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
                    ),
                    Flexible(
                      // Wrap OptionsScreen to handle any overflow
                      child: OptionsScreen(model: data),
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ));
    }

    // set the active page
    if (mounted) {
      setState(() {
        double length = children.length / 2;
        activePage = children.length - length.round();
        previousPage = activePage - length.round();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (final controller in videoControllers) {
      controller.dispose();
    }
    for (final chewieController in chewieControllers) {
      chewieController.dispose();
    }
    videoControllers.clear();
    chewieControllers.clear();
    super.dispose();
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
