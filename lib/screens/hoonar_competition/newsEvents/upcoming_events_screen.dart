import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/theme.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../providers/contest_provider.dart';
import '../../../shimmerLoaders/news_event_list_shimmer.dart';
import '../../auth_screen/login_screen.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  SessionManager sessionManager = SessionManager();
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
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
      getNewsEvent(context);
    });
  }

  Future<void> getNewsEvent(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(/*date: _selectedDate*/);

      await contestProvider.getUpcomingNewsEventList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.upcomingNewsEventSuccessModel?.status == '200') {
        } else if (contestProvider.upcomingNewsEventSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.upcomingNewsEventSuccessModel?.message! ?? '');
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
    final contestProvider = Provider.of<ContestProvider>(context);
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(myLoading.isDark
                        ? 'assets/images/screens_back.png'
                        : 'assets/dark_mode_icons/white_screen_back.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
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
                            AppLocalizations.of(context)!.upcomingEvents,
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
                          contestProvider.isNewsLoading ||
                                  contestProvider
                                          .upcomingNewsEventSuccessModel ==
                                      null
                              ? const NewsEventListShimmer()
                              : contestProvider.upcomingNewsEventSuccessModel!
                                              .data ==
                                          null ||
                                      contestProvider
                                          .upcomingNewsEventSuccessModel!
                                          .data!
                                          .isEmpty
                                  ? DataNotFound()
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      shrinkWrap: true,
                                      itemCount: contestProvider
                                          .upcomingNewsEventSuccessModel!
                                          .data!
                                          .length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10,
                                                right: 10,
                                                left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  contestProvider
                                                          .upcomingNewsEventSuccessModel!
                                                          .data![index]
                                                          .title ??
                                                      ''.toUpperCase(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  contestProvider
                                                          .upcomingNewsEventSuccessModel!
                                                          .data![index]
                                                          .description ??
                                                      '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  /* '${AppLocalizations.of(context)!.today}, 09:00 PM',*/
                                                  contestProvider
                                                          .upcomingNewsEventSuccessModel!
                                                          .data![index]
                                                          .createdAt ??
                                                      '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
