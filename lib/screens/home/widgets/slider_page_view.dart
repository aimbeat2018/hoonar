import 'package:cached_network_image/cached_network_image.dart';
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

import '../../../constants/common_widgets.dart';
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
  final Duration animationDuration = const Duration(milliseconds: 100);
  late AnimationController controller;
  bool isLoading = false;
  bool isFollowLoading = false;
  List<VideoPlayerController> videoControllers = [];
  List<ChewieController> chewieControllers = [];
  List<Widget> children = [];
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setChildrenDataWidget();
    });

    controller = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    controller.addListener(() {
      if (mounted) setState(() {});
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      }
    });
  }

  Future<void> setChildrenDataWidget() async {
    setState(() => isLoading = true);

    videoControllers.clear();
    chewieControllers.clear();
    children.clear();

    final loadedWidgets =
        await Future.wait(widget.sliderModelList.map((data) async {
      try {
        /* f inal videoController =
            VideoPlayerController.networkUrl(Uri.parse(data.postVideo!));
        await videoController.initialize();
        videoControllers.add(videoController);

        final chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: false,
          showControls: false,
          looping: false,
        );
        chewieControllers.add(chewieController);*/

        final initials = (data.fullName ?? '').trim().isNotEmpty
            ? data.fullName!
                .split(' ')
                .map((e) => e[0])
                .take(2)
                .join()
                .toUpperCase()
            : '';

        return buildVideoWidget(
            data, /* chewieController, videoController,*/ initials);
      } catch (e) {
        debugPrint('Error loading video: $e');
        return const SizedBox(); // Fallback for failed video
      }
    }));

    if (mounted) {
      setState(() {
        children = loadedWidgets;
        double length = children.length / 2;
        activePage = children.length - length.round();
        previousPage = activePage - length.round();
        isLoading = false;
      });
    }
  }

  Widget buildVideoWidget(
      PostsListData data,
      /*ChewieController chewieController,
      VideoPlayerController videoController,*/
      String initials) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                SlideRightRoute(
                  page: ReelsListScreen(
                    postList: widget.sliderModelList,
                    index: widget.sliderModelList.indexOf(data),
                  ),
                ),
              );
            },
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 250,
                height: 250,
                child: Image.network(
                  data.postImage!,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          buildVideoOverlay(data, initials),
        ],
      ),
    );
  }

  Widget buildVideoOverlay(PostsListData data, String initials) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildProfileAndFollow(data, initials),
            Flexible(child: OptionsScreen(model: data)),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Widget buildProfileAndFollow(PostsListData data, String initials) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Expanded(
      flex: 3,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: widget.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
                child: ClipOval(
                  child: data.userProfile?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: data.userProfile!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              buildInitialsAvatar(initials, fontSize: 10),
                          fit: BoxFit.cover,
                          width: 20,
                          height: 20,
                        )
                      : buildInitialsAvatar(initials, fontSize: 10),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  data.userName ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis, // Ensure text truncation
                ),
              ),
              const SizedBox(width: 5),
              buildFollowButton(data, userProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFollowButton(PostsListData data, UserProvider userProvider) {
    return Flexible(
      child: ValueListenableBuilder<int?>(
        valueListenable: userProvider.followStatusNotifier,
        builder: (context, followStatus, child) {
          final isFollowing = data.followOrNot == 1 || followStatus == 1;

          return Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isFollowing ? Colors.white : Colors.transparent,
                width: 1,
              ),
              color: isFollowing ? Colors.transparent : Colors.white,
            ),
            child: isFollowLoading
                ? const Center(child: CircularProgressIndicator())
                : Text(
                    isFollowing
                        ? AppLocalizations.of(context)!.unfollow
                        : AppLocalizations.of(context)!.follow,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: isFollowing ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          );
        },
      ),
    );
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SizedBox(
                height: 400,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx > 0) {
                      _leftSwipe();
                    } else {
                      _rightSwipe();
                    }
                  },
                  child: children.isNotEmpty
                      ? Stack(children: stackItems())
                      : const Center(child: Text('No videos available')),
                ),
              ),
              const SizedBox(height: 20),
              if (children.length > 1)
                CarouselSlider(
                  position: activePage,
                  amount: children.length,
                  isDarkMode: widget.isDarkMode,
                ),
            ],
          );
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

  void _leftSwipe() {
    if (activePage > 0) {
      setState(() {
        previousPage = activePage;
        activePage -= 1;
        controller.forward();
      });
    }
  }

  void _rightSwipe() {
    if (activePage < children.length - 1) {
      setState(() {
        previousPage = activePage;
        activePage += 1;
        controller.forward();
      });
    }
  }
}
