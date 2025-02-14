import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/draft_video_list_Screen.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/your_feed_video_list_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/internet_connectivity.dart';
import '../../../../constants/key_res.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/no_internet_screen.dart';

class UploadVideoOptionsScreen extends StatefulWidget {
  const UploadVideoOptionsScreen({super.key});

  @override
  State<UploadVideoOptionsScreen> createState() =>
      _UploadVideoOptionsScreenState();
}

class _UploadVideoOptionsScreenState extends State<UploadVideoOptionsScreen> {
  int currentTab = 0;
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  void changeTabPosition(int pos) {
    setState(() {
      currentTab = pos;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
                                        AppLocalizations.of(context)!.drafts,
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
                            ? const DraftVideoListScreen()
                            : const YourFeedVideoListScreen(
                                from: 'upload',
                              ),
                      )
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
