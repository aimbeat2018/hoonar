import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/model/success_models/sound_list_model.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/upload_video_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/common_widgets.dart';
import '../../../../constants/internet_connectivity.dart';
import '../../../../constants/key_res.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/no_internet_screen.dart';
import '../../../../constants/session_manager.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../custom/data_not_found.dart';
import '../../../../custom/snackbar_util.dart';
import '../../../../model/request_model/common_request_model.dart';
import '../../../../providers/contest_provider.dart';
import '../../../../shimmerLoaders/grid_shimmer.dart';
import '../../../auth_screen/login_screen.dart';
import '../connectShare/connect_share_screen.dart';

class HoonarStarVideoListScreen extends StatefulWidget {
  const HoonarStarVideoListScreen({super.key});

  @override
  State<HoonarStarVideoListScreen> createState() =>
      _HoonarStarVideoListScreenState();
}

class _HoonarStarVideoListScreenState extends State<HoonarStarVideoListScreen> {
  SessionManager sessionManager = SessionManager();
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
      getDraftFeedList(context);
    });
  }

  Future<void> getDraftFeedList(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel =
          CommonRequestModel(categoryId: KeyRes.selectedCategoryId.toString());

      await contestProvider.getUserDraftFeedCategoryWise(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.draftFeedListModel?.status == '200') {
        } else if (contestProvider.draftFeedListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.draftFeedListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
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
    final contestProvider = Provider.of<ContestProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
              body: contestProvider.isDraftFeedLoading ||
                      contestProvider.draftFeedListModel == null
                  ? GridShimmer()
                  : contestProvider.draftFeedListModel!.data == null ||
                          contestProvider
                                  .draftFeedListModel!.data!.hoonarStar ==
                              null ||
                          contestProvider
                              .draftFeedListModel!.data!.hoonarStar!.isEmpty
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
                          itemCount: contestProvider
                              .draftFeedListModel!.data!.hoonarStar!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      page: ConnectShareScreen(
                                    videoUrl: contestProvider
                                            .draftFeedListModel!
                                            .data!
                                            .hoonarStar![index]
                                            .postVideo ??
                                        '',
                                    videoThumbnail: contestProvider
                                            .draftFeedListModel!
                                            .data!
                                            .hoonarStar![index]
                                            .postImage ??
                                        '',
                                  )),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: contestProvider.draftFeedListModel!
                                        .data!.hoonarStar![index].postImage ??
                                    '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error, color: Colors.red),
                              ),
                            );
                          },
                        ),
            );
    });
  }
}
