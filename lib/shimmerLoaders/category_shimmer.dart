import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/my_loading/my_loading.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Shimmer.fromColors(
        baseColor:
            myLoading.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        highlightColor:
            myLoading.isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        child: SizedBox(
          height: 50,
          child: AnimatedList(
            shrinkWrap: true,
            initialItemCount: 6,
            itemBuilder: (context, index, animation) {
              return buildItem(
                  animation, index, myLoading.isDark); // Build each list item
            },
          ),
        ),
      );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: 40,
      height: 20,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
      ),
    );
  }
}
