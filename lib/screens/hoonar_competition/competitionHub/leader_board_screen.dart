import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/request_model/store_payment_request_model.dart';
import 'package:hoonar/screens/hoonar_competition/competitionHub/your_rank_screen.dart';
import 'package:hoonar/shimmerLoaders/leaderboard_list_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  Widget build(BuildContext context) {
    final contestProvider = Provider.of<ContestProvider>(context);
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    contestProvider.filterLeaderboard(value);
                  },
                  style: GoogleFonts.poppins(
                      color: myLoading.isDark ? Colors.white : Colors.black,
                      fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    fillColor:
                        myLoading.isDark ? Color(0xFF2A2A2A) : Colors.white70,
                    hintText: AppLocalizations.of(context)!.searchContestant,
                    hintStyle: GoogleFonts.poppins(
                        color: myLoading.isDark ? Colors.white : Colors.black,
                        fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: myLoading.isDark ? Colors.white : Colors.black,
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
                      levelId: widget.levelId,
                      categoryId: widget.categoryId,
                    )),
                  );
                },
                child: Hero(
                  tag: 'your_rank',
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                        SizedBox(
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
              SizedBox(
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
                  ? LeaderboardListShimmer()
                  : contestProvider.filteredLeaderboardList.isEmpty
                      ? DataNotFound()
                      : ListView.builder(
                          itemCount: /* contestProvider
                              .leaderboardListModel!.data!.length*/
                              contestProvider.filteredLeaderboardList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final contestant =
                                contestProvider.filteredLeaderboardList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
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
                                                      : Colors.grey.shade900,
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
                                            fontWeight: FontWeight.normal),
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
