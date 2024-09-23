import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/slider_model.dart';
import 'package:hoonar/screens/customSlider/carousel_item.dart';
import 'package:hoonar/screens/customSlider/enums.dart';
import 'package:hoonar/screens/customSlider/models.dart';
import 'package:hoonar/screens/home/widgets/options_screen.dart';
import 'package:video_player/video_player.dart';

import 'constants/text_constants.dart';
import 'screens/home/widgets/reels_screen.dart';

class SliderPageView extends StatefulWidget {
  final List<SliderModel> sliderModelList;

  const SliderPageView({super.key, required this.sliderModelList});

  @override
  _SliderPageViewState createState() => _SliderPageViewState();
}

/*class _SliderPageViewState extends State<SliderPageView> {
  late PageController _pageController;
  double currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.5);
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageView with Overlap'),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 5, // Adjust the number of items
            itemBuilder: (context, index) {
              // Call the custom item builder
              return _buildPageItem(index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageItem(int index) {
    double scaleFactor = 0.9;
    double currentScale =
        (1 - (currentPageValue - index).abs()).clamp(0.8, 1.0);
    double currentTranslation = 0.0;

    if (currentPageValue - index < 0) {
      currentTranslation = 60 * (0 - currentScale);
    } else if (currentPageValue - index > 0) {
      currentTranslation = -60 * (0 - currentScale);
    }

    return Transform.translate(
      offset: Offset(currentTranslation, 0),
      child: Transform.scale(
        scale: currentScale,
        child: Card(
          elevation: 5,
          color: Colors.blueAccent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.blueAccent,
            ),
            child: Center(
              child: Text(
                'Page $index',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

class _SliderPageViewState extends State<SliderPageView>
    with SingleTickerProviderStateMixin {
  int activePage = 1;
  int previousPage = 0;
  Duration animationDuration = const Duration(milliseconds: 200);
  late AnimationController controller;
  SwiperController controllerS = SwiperController();
  List<Widget> children = [];

  // late VideoPlayerController _videoPlayerController;
  // ChewieController? _chewieController;
  bool _liked = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    // children = [
    //   Container(
    //     color: Colors.white,
    //   ),
    //   Container(
    //     color: Colors.blue,
    //   ),
    //   Container(
    //     color: Colors.white,
    //   ),
    //   /*Container(
    //   color: Colors.green,
    // ),
    // Container(
    //   color: Colors.blue,
    // ),
    // Container(
    //   color: Colors.black,
    // ),
    // Container(
    //   color: Colors.green,
    // ),*/
    // ];
    setChildrenDataWidget();

    // intitialize the animation
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
    for (var data in widget.sliderModelList) {
      late VideoPlayerController _videoPlayerController;
      ChewieController? _chewieController;
      // Initialize the VideoPlayerController with the video asset
      _videoPlayerController = VideoPlayerController.asset(data.video);

      // Wait for the video to initialize
      await _videoPlayerController.initialize();

      // Set the aspect ratio to fit the video player's aspect ratio
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        // Preserve the video aspect ratio
        autoPlay: false,
        showControls: false,
        looping: true,
      );

      // Add a container with a video player inside
      children.add(Container(
        width: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
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
                    // Use Chewie player to play the video
                    child: AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.width/MediaQuery.of(context).size.height,
                      // Ensures video fits within its container
                      child: Chewie(
                        controller: _chewieController,
                      ),
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
            // Add other content like options and avatar
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: OptionsScreen(
                      model: data,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 13.0, // size of the avatar
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
                                  data.userName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: Text(
                                    follow,
                                    style: GoogleFonts.poppins(
                                      fontSize: 8,
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ));
    }

    // set the active page
    double length = children.length / 2;
    activePage = children.length - length.round();
    previousPage = activePage - length.round();
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.6,
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
              height: 350,
              child: Stack(
                children: children.isNotEmpty ? stackItems() : [],
              ),
            ),
          ),
          /*if (children.length > 1)
            CarouselSlider(
              position: activePage,
              amount: children.length,
            )*/
        ],
      ),
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
          smallItemHeight: 280,
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
