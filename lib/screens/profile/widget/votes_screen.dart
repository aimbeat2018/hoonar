import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/shimmerLoaders/vote_list_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../model/success_models/user_wise_vote_list_model.dart';
import '../../../providers/user_provider.dart';
import '../../auth_screen/login_screen.dart';

class VotesScreen extends StatefulWidget {
  final String? userId;

  const VotesScreen({super.key, this.userId});

  @override
  State<VotesScreen> createState() => _VotesScreenState();
}

class _VotesScreenState extends State<VotesScreen> {
  SessionManager sessionManager = SessionManager();
  List<UserWiseVoteList> voteList = [];
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getVotesList(context);
    });
  }

  Future<void> getVotesList(BuildContext context) async {
    sessionManager.initPref().then((onValue) async {
      String userId = "";
      if (widget.userId == "") {
        userId = sessionManager.getString(SessionManager.userId)!;
      } else {
        userId = widget.userId!;
      }

      ListCommonRequestModel requestModel = ListCommonRequestModel(
        userId: int.parse(userId),
        /*  start: followingList.length == 10 ? followingList.length : 0,
          limit: paginationLimit*/
      );

      isLoading = true;
      setState(() {});
      final authProvider = Provider.of<UserProvider>(context, listen: false);

      await authProvider.getVotes(requestModel);

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else if (authProvider.userWiseVoteListModel!.status == "200") {
        voteList.clear();
        voteList.addAll(authProvider.userWiseVoteListModel!.data!);
      } else if (authProvider.userWiseVoteListModel!.message ==
          'Unauthorized Access!') {
        Future.microtask(() {
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        });
      }

      isLoading = false;
      setState(() {});
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
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: isLoading == true
                  ? VoteListShimmer()
                  : voteList.isEmpty
                      ? DataNotFound()
                      : AnimatedList(
                          initialItemCount: voteList.length,
                          // controller: _scrollController,
                          itemBuilder: (context, index, animation) {
                            return buildItem(animation, index,
                                myLoading.isDark); // Build each list item
                          },
                        ),
            );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.80,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          borderRadius: BorderRadius.circular(6.19),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voteList[index].levelName ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  voteList[index].categoryName ?? '',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF939393),
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            )
            /*  .animate()
                .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                .slideX(duration: 800.ms)*/
            ,
          ),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: voteList[index].voteCount!.toString() ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' ${AppLocalizations.of(context)!.votes}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF939393),
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        /*.animate()
        // .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)*/
        ;
  }
}
