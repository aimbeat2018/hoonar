import 'package:flutter/material.dart';

import '../../constants/slide_right_route.dart';
import '../reels/reels_list_screen.dart';

class HoonarStarScreen extends StatefulWidget {
  final ScrollController controller;

  const HoonarStarScreen({super.key, required this.controller});

  @override
  State<HoonarStarScreen> createState() => _HoonarStarScreenState();
}

class _HoonarStarScreenState extends State<HoonarStarScreen> {
  final List<String> imageUrls = [
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image3.png',
    'assets/images/image4.png',
    'assets/images/image5.png',
    'assets/images/image6.png',
    'assets/images/image7.png',
  ];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 3 : 4;
    return CustomScrollView(
      controller: widget.controller,
      slivers: [
        // Other slivers...
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 0.55,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                onTap: () {
                  // SliderModel(raps, 'assets/images/video1.mp4', '', '@abcd@123'),
                  // Navigator.push(
                  //   context,
                  //   SlideRightRoute(page: ReelsListScreen()),
                  // );
                },
                child: Image.asset(
                  imageUrls[index],
                  fit: BoxFit.cover,
                ),
              );
            },
            childCount: imageUrls.length,
          ),
        ),
        // Other slivers...
      ],
    );
  }
}
