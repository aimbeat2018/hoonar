import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart' as CS;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/sizedbox_constants.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/constants/utils.dart';
import 'package:hoonar/custom/data_not_found.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/home_page_other_data_model.dart';
import 'package:hoonar/providers/home_provider.dart';
import 'package:hoonar/screens/home/category_wise_videos_list_screen.dart';
import 'package:hoonar/screens/home/view_all_screen.dart';
import 'package:hoonar/screens/home/widgets/carousel_page_view.dart';
import 'package:hoonar/screens/home/widgets/slider_page_view.dart';
import 'package:hoonar/screens/notification/notification_list_screen.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:hoonar/shimmerLoaders/home_slider_shimmers.dart';
import 'package:hoonar/shimmerLoaders/list_horizontal_shimmer.dart';
import 'package:provider/provider.dart';

import '../../constants/color_constants.dart';
import '../../constants/common_widgets.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../../custom/snackbar_util.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../auth_screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final CS.CarouselSliderController _carouselController =
      CS.CarouselSliderController();
  SwiperController controller = SwiperController();
  SwiperController videoSwiperController = SwiperController();
  int currentIndex = 0;
  List<OtherListModel> otherList = [];
  SessionManager sessionManager = SessionManager();
  bool isLoading = false;
  HomeOtherData? homeOtherData = HomeOtherData(
      judgesChoicePostList: [], myFavPostList: [], forYouPostList: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionManager.initPref();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHomePost(context);
      getHomePageOtherPost(context);
      getNotificationCount(context);
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

  Future<void> getHomePageOtherPost(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(limit: paginationLimit);

      await homeProvider.getHomeOtherPostList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.homePageOtherDataModel?.status == 200) {
          if (mounted) {
            setState(() {
              homeOtherData = homeProvider.homePageOtherDataModel?.data!;
            });
          }
        } else if (homeProvider.homePageOtherDataModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.homePageOtherDataModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getNotificationCount(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
        start: 1,
      );

      await homeProvider.getNotificationList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.notificationListModel?.status == '200') {
        } else if (homeProvider.notificationListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.notificationListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    videoSwiperController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a network request
    getHomePost(context);
    getHomePageOtherPost(context);
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
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  SlideRightRoute(page: NotificationListScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: myLoading.isDark ? Colors.white : Colors.black,
                      size: 30, // Adjust size as needed
                    ),
                    // Notification count
                    if (homeProvider.notificationCountNotifier.value != "0")
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red, // Background color for the count
                            shape: BoxShape.circle, // Circular shape
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              homeProvider.notificationCountNotifier.value,
                              style: const TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 12, // Font size
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  homeProvider.isHomeLoading ||
                          homeProvider.homePostSuccessModel == null ||
                          homeProvider.homePostSuccessModel!.data == null
                      ? HomeSliderShimmers()
                      : Column(
                          children: [
                            CS.CarouselSlider.builder(
                              carouselController: _carouselController,
                              itemCount: homeProvider
                                  .homePostSuccessModel!.data!.length,
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
                                            // border: Border(
                                            //   top: BorderSide(
                                            //     width: 1.5,
                                            //     color: myLoading.isDark
                                            //         ? Colors.white
                                            //         : Colors.grey,
                                            //   ),
                                            // ),
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
                            homeProvider.homePostSuccessModel!
                                        .data![_currentIndex].posts ==
                                    null
                                ? DataNotFound()
                                : homeProvider.homePostSuccessModel!
                                        .data![_currentIndex].posts!.isEmpty
                                    ? DataNotFound()
                                    : /*SizedBox(
                                        // height: screenHeight * 0.58,
                                        child: CarouselPageView(
                                        sliderModelList: homeProvider
                                                .homePostSuccessModel!
                                                .data![_currentIndex]
                                                .posts ??
                                            [],
                                        isDarkMode: myLoading.isDark,
                                      ))*/
                                    SizedBox(
                                        height: screenHeight * 0.58,
                                        child: SliderPageView(
                                          sliderModelList: homeProvider
                                                  .homePostSuccessModel!
                                                  .data![_currentIndex]
                                                  .posts ??
                                              [],
                                          isDarkMode: myLoading.isDark,
                                        ))
                          ],
                        ),
                  SizedBox(
                    height: 15,
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
                  homeProvider.isOtherHomeLoading
                      ? const ListHorizontalShimmer()
                      : Column(
                          children: [
                            homeOtherData!.judgesChoicePostList == null
                                ? const SizedBox.shrink()
                                : homeOtherData!.judgesChoicePostList!.isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          otherListWidget(
                                              AppLocalizations.of(context)!
                                                  .judgesChoice,
                                              homeOtherData!
                                                      .judgesChoicePostList ??
                                                  [],
                                              myLoading.isDark),
                                        ],
                                      ),
                            const SizedBox(
                              height: 10,
                            ),
                            homeOtherData!.myFavPostList == null
                                ? const SizedBox.shrink()
                                : homeOtherData!.myFavPostList!.isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          otherListWidget(
                                              AppLocalizations.of(context)!
                                                  .favrite,
                                              homeOtherData!.myFavPostList ??
                                                  [],
                                              myLoading.isDark),
                                        ],
                                      ),
                            const SizedBox(
                              height: 10,
                            ),
                            homeOtherData!.forYouPostList == null
                                ? const SizedBox.shrink()
                                : homeOtherData!.forYouPostList!.isEmpty
                                    ? const SizedBox.shrink()
                                    : otherListWidget(
                                        AppLocalizations.of(context)!.foryours,
                                        homeOtherData!.forYouPostList ?? [],
                                        myLoading.isDark),
                            const SizedBox(
                              height: 10,
                            ),
                            homeOtherData!.trendingNowPostList == null
                                ? const SizedBox.shrink()
                                : homeOtherData!.trendingNowPostList!.isNotEmpty
                                    ? otherListWidget(
                                        AppLocalizations.of(context)!
                                            .trendingNow,
                                        homeOtherData!.trendingNowPostList ??
                                            [],
                                        myLoading.isDark)
                                    : const SizedBox.shrink(),
                            const SizedBox(
                              height: 10,
                            ),
                            homeOtherData!.hoonarHighlightsPostList == null
                                ? const SizedBox.shrink()
                                : homeOtherData!
                                        .hoonarHighlightsPostList!.isEmpty
                                    ? const SizedBox.shrink()
                                    : otherListWidget(
                                        AppLocalizations.of(context)!
                                            .hoonarHighlights,
                                        homeOtherData!
                                                .hoonarHighlightsPostList ??
                                            [],
                                        myLoading.isDark),
                            const SizedBox(
                              height: 10,
                            ),
                            homeOtherData!.featuredTalentPostList == null
                                ? const SizedBox.shrink()
                                : homeOtherData!.featuredTalentPostList!.isEmpty
                                    ? const SizedBox.shrink()
                                    : otherListWidget(
                                        AppLocalizations.of(context)!
                                            .featuredTalents,
                                        homeOtherData!.featuredTalentPostList ??
                                            [],
                                        myLoading.isDark),
                            const SizedBox(
                              height: 10,
                            ),
                            homeOtherData!.hoonarStarsPostList == null
                                ? const SizedBox.shrink()
                                : homeOtherData!.hoonarStarsPostList!.isEmpty
                                    ? const SizedBox.shrink()
                                    : otherListWidget(
                                        AppLocalizations.of(context)!
                                            .hoonarStar,
                                        homeOtherData!.hoonarStarsPostList ??
                                            [],
                                        myLoading.isDark),
                            const SizedBox(
                              height: 10,
                            ),
                            homeOtherData!.hoonarStarOfMonths == null
                                ? const SizedBox.shrink()
                                : homeOtherData!.hoonarStarOfMonths!.isEmpty
                                    ? const SizedBox.shrink()
                                    : otherListWidget(
                                        AppLocalizations.of(context)!
                                            .hoonarStarOfTheMonth,
                                        homeOtherData!.hoonarStarOfMonths ?? [],
                                        myLoading.isDark),
                          ],
                        ),

                  /*ListView.builder(
                    itemCount: otherList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return otherListWidget(otherList[index], myLoading.isDark);
                    },
                  ),*/
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget otherListWidget(
      String title, List<PostsListData> postData, bool isDarkMode) {
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
                  title,
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
                  if (title == AppLocalizations.of(context)!.judgesChoice) {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: const ViewAllScreen(
                        type: 'judges_choice',
                      )),
                    );
                  } else if (title == AppLocalizations.of(context)!.favrite) {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: const ViewAllScreen(
                        type: 'my_fav',
                      )),
                    );
                  } else if (title == AppLocalizations.of(context)!.foryours) {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: const ViewAllScreen(
                        type: 'for_yours',
                      )),
                    );
                  } else if (title ==
                      AppLocalizations.of(context)!.trendingNow) {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: const ViewAllScreen(
                        type: 'trending_now',
                      )),
                    );
                  } else if (title ==
                      AppLocalizations.of(context)!.hoonarHighlights) {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: const ViewAllScreen(
                        type: 'hoonar_highlights',
                      )),
                    );
                  } else if (title ==
                      AppLocalizations.of(context)!.featuredTalents) {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: const ViewAllScreen(
                        type: 'featured_talent',
                      )),
                    );
                  } else if (title ==
                      AppLocalizations.of(context)!.hoonarStar) {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: const ViewAllScreen(
                        type: 'hoonar_stars',
                      )),
                    );
                  } else if (title ==
                      AppLocalizations.of(context)!.hoonarStarOfTheMonth) {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: const ViewAllScreen(
                        type: 'hoonar_star_of_months',
                      )),
                    );
                  }
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
              itemCount: postData.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                String initials = postData[index].fullName != null ||
                        postData[index].fullName != ""
                    ? postData[index]
                        .fullName!
                        .trim()
                        .split(' ')
                        .map((e) => e[0])
                        .take(2)
                        .join()
                        .toUpperCase()
                    : '';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideRightRoute(
                            page: ReelsListScreen(
                          postList: postData,
                          index: index,
                        )),
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
                                image: NetworkImage(postData[index].postImage!),
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
                            right: 5,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade200,
                                  child: ClipOval(
                                    child: postData[index].userProfile != ""
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                postData[index].userProfile!,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (context, url,
                                                    error) =>
                                                buildInitialsAvatar(initials,
                                                    fontSize: 8),
                                            fit: BoxFit.cover,
                                            width: 20,
                                            // Match the size of the CircleAvatar
                                            height: 20,
                                          )
                                        : buildInitialsAvatar(initials,
                                            fontSize: 8),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    postData[index].userName ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
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
