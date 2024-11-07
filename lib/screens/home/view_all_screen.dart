import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:hoonar/shimmerLoaders/grid_shimmer.dart';
import 'package:provider/provider.dart';

import '../../constants/common_widgets.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/data_not_found.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../providers/home_provider.dart';
import '../auth_screen/login_screen.dart';

class ViewAllScreen extends StatefulWidget {
  final String type;

  const ViewAllScreen({super.key, required this.type});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOtherData(context);
    });
  }

  Future<void> getOtherData(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    ListCommonRequestModel requestModel =
        ListCommonRequestModel(type: widget.type);
    await homeProvider.getOtherViewAllList(requestModel, "");

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.homePageOtherViewAllModel?.status == 200) {
      } else if (homeProvider.homePageOtherViewAllModel?.message ==
          'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.homePageOtherViewAllModel?.message! ?? '');
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
            child: Column(
              children: [
                homeProvider.isPostLoading ||
                        homeProvider.homePageOtherViewAllModel == null
                    ? GridShimmer()
                    : homeProvider.homePageOtherViewAllModel!.data == null ||
                            homeProvider
                                .homePageOtherViewAllModel!.data!.isEmpty
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
                                .homePageOtherViewAllModel!.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: ReelsListScreen(
                                      postList: homeProvider
                                              .homePageOtherViewAllModel!
                                              .data ??
                                          [],
                                      index: index,
                                    )),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: homeProvider
                                          .homePageOtherViewAllModel!
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
          ),
        ),
      );
    });
  }
}
