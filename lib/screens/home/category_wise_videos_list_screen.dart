import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/my_loading/my_loading.dart';
import 'package:hoonar/constants/utils.dart';
import 'package:hoonar/custom/data_not_found.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:hoonar/shimmerLoaders/grid_shimmer.dart';
import 'package:provider/provider.dart';

import '../../constants/slide_right_route.dart';
import '../../custom/snackbar_util.dart';
import '../../providers/home_provider.dart';
import '../../shimmerLoaders/category_shimmer.dart';
import '../auth_screen/login_screen.dart';

class CategoryWiseVideosListScreen extends StatefulWidget {
  const CategoryWiseVideosListScreen({super.key});

  @override
  State<CategoryWiseVideosListScreen> createState() =>
      _CategoryWiseVideosListScreenState();
}

class _CategoryWiseVideosListScreenState
    extends State<CategoryWiseVideosListScreen> {
  String selectedCategory = 'Dance';
  int selectedCategoryId = -1;
  List<String> categories = [];
  bool _isVisible = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCategoryList(context);
    });
  }

  Future<void> getCategoryList(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    await homeProvider.getCategoryList();

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.categoryListSuccessModel?.status == '200') {
        setState(() {
          selectedCategory =
              homeProvider.categoryListSuccessModel!.data![0].categoryName ??
                  '';
          selectedCategoryId =
              homeProvider.categoryListSuccessModel!.data![0].categoryId ?? -1;

          getPostByCategory(context);
        });
      } else if (homeProvider.categoryListSuccessModel?.message ==
          'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.categoryListSuccessModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(
            context, SlideRightRoute(page: LoginScreen()), (route) => false);
      }
    }

    setState(() {});
  }

  Future<void> getPostByCategory(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    ListCommonRequestModel requestModel = ListCommonRequestModel(
        categoryId: selectedCategoryId, limit: paginationLimit);
    await homeProvider.getPostList(requestModel);

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.postListSuccessModel?.status == '200') {
      } else if (homeProvider.postListSuccessModel?.message ==
          'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.postListSuccessModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(
            context, SlideRightRoute(page: LoginScreen()), (route) => false);
      }
    }

    setState(() {});
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
    final homeProvider = Provider.of<HomeProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        appBar: buildAppbar(context, myLoading.isDark),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                              onTap: _toggleAnimation,
                              child: Row(
                                children: [
                                  Text(
                                    selectedCategory,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
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
                    SizedBox(
                      height: 5,
                    ),
                    homeProvider.isPostLoading ||
                            homeProvider.postListSuccessModel == null
                        ? GridShimmer()
                        : homeProvider.postListSuccessModel!.data == null ||
                                homeProvider.postListSuccessModel!.data!.isEmpty
                            ? DataNotFound()
                            : GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 2,
                                  childAspectRatio:
                                      0.6, // Adjust according to image dimensions
                                ),
                                itemCount: homeProvider
                                    .postListSuccessModel!.data!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: ReelsListScreen(
                                          postList: homeProvider
                                                  .postListSuccessModel!.data ??
                                              [],
                                          index: index,
                                        )),
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: homeProvider
                                              .postListSuccessModel!
                                              .data![index]
                                              .postImage ??
                                          '',

                                      placeholder: (context, url) => Center(
                                        child: SizedBox(
                                            height: 15,
                                            width: 15,
                                            child:
                                                const CircularProgressIndicator()),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          buildInitialsAvatar('No Image',
                                              fontSize: 12),
                                      fit: BoxFit.cover,
                                      width: 80,
                                      // Match the size of the CircleAvatar
                                      height: 80,
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
                    // width: _isVisible
                    //     ? homeProvider.isCategoryLoading
                    //         ? 5 * 60
                    //         : homeProvider
                    //                 .categoryListSuccessModel!.data!.length *
                    //             60
                    //     : 0,
                    height: _isVisible
                        ? homeProvider.isCategoryLoading
                            ? 5 * 50
                            : (homeProvider.categoryListSuccessModel!.data!
                                        .length *
                                    40)
                                .clamp(200, 400)
                                .toDouble() // Convert to double
                        : 0,
                    child: Card(
                      color: Colors.white,
                      child: homeProvider.isCategoryLoading
                          ? CategoryShimmer()
                          : Column(
                              children: [
                                Expanded(
                                  // Ensures ListView has space to scroll within AnimatedContainer
                                  child: Scrollbar(
                                    controller: scrollController,
                                    thumbVisibility: true,
                                    thickness: 2.5,
                                    radius: const Radius.circular(10),
                                    child: ListView.builder(
                                      controller: scrollController,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      physics: BouncingScrollPhysics(),
                                      itemCount: homeProvider
                                          .categoryListSuccessModel!
                                          .data!
                                          .length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedCategory = homeProvider
                                                      .categoryListSuccessModel!
                                                      .data![index]
                                                      .categoryName ??
                                                  '';
                                              selectedCategoryId = homeProvider
                                                      .categoryListSuccessModel!
                                                      .data![index]
                                                      .categoryId ??
                                                  -1;

                                              getPostByCategory(context);
                                            });
                                            _toggleAnimation();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              homeProvider
                                                      .categoryListSuccessModel!
                                                      .data![index]
                                                      .categoryName ??
                                                  '',
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
                              ],
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
