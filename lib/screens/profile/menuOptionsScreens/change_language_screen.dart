import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hoonar/constants/my_loading/my_loading.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/const_res.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/theme.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  ScrollController scrollController = ScrollController();
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
              body: Container(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    /*image: DecorationImage(
            image: AssetImage('assets/images/screens_back.png'),
            // Path to your image
            fit: BoxFit.cover, // Ensures the image covers the entire container
          ),*/
                    color: myLoading.isDark ? Colors.black : Colors.white),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildAppbar(context, myLoading.isDark),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: GradientText(
                        AppLocalizations.of(context)!.languageSubTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: myLoading.isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [
                              myLoading.isDark ? Colors.white : Colors.black,
                              myLoading.isDark ? Colors.white : Colors.black,
                              greyTextColor8
                            ]),
                      )),
                      ListView.separated(
                        itemCount: languages.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        shrinkWrap: true,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          // Access each language from the list
                          final language = languages[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              language['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              language['subHeading'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: myLoading.isDark
                                    ? Colors.white60
                                    : Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              myLoading.setLanguageCode(index, context);
                              setState(() {});
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                              thickness: 0.5,
                              color: myLoading.isDark
                                  ? Colors.white60
                                  : Colors.grey);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
