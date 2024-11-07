import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/contest_join_options_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';

class ContestJoinSuccessScreen extends StatefulWidget {
  const ContestJoinSuccessScreen({super.key});

  @override
  State<ContestJoinSuccessScreen> createState() =>
      _ContestJoinSuccessScreenState();
}

class _ContestJoinSuccessScreenState extends State<ContestJoinSuccessScreen> {
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
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 30),
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
                          color: myLoading.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: GradientText(
                      AppLocalizations.of(context)!.congratulations,
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50.0, horizontal: 20),
                    child: Center(
                      child: Image.asset(
                        'assets/images/capture.gif',
                        // Replace with your URL
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      SlideRightRoute(page: const ContestJoinOptionsScreen()),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.only(
                          top: 15, left: 60, right: 60, bottom: 5),
                      decoration: ShapeDecoration(
                        color: myLoading.isDark ? Colors.white : Colors.black,
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
                          color: myLoading.isDark ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
