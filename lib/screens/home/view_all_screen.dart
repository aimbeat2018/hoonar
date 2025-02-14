import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:hoonar/shimmerLoaders/grid_shimmer.dart';
import 'package:provider/provider.dart';

import '../../constants/common_widgets.dart';
import '../../constants/internet_connectivity.dart';
import '../../constants/key_res.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/no_internet_screen.dart';
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
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    CheckInternet.initConnectivity().then((value) => setState(() {
          _connectionStatus = value;
        }));

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      CheckInternet.updateConnectionStatus(result).then((value) => setState(() {
            _connectionStatus = value;
          }));
    });

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
            context, SlideRightRoute(page: const LoginScreen()), (route) => false);
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 3 : 4;
    final homeProvider = Provider.of<HomeProvider>(context);
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
              appBar: buildAppbar(context, myLoading.isDark),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      homeProvider.isPostLoading ||
                              homeProvider.homePageOtherViewAllModel == null
                          ? const GridShimmer()
                          : homeProvider.homePageOtherViewAllModel!.data ==
                                      null ||
                                  homeProvider
                                      .homePageOtherViewAllModel!.data!.isEmpty
                              ? const DataNotFound()
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

                                        placeholder: (context, url) => const Center(
                                          child: SizedBox(
                                              height: 15,
                                              width: 15,
                                              child:
                                                  CircularProgressIndicator()),
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
