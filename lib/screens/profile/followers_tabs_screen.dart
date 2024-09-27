import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/widget/followers_screen.dart';
import 'package:hoonar/screens/profile/widget/following_screen.dart';
import 'package:hoonar/screens/profile/widget/votes_screen.dart';

import '../../constants/text_constants.dart';

class FollowersTabScreen extends StatefulWidget {
  final int? currentTabFrom;

  const FollowersTabScreen({super.key, this.currentTabFrom});

  @override
  State<FollowersTabScreen> createState() => _FollowersTabScreenState();
}

class _FollowersTabScreenState extends State<FollowersTabScreen>
    with SingleTickerProviderStateMixin {
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    currentTab = widget.currentTabFrom ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF373737),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              /*image: DecorationImage(
              image: AssetImage('assets/images/screens_back.png'),
              // Path to your image
              fit:
                  BoxFit.cover, // Ensures the image covers the entire container
            ),*/
              color: Colors.black),
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
                                followers,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white,
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
                                votes,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white,
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
                                following,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white,
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
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: currentTab == 0
                        ? Text(
                            '1244 $followers',
                            textAlign: TextAlign.end,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : currentTab == 2
                            ? Text(
                                '124 $following',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : SizedBox(),
                  )),
              Expanded(
                child: currentTab == 0
                    ? FollowersScreen()
                    : currentTab == 1
                        ? VotesScreen()
                        : FollowingScreen(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeTabPosition(int pos) {
    setState(() {
      currentTab = pos;
    });
  }
}
