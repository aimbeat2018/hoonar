import 'package:flutter/material.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/upload_video_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/common_widgets.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/slide_right_route.dart';

class DraftVideoListScreen extends StatefulWidget {
  const DraftVideoListScreen({super.key});

  @override
  State<DraftVideoListScreen> createState() => _DraftVideoListScreenState();
}

class _DraftVideoListScreenState extends State<DraftVideoListScreen> {
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
        body: GridView.builder(
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
                Navigator.push(
                  context,
                  SlideRightRoute(
                      page: UploadVideoScreen(
                    videoThumbnail: "",
                    videoUrl: [],
                  )),
                );
              },
              child: Image.asset(
                imageUrls[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      );
    });
  }
}
