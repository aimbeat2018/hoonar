import 'dart:async';
import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/reels/reels_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/internet_connectivity.dart';
import '../../constants/key_res.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/no_internet_screen.dart';
import '../../constants/session_manager.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../../providers/home_provider.dart';
import '../auth_screen/login_screen.dart';
import '../main_screen/main_screen.dart';

class SinglePostScreen extends StatefulWidget {
  final String? postId;

  const SinglePostScreen({super.key, this.postId});

  @override
  State<SinglePostScreen> createState() => _ReelsListScreenState();
}

class _ReelsListScreenState extends State<SinglePostScreen> {
  final controller = SwiperController();
  int? currentIndex;
  bool hasSwiped = false; // Flag to track if the user has swiped
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isLoading = false;
  SessionManager sessionManager = SessionManager();
  String loginUserId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log('post Data ${widget.postId}');

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
      getPostById(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> getPostById(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(postId: int.parse(widget.postId!));

      await homeProvider.getSinglePostDetails(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.getPostDetailsModel?.status == 200) {
        } else if (homeProvider.getPostDetailsModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.getPostDetailsModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Consumer<MyLoading>(
      builder: (context, myLoading, child) {
        return _connectionStatus == KeyRes.connectivityCheck
            ? const NoInternetScreen()
            : PopScope(
                canPop: true, // Allow pop by default
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    SlideRightRoute(page: const MainScreen(fromIndex: 0)),
                    (route) => false,
                  );
                },
                child: Scaffold(
                  backgroundColor:
                      myLoading.isDark ? Colors.black : Colors.white,
                  body: SafeArea(
                    child: Stack(
                      children: [
                        /*   Swiper(
                          controller: controller,
                          index: currentIndex,
                          itemBuilder: (BuildContext context, int index) {
                            return ReelsWidget(
                              model: widget.postList![index],
                              index: index,
                              postList: widget.postList!,
                            );
                          },
                          itemCount: widget.postList!.length,
                          scrollDirection: Axis.vertical,
                          loop: false,
                          onIndexChanged: (index) {
                            setState(() {
                              hasSwiped = true;
                              currentIndex = index;
                            });
                          },
                        ),*/

                        !isLoading && homeProvider.getPostDetailsModel != null
                            ? homeProvider.getPostDetailsModel!.status == 200
                                ? ReelsWidget(
                                    model:
                                        homeProvider.getPostDetailsModel!.data!,
                                    index: 0)
                                : homeProvider.getPostDetailsModel!.status ==
                                        201
                                    ? Center(
                                        child: Text(
                                          'You have block this user',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text('Post not found',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            )),
                                      )
                            : const Positioned.fill(
                                child: Center(
                                child: CircularProgressIndicator(),
                              )),
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                SlideRightRoute(
                                    page: const MainScreen(fromIndex: 0)),
                                (route) => false,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 13, top: 15),
                              child: Image.asset(
                                'assets/images/back_image.png',
                                height: 28,
                                width: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
