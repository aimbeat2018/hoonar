import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../yourRewards/your_rewards_screen.dart';

class YourRankScreen extends StatefulWidget {
  const YourRankScreen({super.key});

  @override
  State<YourRankScreen> createState() => _YourRankScreenState();
}

class _YourRankScreenState extends State<YourRankScreen> {
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 10, bottom: 20),
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
                Center(
                  child: GradientText(
                    AppLocalizations.of(context)!.yourRank,
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

                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      margin: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 28),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(myLoading.isDark
                                  ? 'assets/dark_mode_icons/your_rank_back_dark.png'
                                  : 'assets/light_mode_icons/your_rank_back_light.png'),
                              fit: BoxFit.fill)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Prathamesh Santosh Gaikar',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.category} : Dance',
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            AppLocalizations.of(context)!.rank,
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '32579',
                            style: GoogleFonts.poppins(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.level} : ${AppLocalizations.of(context)!.zone_leve}',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.congratulations,
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: orangeColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideRightRoute(page: const YourRewardsScreen()),
                    );
                  },
                  child: Hero(
                    tag: 'your_rank',
                    child: IntrinsicHeight(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: contBlueColor1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/reward.png',
                              height: 28,
                              width: 28,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.yourRewards,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
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
