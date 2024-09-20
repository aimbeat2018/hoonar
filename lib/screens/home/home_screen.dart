import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/sizedbox_constants.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/model/slider_model.dart';
import 'package:hoonar/screens/home/category_wise_videos_list_screen.dart';
import 'package:hoonar/screens/home/widgets/reels_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/color_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SliderModel> sliderModelList = [
    SliderModel(raps, 'assets/images/video1.mp4', '', '@abcd@123'),
    SliderModel(vocals, 'assets/images/video2.mp4', '', '@abcd@123'),
    SliderModel(dance, 'assets/images/video3.mp4', '', '@abcd@123'),
  ];
  int _currentIndex = 0;
  SwiperController controller = SwiperController();
  SwiperController videoSwiperController = SwiperController();
  bool _isSyncing = false;
  int currentIndex = 0;

  /*@override
  void initState() {
    super.initState();

    // Add listener to the first swiper to sync with the second swiper
    controller.addListener(() {
      if (!_isSyncing && controller.index != videoSwiperController.index) {
        _isSyncing = true; // Prevent endless loop
        videoSwiperController.move(controller.index);
        _isSyncing = false;
      }
    });

    // Add listener to the second swiper to sync with the first swiper
    videoSwiperController.addListener(() {
      if (!_isSyncing && videoSwiperController.index != controller.index) {
        _isSyncing = true; // Prevent endless loop
        controller.move(videoSwiperController.index);
        _isSyncing = false;
      }
    });
  }*/

  @override
  void dispose() {
    controller.dispose();
    videoSwiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            InkWell(
              child: Image.asset(
                'assets/images/small_logo.png',
                height: 30,
                width: 30,
              ),
            ),
            sizedBoxW10,
            Text(
              appName.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Swiper(
                  controller: controller,
                  itemCount: sliderModelList.length,
                  onIndexChanged: (index) {
                    // videoSwiperController.move(index);
                    setState(() {
                      _currentIndex = index;
                      if (!_isSyncing) {
                        _isSyncing = true;
                        videoSwiperController.move(index);
                        _isSyncing = false;
                      }
                    });
                  },
                  onTap: (index) {
                    setState(() {
                      if (!_isSyncing) {
                        _isSyncing = true;
                        videoSwiperController.move(index);
                        _isSyncing = false;
                      }
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      /*margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),*/
                      // 10% of the screen width for margin
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: _currentIndex == index
                          ? const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.00, 1.00),
                                end: Alignment(0, -1),
                                colors: [
                                  Colors.black,
                                  Color(0xFF313131),
                                  Color(0xFF636363)
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7.96),
                                topRight: Radius.circular(7.96),
                              ),
                              border: Border(
                                top: BorderSide(
                                    width: 0.80, color: Colors.white),
                              ),
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                      child: Center(
                        child: Text(
                          sliderModelList[index].category,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: _currentIndex == index ? 13 : 12,
                          ),
                        ),
                      ),
                    );
                  },
                  physics: const PageScrollPhysics(),
                  viewportFraction: 0.3,
                  scale: 0.9,
                ),
              ),
              swiperSlider(),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideRightRoute(page: CategoryWiseVideosListScreen()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                          colors: [
                            greyTextColor5,
                            greyTextColor6,
                            greyTextColor5
                          ],
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          viewMore,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 20,
                          decoration:
                              const BoxDecoration(color: Color(0xFFDCB398)),
                        ),
                        sizedBoxW5,
                        Expanded(
                          child: Text(
                            judgesChoice,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            viewAll,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    sizedBoxH10,
                    Container(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                // color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Background Image
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    // height: 23.06,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/judgesCh.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay at bottom
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 48.25,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0),
                                            Colors.black,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // User info
                                  Positioned(
                                    bottom: 12,
                                    left: 5,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 14.78,
                                          height: 14.78,
                                          decoration: const ShapeDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/user_profile.png'),
                                              fit: BoxFit.fill,
                                            ),
                                            shape: OvalBorder(
                                              side: BorderSide(
                                                width: 0.49,
                                                color: Colors.white,
                                              ),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x99000000),
                                                blurRadius: 3.70,
                                                offset: Offset(0, 0.99),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'abcd@123',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 20,
                          decoration:
                              const BoxDecoration(color: Color(0xFFDCB398)),
                        ),
                        sizedBoxW5,
                        Expanded(
                          child: Text(
                            favrite,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            viewAll,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    sizedBoxH10,
                    Container(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                // color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Background Image
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    // height: 23.06,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/judgesChoice.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay at bottom
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 48.25,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0),
                                            Colors.black,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // User info
                                  Positioned(
                                    bottom: 12,
                                    left: 5,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 14.78,
                                          height: 14.78,
                                          decoration: const ShapeDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/user_profile.png'),
                                              fit: BoxFit.fill,
                                            ),
                                            shape: OvalBorder(
                                              side: BorderSide(
                                                width: 0.49,
                                                color: Colors.white,
                                              ),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x99000000),
                                                blurRadius: 3.70,
                                                offset: Offset(0, 0.99),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'abcd@123',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 15, right: 15, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 20,
                          decoration:
                              const BoxDecoration(color: Color(0xFFDCB398)),
                        ),
                        sizedBoxW5,
                        Expanded(
                          child: Text(
                            foryours,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            viewAll,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    sizedBoxH10,
                    Container(
                      height: MediaQuery.of(context).size.height * 0.28,
                      child: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                // color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Background Image
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    // height: 23.06,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/foryours.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay at bottom
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 48.25,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0),
                                            Colors.black,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // User info
                                  Positioned(
                                    bottom: 12,
                                    left: 5,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 14.78,
                                          height: 14.78,
                                          decoration: const ShapeDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/user_profile.png'),
                                              fit: BoxFit.fill,
                                            ),
                                            shape: OvalBorder(
                                              side: BorderSide(
                                                width: 0.49,
                                                color: Colors.white,
                                              ),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x99000000),
                                                blurRadius: 3.70,
                                                offset: Offset(0, 0.99),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'abcd@123',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget swiperSlider() {
    // Get screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.6, // 50% of the screen height
      child: Swiper(
        controller: videoSwiperController,
        physics: const PageScrollPhysics(),
        viewportFraction: 0.70,
        scale: 1,
        pagination: SwiperCustomPagination(
          builder: (BuildContext context, SwiperPluginConfig config) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSmoothIndicator(
                activeIndex: config.activeIndex,
                count: config.itemCount,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.grey,
                ),
              ),
            );
          },
        ),
        scrollDirection: Axis.horizontal,
        itemCount: sliderModelList.length,
        onIndexChanged: (index) {
          setState(() {
            if (!_isSyncing) {
              _isSyncing = true;
              controller.move(index);
              _isSyncing = false;
            }
          });

          // setState(() {
          //   _currentIndex = index;
          // });
        },
        itemBuilder: (context, index) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                // 10% of the screen width for margin
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: _currentIndex == index
                    ? const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, 1.00),
                          end: Alignment(0, -1),
                          colors: [
                            Colors.black,
                            Color(0xFF313131),
                            Color(0xFF636363)
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.96),
                          topRight: Radius.circular(7.96),
                        ),
                        border: Border(
                          top: BorderSide(width: 0.80, color: Colors.white),
                        ),
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                child: Center(
                  child: Text(
                    sliderModelList[index].category,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: _currentIndex == index ? 13 : 12,
                    ),
                  ),
                ),
              ),*/
              SizedBox(height: screenHeight * 0.02),
              // Adjust height dynamically (2% of screen height)
              AspectRatio(
                aspectRatio: 9 / 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ReelsScreen(
                    model: sliderModelList[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
