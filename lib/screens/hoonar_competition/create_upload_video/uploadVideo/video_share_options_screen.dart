import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/key_res.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/draft_video_list_Screen.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/hoonar_star_video_list_screen.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/your_feed_video_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/session_manager.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../custom/snackbar_util.dart';
import '../../../../model/request_model/common_request_model.dart';
import '../../../../providers/contest_provider.dart';
import '../../../auth_screen/login_screen.dart';

class VideoShareOptionsScreen extends StatefulWidget {
  const VideoShareOptionsScreen({super.key});

  @override
  State<VideoShareOptionsScreen> createState() =>
      _VideoShareOptionsScreenState();
}

class _VideoShareOptionsScreenState extends State<VideoShareOptionsScreen> {
  int currentTab = 0;

  void changeTabPosition(int pos) {
    setState(() {
      currentTab = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(myLoading.isDark
                  ? 'assets/images/screens_back.png'
                  : 'assets/dark_mode_icons/white_screen_back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 85,
                      padding: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(currentTab == 0
                              ? 'assets/images/hoonar_star_tab.png'
                              : 'assets/images/leader_board_tab.png'),
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
                                  AppLocalizations.of(context)!.hoonarStar,
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
                                  AppLocalizations.of(context)!.yourFeed,
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
                        ],
                      ),
                    ),
                    Positioned(
                        top: 10,
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
                      ? HoonarStarVideoListScreen()
                      : YourFeedVideoListScreen(from: 'share',),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
