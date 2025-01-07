import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/custom/data_not_found.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/store_payment_request_model.dart';
import '../../../providers/contest_provider.dart';
import '../../../shimmerLoaders/user_rank_shimmer.dart';
import '../../auth_screen/login_screen.dart';
import '../yourRewards/your_rewards_screen.dart';

class YourRankScreen extends StatefulWidget {
  final int? categoryId;
  final String? levelId;

  const YourRankScreen({super.key, this.categoryId, this.levelId});

  @override
  State<YourRankScreen> createState() => _YourRankScreenState();
}

class _YourRankScreenState extends State<YourRankScreen> {
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
      getLeaderboardList(context);
    });
  }

  Future<void> getLeaderboardList(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      StorePaymentRequestModel requestModel = StorePaymentRequestModel(
          categoryId: widget.categoryId, levelId: int.parse(widget.levelId!));

      await contestProvider.getUserRankList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.leaderboardListModel?.status == 200) {
        } else if (contestProvider.leaderboardListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.leaderboardListModel?.message! ?? '');
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 10, bottom: 20),
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
                        Column(
                          children: [
                            Center(
                                child: GradientText(
                              AppLocalizations.of(context)!.yourRank,
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
                            contestProvider.isUserRankLoading ||
                                    contestProvider.userRankSuccessModel == null
                                ? UserRankShimmer()
                                : contestProvider.userRankSuccessModel!.data ==
                                        null
                                    ? DataNotFound()
                                    : Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 25),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 25, horizontal: 28),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(myLoading
                                                            .isDark
                                                        ? 'assets/dark_mode_icons/your_rank_back_dark.png'
                                                        : 'assets/light_mode_icons/your_rank_back_light.png'),
                                                    fit: BoxFit.fill)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  contestProvider
                                                          .userRankSuccessModel!
                                                          .data!
                                                          .fullName ??
                                                      '',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${AppLocalizations.of(context)!.category} : ${contestProvider.userRankSuccessModel!.data!.categoryName ?? ''}',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .rank,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  contestProvider
                                                      .userRankSuccessModel!
                                                      .data!
                                                      .rank
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 23,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                Text(
                                                  '${AppLocalizations.of(context)!.level} : ${contestProvider.userRankSuccessModel!.data!.levelName ?? ''}',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .congratulations,
                                            style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: orangeColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                              contestProvider
                                                      .userRankSuccessModel!
                                                      .data!
                                                      .message ??
                                                  '',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                            const SizedBox(
                              height: 35,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      page: const YourRewardsScreen()),
                                );
                              },
                              child: Hero(
                                tag: 'your_rank',
                                child: IntrinsicHeight(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: contBlueColor1),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/reward.png',
                                          height: 28,
                                          width: 28,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .yourRewards,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
