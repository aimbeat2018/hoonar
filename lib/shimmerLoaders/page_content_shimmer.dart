import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/my_loading/my_loading.dart';

class PageContentShimmer extends StatelessWidget {
  const PageContentShimmer({super.key});

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
          padding: EdgeInsets.symmetric(horizontal: 15),
          itemBuilder: (context, index, animation) {
            return buildItem(animation, index, myLoading.isDark,
                context); // Build each list item
          },
        ),
      );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode,
      BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      height: 15,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
      ),
    );
  }
}
