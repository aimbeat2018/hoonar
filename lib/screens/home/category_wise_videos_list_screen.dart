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
import '../../model/success_models/home_post_success_model.dart';
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
  List<PostsListData> postListData = [];
  List<PostsListData> newPostListData = [];
  bool _isVisible = false;
  ScrollController scrollController = ScrollController();
  ScrollController gridScrollController = ScrollController();
  bool isLoading = false, isMoreLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCategoryList(context);
    });

    gridScrollController.addListener(loadMore);
  }

  loadMore() {
    if (gridScrollController.position.maxScrollExtent ==
        gridScrollController.position.pixels) {
      if (!isLoading) {
        setState(() {
          isMoreLoading = true;
          page++;
        });

        getPostByCategory(context);
      }
    }
  }

  Future<void> getCategoryList(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
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

    setState(() {
      if (page == 1) {
        isLoading = true;
      } else {
        isMoreLoading = true;
      }
    });
    ListCommonRequestModel requestModel = ListCommonRequestModel(
        categoryId: selectedCategoryId, limit: paginationLimit, page: page);
    await homeProvider.getPostList(requestModel);

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.postListSuccessModel?.status == '200') {
        if (homeProvider.postListSuccessModel != null ||
            homeProvider.postListSuccessModel!.data != null ||
            homeProvider.postListSuccessModel!.data!.isNotEmpty) {
          if (page == 1) {
            postListData = homeProvider.postListSuccessModel!.data!;
          } else {
            newPostListData = [];
            newPostListData = homeProvider.postListSuccessModel!.data!;

            if (newPostListData.isNotEmpty) {
              postListData.addAll(newPostListData);
              postListData = postListData.toSet().toList();
            }
          }
        }
      }else if(homeProvider.postListSuccessModel?.status == '401'){
        if (page == 1) {
          postListData = homeProvider.postListSuccessModel!.data!;
        } else {
          newPostListData = [];
          newPostListData = homeProvider.postListSuccessModel!.data!;

          if (newPostListData.isNotEmpty) {
            postListData.addAll(newPostListData);
            postListData = postListData.toSet().toList();
          }
        }
      } else if (homeProvider.postListSuccessModel?.message ==
          'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.postListSuccessModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(
            context, SlideRightRoute(page: LoginScreen()), (route) => false);
      }
    }
    if (page == 1) {
      isLoading = false;
    } else {
      isMoreLoading = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    gridScrollController.removeListener(loadMore);
    gridScrollController.dispose();
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
    var screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 3 : 4;
    final homeProvider = Provider.of<HomeProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        appBar: buildAppbar(context, myLoading.isDark),
        body: SingleChildScrollView(
          controller: gridScrollController,
          // height: MediaQuery.of(context).size.height,
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
                            child: Divider(color: greyTextColor7),
                          ),
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
                                  const SizedBox(width: 10),
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
                            child: Divider(color: greyTextColor7),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    isLoading && postListData.isEmpty
                        ? GridShimmer()
                        : /*homeProvider.postListSuccessModel!.data == null ||
                            homeProvider
                                .postListSuccessModel!.data!.isEmpty*/
                        postListData.isEmpty
                            ? DataNotFound()
                            : Column(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    // controller: gridScrollController,
                                    padding: const EdgeInsets.all(8),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 2,
                                      childAspectRatio: 0.6,
                                    ),
                                    itemCount: /*homeProvider
                                        .postListSuccessModel!.data!*/
                                        postListData.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            SlideRightRoute(
                                              page: ReelsListScreen(
                                                postList: /* homeProvider
                                                        .postListSuccessModel!
                                                        .data*/
                                                    postListData ?? [],
                                                index: index,
                                              ),
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: /*homeProvider
                                                  .postListSuccessModel!
                                                  .data!*/
                                              postListData[index].postImage ??
                                                  '',
                                          placeholder: (context, url) => Center(
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              buildInitialsAvatar('No Image',
                                                  fontSize: 12),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                  if (isMoreLoading)
                                    Center(
                                      child: CircularProgressIndicator(),
                                    )
                                ],
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
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(10),
                              physics: const BouncingScrollPhysics(),
                              itemCount: homeProvider
                                  .categoryListSuccessModel!.data!.length,
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
                                      page =1;
                                      getPostByCategory(context);
                                    });
                                    _toggleAnimation();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      homeProvider.categoryListSuccessModel!
                                              .data![index].categoryName ??
                                          '',
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
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
