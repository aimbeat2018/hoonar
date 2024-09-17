import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/sizedbox_constants.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/model/slider_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedType = "1";
  List<String> typeList = [
    raps, //1
    vocals, //2
    dance, //3
  ];
  List<SliderModel> sliderModelList = [
    SliderModel(
        raps,
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        '',
        '@abcd@123'),
    SliderModel(
        vocals,
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        '',
        '@abcd@123'),
    SliderModel(
        dance,
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        '',
        '@abcd@123'),
  ];
  List<VideoPlayerController> _controllers = [];
  List<ChewieController> _chewieControllers = [];
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var model in sliderModelList) {
      // Initialize video controllers and Chewie controllers
      VideoPlayerController videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(model.video));
      _controllers.add(videoPlayerController);

      ChewieController chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          showControls: true,
          looping: false,
          fullScreenByDefault: true);
      _chewieControllers.add(chewieController);

      videoPlayerController.initialize().then((_) {
        setState(() {}); // Update UI once the video is initialized
      });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers when the widget is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var chewieController in _chewieControllers) {
      chewieController.dispose();
    }
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
              sliderWidget(),
              AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: sliderModelList.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.grey,
                ),
                onDotClicked: (index) {
                  _controller.animateToPage(index);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 2,
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
                                fontWeight: FontWeight.w600,
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
                          width: 2,
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
                                fontWeight: FontWeight.w600,
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
                          width: 2,
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
                                fontWeight: FontWeight.w600,
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

  Widget sliderWidget() {
    return CarouselSlider.builder(
      carouselController: _controller,
      itemCount: sliderModelList.length,
      itemBuilder: (context, index, realIndex) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Container(
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
                          // left: BorderSide(color: Colors.white),
                          top: BorderSide(width: 0.80, color: Colors.white),
                          // right: BorderSide(color: Colors.white),
                          // bottom: BorderSide(color: Colors.white),
                        ),
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                /*border: Border.all(
                                                      color: Colors.black,
                                                width: 0.5)*/
                child: Center(
                  child: Text(
                    sliderModelList[index].category,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: _currentIndex == index ? 13 : 12),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(height: 200, child: _buildVideoPlayer(index))
          ],
        );
      },
      options: CarouselOptions(
        height: 350.0,
        // Set height for your carousel
        autoPlay: false,
        autoPlayInterval: const Duration(seconds: 5),
        viewportFraction: 0.5,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildVideoPlayer(int index) {
    return Center(
      child: _controllers[index].value.isInitialized
          ? Chewie(
              controller: _chewieControllers[index],
            )
          : CircularProgressIndicator(),
    );
  }
}
