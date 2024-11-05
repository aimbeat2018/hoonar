import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/text_constants.dart';
import '../../../constants/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppContentScreen extends StatefulWidget {
  final String? from;

  const AppContentScreen({super.key, this.from});

  @override
  State<AppContentScreen> createState() => _AppContentScreenState();
}

class _AppContentScreenState extends State<AppContentScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
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
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            thickness: 2.5,
            radius: const Radius.circular(10),
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
                      widget.from == 'terms'
                          ? AppLocalizations.of(context)!.termsConditions
                          : AppLocalizations.of(context)!.privacyPolicy,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: myLoading.isDark ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [
                            myLoading.isDark ? Colors.white : Colors.black,
                            myLoading.isDark ? Colors.white : Colors.black,
                            myLoading.isDark
                                ? greyTextColor8
                                : Colors.grey.shade700
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Html(
                      data:
                          '<b>Lorem ipsum dolor sit amet, consectetur adipiscing elit</b><tr></tr> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."',
                      style: {
                        "body": Style(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black),
                      })
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
