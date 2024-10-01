import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/screens/profile/drafts_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/about_app_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/app_content_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/edit_profile_screen.dart';
import 'package:hoonar/screens/profile/feed_screen.dart';
import 'package:hoonar/screens/profile/followers_tabs_screen.dart';
import 'package:hoonar/screens/profile/hoonar_star_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/help_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/manage_devices_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';

class ProfileScreen extends StatefulWidget {
  final String from;

  const ProfileScreen({super.key, required this.from});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isVisible = false;
  List<String> optionsList = [
    editProfile,
    help,
    termsConditions,
    privacyPolicy,
    manageDevices,
    aboutApp,
    'logout'
  ];

  // Toggles both the fade and scale animation
  void _toggleAnimation() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Stack(
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
                                                const EdgeInsets.only(left: 13),
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
                                    double avatarSize = constraints.maxWidth <
                                            constraints.maxHeight
                                        ? constraints.maxWidth
                                        : constraints.maxHeight;

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
                                              // Set the radius based on available size
                                              backgroundImage:
                                                  const NetworkImage(
                                                'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Hitesh Male',
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
                                            '@hitesh.m',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  right: 5,
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: menuItemsWidget(myLoading.isDark)),
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3),
                                child: Text(
                                  'About You',
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
                                        '2.6K',
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
                                        AppLocalizations.of(context)!.followers,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: orangeColor,
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
                                        borderRadius: BorderRadius.circular(8),
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
                                        '1.6K',
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
                                        AppLocalizations.of(context)!.following,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: orangeColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
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
                                      text:
                                          AppLocalizations.of(context)!.feeds),
                                  Tab(
                                      text: AppLocalizations.of(context)!
                                          .hoonar_star),
                                  Tab(
                                      text:
                                          AppLocalizations.of(context)!.drafts),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // menu options layout
                        Positioned(
                          top: 25,
                          right: 10,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            width: _isVisible ? optionsList.length * 30.0 : 0,
                            // Adjust this as needed
                            height: _isVisible ? optionsList.length * 70.0 : 0,
                            // Adjust height based on number of options
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                shrinkWrap: true,
                                itemCount: optionsList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      // setState(() {
                                      //   selectedCategory = optionsList[index];
                                      // });
                                      _toggleAnimation();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        optionsList[index],
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        children: [
                          FeedScreen(
                            controller: controller,
                          ),
                          HoonarStarScreen(
                            controller: controller,
                          ),
                          DraftsScreen(
                            controller: controller,
                          ),
                        ],
                      ),
                    ),
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
                  from: 'terms',
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
            // Handle item 3 tap
          },
        ),
      ],
    );
  }
}
