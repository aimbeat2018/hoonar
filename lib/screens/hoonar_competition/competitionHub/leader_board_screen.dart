import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/request_model/store_payment_request_model.dart';
import 'package:hoonar/screens/hoonar_competition/competitionHub/your_rank_screen.dart';
import 'package:hoonar/shimmerLoaders/leaderboard_list_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../model/success_models/level_list_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';

class LeaderBoardScreen extends StatefulWidget {
  final int? categoryId;
  final String? levelId;

  const LeaderBoardScreen({super.key, this.categoryId, this.levelId});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  SessionManager sessionManager = SessionManager();
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  List<LevelListData> zoneLevelsList = [];
  LevelListData? selectedLevel;

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
          setState(() {
            zoneLevelsList = contestProvider.levelListModel!.data!;

            for (var data in zoneLevelsList) {
              if (data.levelId == int.parse(widget.levelId!)) {
                selectedLevel = data;
                getLeaderboardList(context, selectedLevel!.levelId!);
              }
            }
          });
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

  Future<void> getLeaderboardList(BuildContext context, int levelId) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      StorePaymentRequestModel requestModel = StorePaymentRequestModel(
          categoryId: widget.categoryId,
          levelId: /*int.parse(widget.levelId!)*/ levelId);

      await contestProvider.getLeaderboardList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.leaderboardListModel?.status == 200) {
          contestProvider.setLeaderboardList(
              contestProvider.leaderboardListModel?.data ?? []);
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: (value) {
                          contestProvider.filterLeaderboard(value);
                        },
                        style: GoogleFonts.poppins(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          fillColor: myLoading.isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.white70,
                          hintText:
                              AppLocalizations.of(context)!.searchContestant,
                          hintStyle: GoogleFonts.poppins(
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    contestProvider.isLevelLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 45.0, vertical: 10),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 3),
                                  labelText:
                                      AppLocalizations.of(context)!.level,
                                  labelStyle: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          width: 1))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<LevelListData>(
                                  dropdownColor: myLoading.isDark
                                      ? Colors.black
                                      : Colors.white,
                                  // Dropdown background color
                                  value: selectedLevel,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  isExpanded: true,
                                  // Make dropdown fill the width
                                  style: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                  items: zoneLevelsList
                                      .map<DropdownMenuItem<LevelListData>>(
                                          (LevelListData value) {
                                    return DropdownMenuItem<LevelListData>(
                                      value: value,
                                      child: Text(
                                        value.levelName ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (LevelListData? newValue) {
                                    setState(() {
                                      selectedLevel = newValue!;
                                    });

                                    /*         getHoonarStarsList(
                                  context, selectedLevel!.levelId!);*/

                                    getLeaderboardList(
                                        context, selectedLevel!.levelId!);
                                  },
                                ),
                              ),
                            ),
                          ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideRightRoute(
                              page: YourRankScreen(
                            levelId: selectedLevel?.levelId?.toString() ??
                                widget.levelId,
                            categoryId: widget.categoryId,
                          )),
                        );
                      },
                      child: Hero(
                        tag: 'your_rank',
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: contBlueColor1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/rank.png',
                                height: 28,
                                width: 28,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!.yourRank,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          AppLocalizations.of(context)!.rank,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: myLoading.isDark
                                  ? Colors.white70
                                  : Colors.grey.shade900,
                              fontWeight: FontWeight.normal),
                        )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              textAlign: TextAlign.center,
                              AppLocalizations.of(context)!.contestantName,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: myLoading.isDark
                                      ? Colors.white70
                                      : Colors.grey.shade900,
                                  fontWeight: FontWeight.normal),
                            )),
                        Expanded(
                            child: Text(
                          textAlign: TextAlign.center,
                          AppLocalizations.of(context)!.votes,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: myLoading.isDark
                                  ? Colors.white70
                                  : Colors.grey.shade900,
                              fontWeight: FontWeight.normal),
                        ))
                      ],
                    ),
                    contestProvider.isLeaderboardLoading ||
                            contestProvider.leaderboardListModel == null
                        ? const LeaderboardListShimmer()
                        : contestProvider.filteredLeaderboardList.isEmpty
                            ? const DataNotFound()
                            : ListView.builder(
                                itemCount: /* contestProvider
                              .leaderboardListModel!.data!.length*/
                                    contestProvider
                                        .filteredLeaderboardList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final contestant = contestProvider
                                      .filteredLeaderboardList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: (contestant.rank == 1 ||
                                                    contestant.rank == 2 ||
                                                    contestant.rank == 3)
                                                ? Image.asset(
                                                    contestant.rank == 1
                                                        ? 'assets/images/1st.png'
                                                        : contestant.rank == 2
                                                            ? 'assets/images/2nd.png'
                                                            : 'assets/images/3rd.png',
                                                    height: 20,
                                                    width: 20,
                                                  )
                                                : Text(
                                                    contestant.rank.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        color: myLoading.isDark
                                                            ? Colors.white70
                                                            : Colors
                                                                .grey.shade900,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  )),
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              contestant.fullName ?? '',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                        Expanded(
                                            child: Text(
                                          textAlign: TextAlign.center,
                                          contestant.totalVotes.toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ))
                                      ],
                                    ),
                                  );
                                },
                              )
                  ],
                ),
              ),
            );
    });
  }
}
