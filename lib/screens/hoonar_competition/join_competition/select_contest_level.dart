import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_payment_request_model.dart';
import 'package:hoonar/providers/contest_provider.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/contest_join_success_screen.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/make_level_payment_screen.dart';
import 'package:hoonar/shimmerLoaders/level_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/success_models/level_list_model.dart';
import '../../auth_screen/login_screen.dart';
import 'contest_join_options_screen.dart';

class SelectContestLevel extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const SelectContestLevel(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<SelectContestLevel> createState() => _SelectContestLevelState();
}

class _SelectContestLevelState extends State<SelectContestLevel> {
  SessionManager sessionManager = SessionManager();
  String couponCode = "";
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
      getLevelList(context);
    });
  }

  Future<void> getLevelList(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(categoryId: widget.categoryId);

      await contestProvider.getLevelList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.levelListModel?.status == '200') {
        } else if (contestProvider.levelListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.levelListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> storePayment(
      BuildContext context, StorePaymentRequestModel requestModel) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      await contestProvider.storePayment(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.storePaymentSuccessModel?.status == '200') {
          Navigator.of(context).pop();
          if (requestModel.paymentStatus != 'failed') {
            if (mounted) {
              setState(() {
                KeyRes.selectedLevelId = requestModel.levelId!;
              });
            }

            Navigator.push(
              context,
              SlideRightRoute(
                  page: ContestJoinSuccessScreen(
                      categoryId: widget.categoryId,
                      levelId: requestModel.levelId.toString())),
            );
          }
        } else if (contestProvider.storePaymentSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.storePaymentSuccessModel?.message! ?? '');
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
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 30),
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
                        Image.asset(
                          myLoading.isDark
                              ? 'assets/dark_mode_icons/time_to_shine_dark.png'
                              : 'assets/light_mode_icons/time_to_shine_light.png',
                          scale: 1.5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.beAContestant,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        contestProvider.isLevelLoading ||
                                contestProvider.levelListModel == null
                            ? const LevelShimmer()
                            : contestProvider.levelListModel!.data == null ||
                                    contestProvider
                                        .levelListModel!.data!.isEmpty
                                ? const DataNotFound()
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: contestProvider
                                        .levelListModel!.data!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 5),
                                        child: InkWell(
                                          onTap: contestProvider
                                                      .levelListModel!
                                                      .data![index]
                                                      .isPreviousLevelWin ==
                                                  0
                                              ? null
                                              : () {
                                                  if (contestProvider
                                                              .levelListModel!
                                                              .data![index]
                                                              .isUnlocked ==
                                                          1 &&
                                                      contestProvider
                                                              .levelListModel!
                                                              .data![index]
                                                              .hasWon ==
                                                          0) {
                                                    if (mounted) {
                                                      setState(() {
                                                        KeyRes.selectedLevelId =
                                                            contestProvider
                                                                .levelListModel!
                                                                .data![index]
                                                                .levelId!;
                                                      });
                                                    }
                                                    Navigator.push(
                                                        context,
                                                        SlideRightRoute(
                                                            page:
                                                                ContestJoinOptionsScreen(
                                                          levelId: contestProvider
                                                              .levelListModel!
                                                              .data![index]
                                                              .levelId
                                                              .toString(),
                                                          categoryId:
                                                              widget.categoryId,
                                                        )));
                                                  } else if (contestProvider
                                                              .levelListModel!
                                                              .data![index]
                                                              .isUnlocked ==
                                                          1 &&
                                                      contestProvider
                                                              .levelListModel!
                                                              .data![index]
                                                              .hasWon ==
                                                          1) {
                                                    showWonDialog(
                                                        context,
                                                        myLoading.isDark,
                                                        contestProvider
                                                            .levelListModel!
                                                            .data![index]
                                                            .voteScore!,
                                                        contestProvider
                                                            .levelListModel!
                                                            .data![index]
                                                            .rank!);
                                                  } else {
                                                    showPaymentPopUp(
                                                        context,
                                                        myLoading.isDark,
                                                        index,
                                                        contestProvider
                                                            .levelListModel!
                                                            .data![index]);
                                                  }
                                                },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(myLoading
                                                        .isDark
                                                    ? 'assets/dark_mode_icons/level_back_dark.png'
                                                    : 'assets/light_mode_icons/level_back_light.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25.0,
                                                      vertical: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      contestProvider
                                                          .levelListModel!
                                                          .data![index]
                                                          .levelName!,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        color: contestProvider
                                                                    .levelListModel!
                                                                    .data![
                                                                        index]
                                                                    .isPreviousLevelWin ==
                                                                0
                                                            ? (myLoading.isDark
                                                                ? Colors.white24
                                                                : Colors
                                                                    .black26)
                                                            : (myLoading.isDark
                                                                ? Colors.white
                                                                : Colors.black),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: contestProvider
                                                                  .levelListModel!
                                                                  .data![index]
                                                                  .isUnlocked ==
                                                              1
                                                          ? (myLoading.isDark
                                                              ? Colors.white
                                                              : Colors.black)
                                                          : myLoading.isDark
                                                              ? Colors
                                                                  .grey.shade900
                                                              : Colors.grey
                                                                  .shade700,
                                                      // Background color
                                                      shape: BoxShape.circle,
                                                      // Makes the container circular
                                                      border: Border.all(
                                                          color: contestProvider
                                                                      .levelListModel!
                                                                      .data![
                                                                          index]
                                                                      .isPreviousLevelWin ==
                                                                  0
                                                              ? (myLoading
                                                                      .isDark
                                                                  ? Colors
                                                                      .white24
                                                                  : Colors
                                                                      .black26)
                                                              : (contestProvider
                                                                          .levelListModel!
                                                                          .data![
                                                                              index]
                                                                          .isUnlocked ==
                                                                      1
                                                                  ? Colors
                                                                      .transparent
                                                                  : (myLoading.isDark
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                          width:
                                                              1), // Optional border
                                                    ),
                                                    child: Icon(
                                                      contestProvider
                                                                  .levelListModel!
                                                                  .data![index]
                                                                  .isUnlocked ==
                                                              1
                                                          ? Icons.lock_open
                                                          : Icons.lock_outline,
                                                      color: contestProvider
                                                                  .levelListModel!
                                                                  .data![index]
                                                                  .isPreviousLevelWin ==
                                                              0
                                                          ? (myLoading.isDark
                                                              ? Colors.white24
                                                              : Colors.black26)
                                                          : (contestProvider
                                                                      .levelListModel!
                                                                      .data![
                                                                          index]
                                                                      .isUnlocked ==
                                                                  1
                                                              ? (myLoading
                                                                      .isDark
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white)
                                                              : (myLoading
                                                                      .isDark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black)),
                                                      size: 22,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
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
            );
    });
  }

  void showWonDialog(
      BuildContext context, bool isDarkMode, int vote, int rank) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // title: Text(
          //   AppLocalizations.of(context)!.logout,
          //   style: GoogleFonts.poppins(
          //     color: isDarkMode ? Colors.white : Colors.black,
          //   ),
          // ),
          content: Text(
            AppLocalizations.of(context)!
                .congratulations_on_achievement(rank, vote),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.okay,
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showPaymentPopUp(
      BuildContext context, bool isDarkMode, int index, LevelListData model) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Enables dynamic resizing
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(45.0),
        ),
      ),
      builder: (BuildContext context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 300), // Smooth transition
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: FractionallySizedBox(
            heightFactor:
                MediaQuery.of(context).viewInsets.bottom == 0 ? 0.5 : 0.6,
            child: MakeLevelPaymentScreen(
              isDarkMode: isDarkMode,
              index: index,
              model: model,
              categoryId: widget.categoryId!,
            ),
          ),
        );
      },
    );
  }
}
