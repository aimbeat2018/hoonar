import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/success_models/profile_success_model.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/screens/profile/drafts_screen.dart';
import 'package:hoonar/screens/profile/feed_screen.dart';
import 'package:hoonar/screens/profile/followers_tabs_screen.dart';
import 'package:hoonar/screens/profile/hoonar_star_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/about_app_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/app_content_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/edit_profile_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/help_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/manage_devices_screen.dart';
import 'package:hoonar/shimmerLoaders/grid_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/common_widgets.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/snackbar_util.dart';
import '../auth_screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String from;
  final String? userId;

  const ProfileScreen({super.key, required this.from, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> optionsList = [
    editProfile,
    help,
    termsConditions,
    privacyPolicy,
    manageDevices,
    aboutApp,
    'logout'
  ];

  ScrollController controller = ScrollController();
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    sessionManager.initPref();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserProfile(context);
    });
  }

  Future<void> getUserProfile(BuildContext context) async {
    String userId = "";
    sessionManager.initPref().then((onValue) async {
      if (widget.from == 'main') {
        userId = sessionManager.getString(SessionManager.userId)!;
      } else {
        userId = widget.userId ?? '';
      }
      CommonRequestModel requestModel = CommonRequestModel(userId: userId);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.getProfile(requestModel);

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else {
        /*if (authProvider.profileSuccessModel?.status == '200') {
        } else if (authProvider.profileSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, authProvider.profileSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        }*/
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                /* image: DecorationImage(
                      image: AssetImage('assets/images/screens_back.png'),
                      fit: BoxFit.cover,
                    ),*/
                color: myLoading.isDark ? Colors.black : Colors.white),
            child: CustomScrollView(
              controller: controller,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ValueListenableBuilder<ProfileSuccessModel?>(
                        valueListenable: authProvider.profileNotifier,
                        builder: (context, profile, child) {
                          if (profile == null) {
                            return const ProfileContentShimmer();
                          }
                          /*else if (profile.data != null) {
                            return SizedBox();
                          }*/
                          else if (profile.message == 'Unauthorized Access!') {
                            Future.microtask(() {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  SlideRightRoute(page: LoginScreen()),
                                  (route) => false);
                            });
                          }

                          return Column(
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      widget.from != 'main'
                                          ? Positioned(
                                              left: 5,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 13),
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
                                            )
                                          : const SizedBox(),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          // Use the smaller dimension (width or height) for CircleAvatar's size
                                          double avatarSize =
                                              constraints.maxWidth <
                                                      constraints.maxHeight
                                                  ? constraints.maxWidth
                                                  : constraints.maxHeight;

                                          String initials =
                                              profile.data?.fullName != null ||
                                                      profile.data?.fullName !=
                                                          ""
                                                  ? profile.data!.fullName!
                                                      .trim()
                                                      .split(' ')
                                                      .map((e) => e[0])
                                                      .take(2)
                                                      .join()
                                                      .toUpperCase()
                                                  : '';

                                          return Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Hero(
                                                  tag: 'profileImage',
                                                  child: CircleAvatar(
                                                    radius: avatarSize / 7,
                                                    backgroundColor: myLoading
                                                            .isDark
                                                        ? Colors.grey.shade700
                                                        : Colors.grey.shade200,
                                                    child: ClipOval(
                                                      child: profile.data
                                                                  ?.userProfile !=
                                                              ""
                                                          ? CachedNetworkImage(
                                                              imageUrl: profile
                                                                  .data!
                                                                  .userProfile!,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  buildInitialsAvatar(
                                                                      initials),
                                                              fit: BoxFit.cover,
                                                              // width: 80,
                                                              // // Match the size of the CircleAvatar
                                                              // height: 80,
                                                            )
                                                          : buildInitialsAvatar(
                                                              initials),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  profile.data?.fullName ??
                                                      'No Name',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  profile.data?.userName ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      widget.from == 'main'
                                          ? Positioned(
                                              right: 5,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: menuItemsWidget(
                                                      myLoading.isDark)),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                  if (profile.data?.bio != "")
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 3),
                                        child: Text(
                                          profile.data?.bio ?? '',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: myLoading.isDark
                                                ? Colors.white60
                                                : Colors.grey,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              page: const FollowersTabScreen(
                                            currentTabFrom: 0,
                                          )),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              profile.data?.followersCount
                                                      .toString() ??
                                                  '0',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: myLoading.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .followers,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: redColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            SlideRightRoute(
                                                page: const FollowersTabScreen(
                                              currentTabFrom: 1,
                                            )),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Colors.white,
                                                  greyTextColor8
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .votes
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              page: const FollowersTabScreen(
                                            currentTabFrom: 2,
                                          )),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              profile.data?.followingCount
                                                      .toString() ??
                                                  '0',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: myLoading.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .following,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: redColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: const Color(0x403F3F3F),
                                // padding: EdgeInsets.symmetric(vertical: 5),
                                child: TabBar(
                                  labelColor: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  // Color for selected tab label
                                  unselectedLabelColor: myLoading.isDark
                                      ? Colors.white60
                                      : Colors.grey.shade900,
                                  // Color for unselected tab labels
                                  labelStyle: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  unselectedLabelStyle: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  dividerColor: Colors.transparent,
                                  indicatorColor: orangeColor,
                                  // Color of the selected tab indicator
                                  indicatorWeight: 4,
                                  // Thickness of the indicator
                                  indicatorSize: TabBarIndicatorSize.label,
                                  // Indicator under the label only
                                  tabs: [
                                    Tab(
                                        text: AppLocalizations.of(context)!
                                            .feeds),
                                    Tab(
                                        text: AppLocalizations.of(context)!
                                            .hoonar_star),
                                    Tab(
                                        text: AppLocalizations.of(context)!
                                            .drafts),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ValueListenableBuilder<ProfileSuccessModel?>(
                        valueListenable: authProvider.profileNotifier,
                        builder: (context, profile, child) {
                          if (profile == null) {
                            return GridShimmer();
                          } else if (profile.message ==
                              'Unauthorized Access!') {
                            Future.microtask(() {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  SlideRightRoute(page: LoginScreen()),
                                  (route) => false);
                            });
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              children: [
                                FeedScreen(
                                  controller: controller,
                                  feedsList: profile.data!.posts ?? [],
                                ),
                                HoonarStarScreen(
                                  controller: controller,
                                  hoonarStarList:
                                      profile.data!.hoonarStar ?? [],
                                ),
                                DraftsScreen(
                                  controller: controller,
                                  draftList: profile.data!.drafts ?? [],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget menuItemsWidget(bool isDarkMode) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      icon: Image.asset(
        'assets/images/menu.png',
        height: 30,
        width: 30,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.editProfile,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            // Handle item 1 tap
            Navigator.push(
                context, SlideRightRoute(page: const EditProfileScreen()));
          },
        ),
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.help,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            // Handle item 2 tap
            Navigator.push(context, SlideRightRoute(page: const HelpScreen()));
          },
        ),
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.termsConditions,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            // Handle item 3 tap
            Navigator.push(
                context,
                SlideRightRoute(
                    page: const AppContentScreen(
                  from: 'termsofuse',
                )));
          },
        ),
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.privacyPolicy,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            // Handle item 3 tap
            Navigator.push(
                context,
                SlideRightRoute(
                    page: const AppContentScreen(
                  from: 'privacy',
                )));
          },
        ),
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.manageDevices,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            // Handle item 3 tap
            Navigator.push(
                context, SlideRightRoute(page: const ManageDevicesScreen()));
          },
        ),
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.aboutApp,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            // Handle item 3 tap
            Navigator.push(
                context, SlideRightRoute(page: const AboutAppScreen()));
          },
        ),
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.logout,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            showLogoutDialog(context, isDarkMode);
          },
        ),
      ],
    );
  }

  void showLogoutDialog(BuildContext context, bool isDarkMode) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.logout,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.areYouSureLogout,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Provider.of<AuthProvider>(context, listen: false)
                      .isLogoutLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      AppLocalizations.of(context)!.logout,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                      ),
                    ),
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);

                await authProvider.logoutUser();

                if (authProvider.errorMessage != null) {
                  Navigator.of(context).pop();
                  SnackbarUtil.showSnackBar(
                      context, authProvider.errorMessage ?? '');
                } else {
                  if (authProvider.logoutSuccessModel?.successCode == '200') {
                    Navigator.of(context).pop();
                    sessionManager.clean().then((onValue) async {
                      Navigator.pushAndRemoveUntil(
                          context,
                          SlideRightRoute(page: const LoginScreen()),
                          (route) => false);
                    });
                  } else if (authProvider.logoutSuccessModel?.responseMessage ==
                      'Unauthorized Access!') {
                    Navigator.of(context).pop();
                    SnackbarUtil.showSnackBar(
                        context,
                        authProvider.logoutSuccessModel?.responseMessage! ??
                            '');
                    Navigator.pushAndRemoveUntil(
                        context,
                        SlideRightRoute(page: const LoginScreen()),
                        (route) => false);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class ProfileContentShimmer extends StatelessWidget {
  const ProfileContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Shimmer.fromColors(
        baseColor:
            myLoading.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        highlightColor:
            myLoading.isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: myLoading.isDark ? Colors.black : Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Container(
                width: 150,
                height: 15,
                decoration: BoxDecoration(
                  color: myLoading.isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Container(
                width: 100,
                height: 15,
                decoration: BoxDecoration(
                  color: myLoading.isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Container(
                  width: 250,
                  height: 15,
                  decoration: BoxDecoration(
                    color: myLoading.isDark ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  width: 220,
                  height: 15,
                  decoration: BoxDecoration(
                    color: myLoading.isDark ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  width: 240,
                  height: 15,
                  decoration: BoxDecoration(
                    color: myLoading.isDark ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: 40,
                      height: 15,
                      decoration: BoxDecoration(
                        color: myLoading.isDark ? Colors.black : Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: 100,
                      height: 15,
                      decoration: BoxDecoration(
                        color: myLoading.isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Colors.white, greyTextColor8],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: 40,
                      height: 15,
                      decoration: BoxDecoration(
                        color: myLoading.isDark ? Colors.black : Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: 100,
                      height: 15,
                      decoration: BoxDecoration(
                        color: myLoading.isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ],
        ),
      );
    });
  }
}
