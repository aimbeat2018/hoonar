import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/session_manager.dart';

class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({super.key});

  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  ScrollController scrollController = ScrollController();
  SessionManager sessionManager = SessionManager();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

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
                    AppLocalizations.of(context)!.changeTheme,
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
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      myLoading.setDarkMode(true);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.darkMode,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        myLoading.isDark
                            ? Icon(
                                Icons.check_circle,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: myLoading.isDark ? Colors.white60 : Colors.grey,
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      myLoading.setDarkMode(false);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.lightMode,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        !myLoading.isDark
                            ? Icon(
                                Icons.check_circle,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                              )
                            : SizedBox()
                      ],
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
