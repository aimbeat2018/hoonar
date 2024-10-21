import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart' as CS;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/sizedbox_constants.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/constants/utils.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/slider_model.dart';
import 'package:hoonar/providers/home_provider.dart';
import 'package:hoonar/screens/home/category_wise_videos_list_screen.dart';
import 'package:hoonar/screens/home/judges_choice_screen.dart';
import 'package:hoonar/screens/home/widgets/slider_page_view.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../constants/color_constants.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../../custom/snackbar_util.dart';
import '../../shimmerLoaders/category_shimmer.dart';
import '../auth_screen/login_screen.dart';

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
  List<String> typeList = [
    'raps', //1
    'vocals', //2
    'dance', //3
    'dance', //3
  ];
  int _currentIndex = 0;
  final CS.CarouselSliderController _carouselController =
      CS.CarouselSliderController();
  SwiperController controller = SwiperController();
  SwiperController videoSwiperController = SwiperController();
  int currentIndex = 0;
  List<OtherListModel> otherList = [];
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionManager.initPref();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        otherList = [
          OtherListModel(AppLocalizations.of(context)!.judgesChoice, [
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
          ]),
          OtherListModel(AppLocalizations.of(context)!.favrite, [
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
          ]),
          OtherListModel(AppLocalizations.of(context)!.foryours, [
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
            'assets/images/judgesCh.png',
            'assets/images/foryours.png',
          ])
        ];
      });

      getHomePost(context);
    });
  }

  Future<void> getHomePost(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(limit: paginationLimit);

      await homeProvider.getHomePostList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.homePostSuccessModel?.status == '200') {
        } else if (homeProvider.homePostSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.homePostSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    videoSwiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final homeProvider = Provider.of<HomeProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
          title: Row(
            children: [
              InkWell(
                child: Image.asset(
                  'assets/images/small_logo.png',
                  height: 30,
                  width: 30,
                  color: myLoading.isDark ? Colors.white : Colors.black,
                ),
              ),
              sizedBoxW10,
              Text(
                AppLocalizations.of(context)!.appName.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: myLoading.isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                Icons.notifications,
                color: myLoading.isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                homeProvider.isHomeLoading ||
                        homeProvider.homePostSuccessModel == null
                    ? CircularProgressIndicator()
                    : Column(
                        children: [
                          CS.CarouselSlider.builder(
                            carouselController: _carouselController,
                            itemCount:
                                homeProvider.homePostSuccessModel!.data!.length,
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              return GestureDetector(
                                onTap: () {
                                  // On tap, go to the next slide
                                  setState(() {
                                    _currentIndex = index;
                                    _carouselController.animateToPage(
                                        index); // Jump to the tapped item
                                  });
                                },
                                child: Container(
                                  /*margin:
                                    EdgeInsets.symmetric(horizontal: screenWidth * 0.1),*/
                                  // 10% of the screen width for margin
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: _currentIndex == index
                                      ? BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment(0.00, 1.00),
                                            end: Alignment(0, -1),
                                            colors: [
                                              Colors.black,
                                              Color(0xFF313131),
                                              Color(0xFF636363)
                                            ],
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(7.96),
                                            topRight: Radius.circular(7.96),
                                          ),
                                          border: Border(
                                            top: BorderSide(
                                              width: 1.5,
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        )
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                  child: Center(
                                    child: Text(
                                      homeProvider.homePostSuccessModel!
                                              .data![index].categoryName ??
                                          '',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                        color: _currentIndex == index
                                            ? Colors.white
                                            : myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            _currentIndex == index ? 13 : 12,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: CS.CarouselOptions(
                              height: 50.0,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              aspectRatio: 4 / 3,
                              autoPlayInterval: const Duration(seconds: 3),
                              enableInfiniteScroll: true,
                              viewportFraction: 0.3,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex =
                                      index; // Update the current index
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: screenHeight * 0.58,
                              child: SliderPageView(
                                sliderModelList: homeProvider
                                        .homePostSuccessModel!
                                        .data![_currentIndex]
                                        .posts ??
                                    [],
                                isDarkMode: myLoading.isDark,
                              )),
                        ],
                      ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideRightRoute(
                            page: const CategoryWiseVideosListScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              myLoading.isDark
                                  ? greyTextColor5
                                  : greyTextColor6,
                              myLoading.isDark
                                  ? greyTextColor6
                                  : greyTextColor8,
                              myLoading.isDark
                                  ? greyTextColor5
                                  : greyTextColor6,
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
                            AppLocalizations.of(context)!.viewMore,
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
                ListView.builder(
                  itemCount: otherList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return otherListWidget(otherList[index], myLoading.isDark);
                  },
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget otherListWidget(OtherListModel model, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: const BoxDecoration(color: Color(0xFFDCB398)),
              ),
              sizedBoxW5,
              Expanded(
                child: Text(
                  model.titleName!,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    SlideRightRoute(page: const JudgesChoiceScreen()),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.viewAll,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          sizedBoxH10,
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.28,
            child: ListView.builder(
              itemCount: model.imagesList!.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideRightRoute(page: const ReelsListScreen()),
                      );
                    },
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
                            width: MediaQuery.of(context).size.width * 0.4,
                            // height: 23.06,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(model.imagesList![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Gradient overlay at bottom
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

/* Widget swiperSlider() {
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
              */ /* Container(
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
              ),*/ /*
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
  }*/
}

class OtherListModel {
  String? titleName;
  List<String>? imagesList;

  OtherListModel(this.titleName, this.imagesList);
}
