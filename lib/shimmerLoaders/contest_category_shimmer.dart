import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/my_loading/my_loading.dart';

class ContestCategoryShimmer extends StatelessWidget {
  const ContestCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 2 : 4;

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Shimmer.fromColors(
        baseColor:
            myLoading.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        highlightColor:
            myLoading.isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 15,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9, // Adjust according to image dimensions
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: myLoading.isDark ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(10)),
            );
          },
        ),
      );
    });
  }
}
