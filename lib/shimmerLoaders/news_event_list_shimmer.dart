import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/my_loading/my_loading.dart';

class NewsEventListShimmer extends StatelessWidget {
  const NewsEventListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Shimmer.fromColors(
        baseColor:
            myLoading.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        highlightColor:
            myLoading.isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        child: AnimatedList(
          shrinkWrap: true,
          initialItemCount: 10,
          itemBuilder: (context, index, animation) {
            return buildItem(
                animation, index, myLoading.isDark); // Build each list item
          },
        ),
      );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.80,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          borderRadius: BorderRadius.circular(6.19),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 12,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: 200,
            height: 12,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: 200,
            height: 12,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: 200,
            height: 12,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: 200,
            height: 12,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: 50,
            height: 12,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
