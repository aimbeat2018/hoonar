import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class CarouselSlider extends StatelessWidget {
  final int amount;
  final int position;
  final bool? isDarkMode;
  late double sliderLength;

  CarouselSlider({
    super.key,
    required this.position,
    required this.isDarkMode,
    required this.amount,
  }) {
    // sliderLength = properties.trackbarLength / amount;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Stack(
        children: [
          AnimatedSmoothIndicator(
            activeIndex: position,
            count: amount,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: isDarkMode! ? Colors.white : Colors.black,
              dotColor: Colors.grey,
            ),
          ),
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 200),
          //   top: 0,
          //   bottom: 0,
          //   left: position * 200,
          //   // left: xPos,
          //   child: Container(
          //     width: 200,
          //     height: 10,
          //     decoration: BoxDecoration(
          //       color: Colors.blue,
          //       borderRadius: BorderRadius.circular(10 / 2),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

// double get xPos {
//   double freeLength = 10 - sliderLength;
//   if (freeLength <= 1) {
//     return 0;
//   }
//   freeLength = (freeLength * position) / freeLength;
//   return -0.9 + (2 * freeLength);
//   // return 12;
// }
}
