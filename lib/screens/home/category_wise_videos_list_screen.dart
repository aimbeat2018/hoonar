import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';

import '../../constants/slide_right_route.dart';

class CategoryWiseVideosListScreen extends StatefulWidget {
  const CategoryWiseVideosListScreen({super.key});

  @override
  State<CategoryWiseVideosListScreen> createState() =>
      _CategoryWiseVideosListScreenState();
}

class _CategoryWiseVideosListScreenState
    extends State<CategoryWiseVideosListScreen> {
  final List<String> imageUrls = [
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image3.png',
    'assets/images/image4.png',
    'assets/images/image5.png',
    'assets/images/image6.png',
    'assets/images/image7.png',
  ];

  String selectedCategory = 'Dance';
  final List<String> categories = [
    'Dance',
    'Vocals',
    'Drama',
    'Raps',
    'Poetry',
    'Modelling'
  ];
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Toggles both the fade and scale animation
  void _toggleAnimation() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 3 : 4;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppbar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(
                            width: 20,
                            child: Divider(
                              color: greyTextColor7,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: _toggleAnimation,
                            child: Row(
                              children: [
                                Text(
                                  selectedCategory,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: greyTextColor7,
                          ),
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 2,
                      childAspectRatio:
                          0.6, // Adjust according to image dimensions
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
                ],
              ),
              Positioned(
                top: 25,
                left: 10,
                right: 150,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: _isVisible ? categories.length * 60 : 0,
                  // Animate width
                  height: _isVisible ? categories.length * 50 : 0,
                  // Animate height
                  child: Card(
                    color: Colors.white,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategory = categories[index];
                            });
                            _toggleAnimation();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              categories[index],
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
