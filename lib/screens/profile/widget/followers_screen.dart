import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/custom/data_not_found.dart';
import 'package:provider/provider.dart';

import '../../../constants/common_widgets.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/utils.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../model/success_models/get_followers_list_model.dart';
import '../../../providers/user_provider.dart';
import '../../../shimmerLoaders/following_list_shimmer.dart';
import '../../auth_screen/login_screen.dart';

class FollowersScreen extends StatefulWidget {
  final String? userId;

  const FollowersScreen({super.key, this.userId});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen>
    with AutomaticKeepAliveClientMixin {
  bool isFollow = false;
  final ScrollController _scrollController = ScrollController();
  SessionManager sessionManager = SessionManager();
  List<FollowersData> followersList = [];
  bool isLoading = false;

  bool isFollowLoading = false;
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    sessionManager.initPref();
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
            getFollowerList(context);
          }
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFollowerList(context);
    });
  }

  Future<void> getFollowerList(BuildContext context) async {
    sessionManager.initPref().then((onValue) async {
      String userId = "";
      if (widget.userId == "") {
        userId = sessionManager.getString(SessionManager.userId)!;
      } else {
        userId = widget.userId!;
      }

      ListCommonRequestModel requestModel = ListCommonRequestModel(
          userId: int.parse(userId),
          start: followersList.length,
          limit: paginationLimit);

      isLoading = true;
      setState(() {});
      final authProvider = Provider.of<UserProvider>(context, listen: false);

      await authProvider.getFollowers(requestModel);

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else if (authProvider.getFollowersListModel!.status == "200") {
        followersList.clear();
        followersList.addAll(authProvider.getFollowersListModel!.data!);
      } else if (authProvider.getFollowersListModel!.message ==
          'Unauthorized Access!') {
        Future.microtask(() {
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        });
      }

      isLoading = false;
      setState(() {});
    });
  }

  Future<void> followUnFollowUser(BuildContext context, int userId) async {
    ListCommonRequestModel requestModel =
        ListCommonRequestModel(toUserId: userId, commonUserId: userId);

    isFollowLoading = true;
    final authProvider = Provider.of<UserProvider>(context, listen: false);

    await authProvider.followUnfollowUser(requestModel);

    if (authProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
    }

    isFollowLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: isLoading == true
                  ? const FollowingListShimmer()
                  : followersList.isEmpty
                      ? const DataNotFound()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ValueListenableBuilder<String?>(
                                valueListenable:
                                    userProvider.followersCountNotifier,
                                builder: (context, followersCount, child) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      '$followersCount ${AppLocalizations.of(context)!.followers}',
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedList(
                              shrinkWrap: true,
                              initialItemCount: followersList.length,
                              controller: _scrollController,
                              itemBuilder: (context, index, animation) {
                                return buildItem(
                                    animation,
                                    index,
                                    myLoading.isDark,
                                    userProvider); // Build each list item
                              },
                            ),
                          ],
                        ),
            );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode,
      UserProvider userProvider) {
    String initials = followersList[index].fullName != null ||
            followersList[index].fullName != ""
        ? followersList[index]
            .fullName!
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '';

    String loginUserId = sessionManager.getString(SessionManager.userId)!;
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                  child: ClipOval(
                    child: followersList[index].userProfile != ""
                        ? CachedNetworkImage(
                            imageUrl: followersList[index].userProfile!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                buildInitialsAvatar(initials, fontSize: 14),
                            fit: BoxFit.cover,
                            width: 80,
                            // Match the size of the CircleAvatar
                            height: 80,
                          )
                        : buildInitialsAvatar(initials, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        followersList[index].fullName ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        followersList[index].userName ?? '',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF939393),
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (loginUserId != followersList[index].fromUserId.toString())
            ValueListenableBuilder<Map<int, int?>>(
              valueListenable: userProvider.followStatusNotifier,
              builder: (context, followStatusMap, child) {
                int userId = followersList[index].fromUserId ?? 0;
                int followStatus =
                    followStatusMap[userId] ?? followersList[index].isFollow!;

                return InkWell(
                  onTap: () {
                    setState(() {
                      followUnFollowUser(context, userId).then((_) {
                        if (followStatus == 1) {
                          userProvider.followStatusNotifier.value[userId] = 0;
                        } else {
                          userProvider.followStatusNotifier.value[userId] = 1;
                        }
                        userProvider.followStatusNotifier.notifyListeners();
                      });
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: followStatus == 1
                            ? (isDarkMode ? Colors.white : Colors.black)
                            : Colors.transparent,
                        width: 1,
                      ),
                      color: followStatus == 1
                          ? Colors.transparent
                          : (isDarkMode ? Colors.white : Colors.black),
                    ),
                    child: isFollowLoading
                        ? const Center(
                            child: SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Text(
                            followStatus == 1
                                ? AppLocalizations.of(context)!.unfollow
                                : AppLocalizations.of(context)!.follow,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: followStatus == 1
                                  ? (isDarkMode ? Colors.white : Colors.black)
                                  : (isDarkMode ? Colors.black : Colors.white),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
