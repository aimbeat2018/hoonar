import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/contest_join_options_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/slide_right_route.dart';

class ContestJoinSuccessScreen extends StatefulWidget {
  final int? categoryId;
  final String? levelId;

  const ContestJoinSuccessScreen({super.key, this.categoryId, this.levelId});

  @override
  State<ContestJoinSuccessScreen> createState() =>
      _ContestJoinSuccessScreenState();
}

class _ContestJoinSuccessScreenState extends State<ContestJoinSuccessScreen> {
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Center(
                            child: Image.asset(
                              // 'assets/images/capture.gif',
                              'assets/images/congrats.gif',
                              // Replace with your URL
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Center(
                          //   child: GradientText(
                          //     AppLocalizations.of(context)!.congratulations,
                          //     style: GoogleFonts.poppins(
                          //       fontSize: 20,
                          //       color: myLoading.isDark
                          //           ? Colors.black
                          //           : Colors.white,
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //     gradient: LinearGradient(
                          //         begin: Alignment.topLeft,
                          //         end: Alignment.topRight,
                          //         colors: [
                          //           myLoading.isDark
                          //               ? Colors.white
                          //               : Colors.black,
                          //           myLoading.isDark
                          //               ? Colors.white
                          //               : Colors.black,
                          //           myLoading.isDark
                          //               ? greyTextColor8
                          //               : Colors.grey.shade700
                          //         ]),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          /*Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 50.0, horizontal: 0),
                            child: Center(
                              child: Image.asset(
                                // 'assets/images/capture.gif',
                                'assets/images/congrats.gif',
                                // Replace with your URL
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),*/
                          /* InkWell(
                            onTap: () => Navigator.push(
                                context,
                                SlideRightRoute(
                                    page: ContestJoinOptionsScreen(
                                  levelId: widget.levelId,
                                  categoryId: widget.categoryId,
                                ))),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              margin: const EdgeInsets.only(
                                  top: 15, left: 60, right: 60, bottom: 5),
                              decoration: ShapeDecoration(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    strokeAlign:
                                        BorderSide.strokeAlignOutside,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.letsGo,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: myLoading.isDark
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              SlideRightRoute(
                                  page: ContestJoinOptionsScreen(
                                levelId: widget.levelId,
                                categoryId: widget.categoryId,
                              ))),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            margin: const EdgeInsets.only(
                                top: 15, left: 60, right: 60, bottom: 5),
                            decoration: ShapeDecoration(
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(80),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.letsGo,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
