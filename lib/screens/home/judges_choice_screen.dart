import 'package:flutter/material.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/common_widgets.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';

class JudgesChoiceScreen extends StatefulWidget {
  const JudgesChoiceScreen({super.key});

  @override
  State<JudgesChoiceScreen> createState() => _JudgesChoiceScreenState();
}

class _JudgesChoiceScreenState extends State<JudgesChoiceScreen> {
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 3 : 4;

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        appBar: buildAppbar(context, myLoading.isDark ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 0,
                mainAxisSpacing: 2,
                childAspectRatio: 0.6, // Adjust according to image dimensions
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // SliderModel(raps, 'assets/images/video1.mp4', '', '@abcd@123'),
                    Navigator.push(
                      context,
                      SlideRightRoute(page: ReelsListScreen()),
                    );
                  },
                  child: Image.asset(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
