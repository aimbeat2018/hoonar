import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/custom/data_not_found.dart';
import 'package:hoonar/screens/shimmerLoaders/following_list_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/utils.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../model/success_models/get_followers_list_model.dart';
import '../../../providers/user_provider.dart';
import '../../auth_screen/login_screen.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen>
    with AutomaticKeepAliveClientMixin {
  bool isFollow = false;
  final ScrollController _scrollController = ScrollController();
  SessionManager sessionManager = SessionManager();
  List<FollowersData> followersList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    sessionManager.initPref();
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
      String userId = sessionManager.getString(SessionManager.userId)!;
      ListCommonRequestModel requestModel = ListCommonRequestModel(
          userId: int.parse(userId),
          start: followersList.length,
          limit: paginationLimit);

      isLoading = true;
      final authProvider = Provider.of<UserProvider>(context, listen: false);

      await authProvider.getFollowers(requestModel);

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } /*else {
        if (authProvider.profileSuccessModel?.status == '200') {
        } else if (authProvider.profileSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, authProvider.profileSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        }
      }*/
    });
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return ValueListenableBuilder<GetFollowersListModel?>(
          valueListenable: userProvider.followersNotifier,
          builder: (context, followersDataList, child) {
            if (followersDataList == null) {
              return FollowingListShimmer();
            }
            /* else if (followersDataList.data == null ||
                followersDataList.data!.isEmpty) {
              return DataNotFound();
            }*/
            else if (followersDataList.message == 'Unauthorized Access!') {
              Future.microtask(() {
                Navigator.pushAndRemoveUntil(context,
                    SlideRightRoute(page: LoginScreen()), (route) => false);
              });
            }

            followersList.clear();
            followersList.addAll(followersDataList.data!);

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: followersList.isEmpty
                  ? DataNotFound()
                  : AnimatedList(
                      initialItemCount: followersList.length,
                      controller: _scrollController,
                      itemBuilder: (context, index, animation) {
                        return buildItem(animation, index,
                            myLoading.isDark); // Build each list item
                      },
                    ),
            );
          });
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode) {
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
                  )
                  /* .animate()
                      .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                      .slide()*/
                  ,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isFollow = !isFollow;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isFollow
                      ? (isDarkMode ? Colors.white : Colors.black)
                      : Colors.transparent,
                  width: 1,
                ),
                color: isFollow
                    ? Colors.transparent
                    : (isDarkMode ? Colors.white : Colors.black),
              ),
              child: Text(
                isFollow
                    ? AppLocalizations.of(context)!.unfollow
                    : AppLocalizations.of(context)!.follow,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isFollow
                      ? (isDarkMode ? Colors.white : Colors.black)
                      : (isDarkMode ? Colors.black : Colors.white),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
