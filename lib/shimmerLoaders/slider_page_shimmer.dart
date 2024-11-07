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

class SliderPageShimmer extends StatefulWidget {
  final bool isDarkMode;

  const SliderPageShimmer({super.key, required this.isDarkMode});

  @override
  _SliderPageShimmerState createState() => _SliderPageShimmerState();
}

class _SliderPageShimmerState extends State<SliderPageShimmer>
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

    children.addAll(List.generate(3, (index) {
      return Card(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Colors.white,
          ),
        ),
      );
    }));

    // set the active page
    double length = children.length / 2;
    activePage = children.length - length.round();
    previousPage = activePage - length.round();
    isLoading = false;
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
