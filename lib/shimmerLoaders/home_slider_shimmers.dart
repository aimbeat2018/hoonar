import 'package:flutter/material.dart';
import 'package:hoonar/shimmerLoaders/slider_page_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart' as CS;
import '../constants/my_loading/my_loading.dart';

class HomeSliderShimmers extends StatefulWidget {
  const HomeSliderShimmers({super.key});

  @override
  State<HomeSliderShimmers> createState() => _HomeSliderShimmersState();
}

class _HomeSliderShimmersState extends State<HomeSliderShimmers> {
  final CS.CarouselSliderController _carouselController =
      CS.CarouselSliderController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Shimmer.fromColors(
        baseColor:
            myLoading.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        highlightColor:
            myLoading.isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        child: Column(
          children: [
            CS.CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Container(
                  /*margin:
                                  EdgeInsets.symmetric(horizontal: screenWidth * 0.1),*/
                  // 10% of the screen width for margin
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: _currentIndex == index
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, 1.00),
                            end: Alignment(0, -1),
                            colors: [
                              Colors.black,
                              Color(0xFF313131),
                              Color(0xFF636363)
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7.96),
                            topRight: Radius.circular(7.96),
                          ),
                          // border: Border(
                          //   top: BorderSide(
                          //     width: 1.5,
                          //     color: myLoading.isDark
                          //         ? Colors.white
                          //         : Colors.grey,
                          //   ),
                          // ),
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: myLoading.isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              },
              options: CS.CarouselOptions(
                height: 50.0,
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 4 / 3,
                autoPlayInterval: const Duration(seconds: 3),
                enableInfiniteScroll: true,
                viewportFraction: 0.3,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // Update the current index
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: screenHeight * 0.58,
                child: SliderPageShimmer(
                  isDarkMode: myLoading.isDark,
                )),
          ],
        ),
      );
    });
  }
}
