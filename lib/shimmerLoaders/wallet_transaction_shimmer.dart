import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/my_loading/my_loading.dart';

class WalletTransactionShimmer extends StatelessWidget {
  const WalletTransactionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Shimmer.fromColors(
        baseColor:
            myLoading.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        highlightColor:
            myLoading.isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        child: buildItem(context, myLoading.isDark),
      );
    });
  }

  Widget buildItem(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 12,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 60,
            height: 12,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 150,
                height: 12,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isDarkMode ? Colors.white : Colors.black,
                        width: 1)),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, bottom: 15, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          child: Container(
                            width: 150,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
