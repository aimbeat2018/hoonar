import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/my_loading/my_loading.dart';
import '../constants/sizedbox_constants.dart';

class ListHorizontalShimmer extends StatelessWidget {
  const ListHorizontalShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Shimmer.fromColors(
        baseColor:
            myLoading.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        highlightColor:
            myLoading.isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    sizedBoxH10,
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 20,
                          decoration: BoxDecoration(
                            color:
                                myLoading.isDark ? Colors.black : Colors.white,
                          ),
                        ),
                        sizedBoxW5,
                        Container(
                          width: 150,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                                myLoading.isDark ? Colors.black : Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 50,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                                myLoading.isDark ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    sizedBoxH10,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: AnimatedList(
                        shrinkWrap: true,
                        initialItemCount: 6,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index, animation) {
                          return buildItem(animation, index, myLoading.isDark,
                              context); // Build each list item
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode,
      BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
