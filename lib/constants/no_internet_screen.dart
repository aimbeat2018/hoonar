import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/internet_connectivity.dart';
import 'package:hoonar/constants/key_res.dart';
import 'package:provider/provider.dart';

import 'my_loading/my_loading.dart';

class NoInternetScreen extends StatefulWidget {
  final Function? onTapRetry;

  const NoInternetScreen({Key? key, this.onTapRetry}) : super(key: key);

  @override
  NoInternetScreenState createState() => NoInternetScreenState();
}

class NoInternetScreenState extends State<NoInternetScreen> {
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        child: _connectionStatus == KeyRes.connectivityCheck
            ? const NoInternetScreen()
            : Scaffold(
                backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
                body: Container(
                  margin: EdgeInsetsDirectional.only(
                      start: width / 10.0,
                      end: width / 10.0,
                      top: height / 5.0),
                  width: width,
                  child: Column(children: [
                    Image.asset(
                      "assets/images/no_internet.png",
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: height / 20.0),
                    Text(
                      'whoops',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 26,
                          fontWeight: FontWeight.w700),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                        'Could not connect to the internet. please check your network.',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: GoogleFonts.inter(
                            color: myLoading.isDark?Colors.white:Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    InkWell(
                        onTap: () {
                          setState(() {});
                          Future.delayed(const Duration(seconds: 3), () {
                            CheckInternet.initConnectivity();
                            setState(() {});
                          });
                        },
                        child: Container(
                            margin:
                                EdgeInsetsDirectional.only(top: height / 10.0),
                            padding: EdgeInsetsDirectional.only(
                                top: height / 70.0,
                                bottom: 10.0,
                                start: width / 20.0,
                                end: width / 20.0),
                            decoration: BoxDecoration(
                              color: orangeColor,
                              border: Border.all(color: orangeColor),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Text("Try again",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)))),
                  ]),
                )),
      );
    });
  }
}
