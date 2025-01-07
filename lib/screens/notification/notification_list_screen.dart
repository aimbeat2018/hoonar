import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/my_loading/my_loading.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/custom/snackbar_util.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/notification_list_model.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:hoonar/shimmerLoaders/news_event_list_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/color_constants.dart';
import '../../constants/internet_connectivity.dart';
import '../../constants/key_res.dart';
import '../../constants/no_internet_screen.dart';
import '../../constants/session_manager.dart';
import '../../constants/theme.dart';
import '../../custom/data_not_found.dart';
import '../../providers/home_provider.dart';
import '../profile/profile_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  SessionManager sessionManager = SessionManager();
  final ScrollController _scrollController = ScrollController();
  List<NotificationData> notificationData = [];
  bool isLoading = false;
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

    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            getNotification(context);
          }
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNotification(context);
      updateNotificationCount(context);
    });
  }

  Future<void> getNotification(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
        start: notificationData.length == 10 ? notificationData.length : 0,
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

  Future<void> updateNotificationCount(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
        start: notificationData.length == 10 ? notificationData.length : 0,
      );

      await homeProvider.markNotificationAsRead(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.notificationReadModel?.status == '200') {
        } else if (homeProvider.notificationReadModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.notificationReadModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    /*image: DecorationImage(
              image: AssetImage(myLoading.isDark
                  ? 'assets/images/screens_back.png'
                  : 'assets/dark_mode_icons/white_screen_back.png'),
              fit: BoxFit.cover,
            ),*/
                    color: myLoading.isDark ? Colors.black : Colors.white),
                child: SafeArea(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, bottom: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  'assets/images/back_image.png',
                                  height: 28,
                                  width: 28,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Center(
                              child: GradientText(
                            AppLocalizations.of(context)!.notification,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: myLoading.isDark
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: [
                                  myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  myLoading.isDark
                                      ? greyTextColor8
                                      : Colors.grey.shade700
                                ]),
                          )),
                          SizedBox(
                            height: 15,
                          ),
                          ValueListenableBuilder<NotificationListModel?>(
                              valueListenable:
                                  homeProvider.notificationListNotifier,
                              builder: (context, commentData, child) {
                                if (commentData == null) {
                                  return NewsEventListShimmer();
                                } else if (commentData.data == null ||
                                    commentData.data!.isEmpty) {
                                  return DataNotFound();
                                } else {
                                  notificationData = commentData.data!;
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: notificationData.length,
                                  itemBuilder: (context, index) {
                                    return _buildNotificationData(
                                        notificationData[index],
                                        myLoading.isDark);
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider();
                                  },
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
    });
  }

  Widget _buildNotificationData(NotificationData model, bool isDarkMode) {
    DateTime dateTime = DateTime.parse(model.createdAt!);

    // Format the DateTime
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    return InkWell(
      onTap: () {
        if (model.userId != null) {
          Navigator.push(
            context,
            SlideRightRoute(
                page: ProfileScreen(
              from: 'profile',
              userId: model.userId!.toString(),
            )),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            if (model.image != '')
              Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                  child: ClipOval(
                    child: model.image != ""
                        ? CachedNetworkImage(
                            imageUrl: model.image ?? '',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/user_avtar.png',
                              height: 120,
                              width: 120,
                            ),
                            fit: BoxFit.cover,
                            width: 150,
                            // Match the size of the CircleAvatar
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/user_avtar.png',
                            height: 100,
                            width: 100,
                          ),
                  ),
                ),
              ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.message ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  /*Text(
                    model.description ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),*/
                  // SizedBox(
                  //   height: 3,
                  // ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Text(
                  //     formattedDate,
                  //     style: GoogleFonts.poppins(
                  //       fontSize: 12,
                  //       color: isDarkMode ? Colors.white : Colors.black,
                  //       fontWeight: FontWeight.normal,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
