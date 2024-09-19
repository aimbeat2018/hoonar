import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';

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
          child: Column(
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
                      child: Row(
                        children: [
                          Text(
                            'Dance',
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
                  childAspectRatio: 0.7, // Adjust according to image dimensions
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
