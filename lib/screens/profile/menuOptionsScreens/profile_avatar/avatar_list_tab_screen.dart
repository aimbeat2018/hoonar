import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/profile_avatar/avatar_list_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/my_loading/my_loading.dart';
import '../../../../providers/user_provider.dart';
import '../../widget/followers_screen.dart';
import '../../widget/following_screen.dart';
import '../../widget/votes_screen.dart';

class AvatarListTabScreen extends StatefulWidget {
  const AvatarListTabScreen({super.key});

  @override
  State<AvatarListTabScreen> createState() => _AvatarListTabScreenState();
}

class _AvatarListTabScreenState extends State<AvatarListTabScreen> {
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Color(0xFF373737) : Colors.white,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                /*image: DecorationImage(
                  image: AssetImage('assets/images/screens_back.png'),
                  // Path to your image
                  fit:
                      BoxFit.cover, // Ensures the image covers the entire container
                ),*/
                color: myLoading.isDark ? Colors.black : Colors.white),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 83,
                      padding: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(currentTab == 0
                              ? 'assets/images/tab1.png'
                              : currentTab == 1
                                  ? 'assets/images/tab2.png'
                                  : 'assets/images/tab3.png'),
                          // Path to your image
                          fit: BoxFit
                              .cover, // Ensures the image covers the entire container
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                changeTabPosition(0);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  AppLocalizations.of(context)!.male,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : currentTab == 0
                                            ? Colors.black
                                            : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                changeTabPosition(1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  AppLocalizations.of(context)!.female,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : currentTab == 1
                                            ? Colors.black
                                            : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                changeTabPosition(2);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  AppLocalizations.of(context)!.other,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : currentTab == 2
                                            ? Colors.black
                                            : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 5,
                        left: 15,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/images/back_image.png',
                            height: 25,
                            width: 25,
                          ),
                        ))
                  ],
                ),
                Expanded(
                  child: currentTab == 0
                      ? AvatarListScreen(
                          key: ValueKey("male"), // Unique key for each type
                          type: "male",
                        )
                      : currentTab == 1
                          ? AvatarListScreen(
                              key: ValueKey(
                                  "female"), // Unique key for each type
                              type: "female",
                            )
                          : AvatarListScreen(
                              key:
                                  ValueKey("other"), // Unique key for each type
                              type: "other",
                            ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  void changeTabPosition(int pos) {
    setState(() {
      currentTab = pos;
    });
  }
}
