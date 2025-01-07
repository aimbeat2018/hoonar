import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants/common_widgets.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/utils.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../model/success_models/get_followers_list_model.dart';
import '../../../providers/user_provider.dart';
import '../../../shimmerLoaders/following_list_shimmer.dart';
import '../../auth_screen/login_screen.dart';

class FollowingScreen extends StatefulWidget {
  final String? userId;

  const FollowingScreen({super.key, this.userId});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen>
    with SingleTickerProviderStateMixin {
  bool isFollow = false;

  final ScrollController _scrollController = ScrollController();
  SessionManager sessionManager = SessionManager();
  List<FollowersData> followingList = [];
  bool isLoading = false;
  bool isFollowLoading = false;
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

    sessionManager.initPref();
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            getFollowingList(context);
          }
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFollowingList(context);
    });
  }

  Future<void> getFollowingList(BuildContext context) async {
    sessionManager.initPref().then((onValue) async {
      // String userId = sessionManager.getString(SessionManager.userId)!;
      ListCommonRequestModel requestModel = ListCommonRequestModel(
          userId: int.parse(widget.userId!),
          start: followingList.length == 10 ? followingList.length : 0,
          limit: paginationLimit);

      isLoading = true;
      setState(() {});
      final authProvider = Provider.of<UserProvider>(context, listen: false);

      await authProvider.getFollowing(requestModel);

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else if (authProvider.getFollowingListModel!.status == "200") {
        followingList.clear();
        followingList.addAll(authProvider.getFollowingListModel!.data!);
      } else if (authProvider.getFollowingListModel!.message ==
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

  Future<void> followUnFollowUser(BuildContext context, int userId) async {
    ListCommonRequestModel requestModel = ListCommonRequestModel(
      toUserId: userId,
    );

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
    _scrollController.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: isLoading == true
                  ? FollowingListShimmer()
                  : followingList.isEmpty
                      ? DataNotFound()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ValueListenableBuilder<String?>(
                                valueListenable:
                                    userProvider.followingCountNotifier,
                                builder: (context, followingCount, child) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      '$followingCount ${AppLocalizations.of(context)!.following}',
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
                            SizedBox(
                              height: 10,
                            ),
                            AnimatedList(
                              shrinkWrap: true,
                              initialItemCount: followingList.length,
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
    String initials = followingList[index].fullName != null ||
            followingList[index].fullName != ""
        ? followingList[index]
            .fullName!
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '';
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
                    child: followingList[index].userProfile != ""
                        ? CachedNetworkImage(
                            imageUrl: followingList[index].userProfile!,
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
                        followingList[index].fullName ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        followingList[index].userName ?? '',
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
          ValueListenableBuilder<int?>(
              valueListenable: userProvider.followStatusNotifier,
              builder: (context, followStatus, child) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      followUnFollowUser(
                          context, followingList[index].fromUserId ?? 0);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: followingList[index].isFollow == 1 ||
                                followStatus == 1
                            ? (isDarkMode ? Colors.white : Colors.black)
                            : Colors.transparent,
                        width: 1,
                      ),
                      color: followingList[index].isFollow == 1 ||
                              followStatus == 1
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
                                )))
                        : Text(
                            followingList[index].isFollow == 1 ||
                                    followStatus == 1
                                ? AppLocalizations.of(context)!.unfollow
                                : AppLocalizations.of(context)!.follow,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: followingList[index].isFollow == 1 ||
                                      followStatus == 1
                                  ? (isDarkMode ? Colors.white : Colors.black)
                                  : (isDarkMode ? Colors.black : Colors.white),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
