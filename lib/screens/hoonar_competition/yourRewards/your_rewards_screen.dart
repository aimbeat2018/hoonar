import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/yourRewards/wallet_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../constants/theme.dart';
import '../../../../model/contestant.dart';
import 'add_bank_details_screen.dart';

class YourRewardsScreen extends StatefulWidget {
  const YourRewardsScreen({super.key});

  @override
  State<YourRewardsScreen> createState() => _YourRewardsScreenState();
}

class _YourRewardsScreenState extends State<YourRewardsScreen> {
  final rewardsList = [
    Contestant("assets/images/swiggy.png", 'Package Title',
        'Lorem ipsum dolor sit amet, '),
    Contestant("assets/images/zomato.png", 'Package Title',
        'Lorem ipsum dolor sit amet, '),
    Contestant("assets/images/swiggy.png", 'Package Title',
        'Lorem ipsum dolor sit amet, '),
    Contestant("assets/images/zomato.png", 'Package Title',
        'Lorem ipsum dolor sit amet, '),
  ];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 2 : 3;
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13),
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
                        Expanded(
                          child: Center(
                            child: GradientText(
                              AppLocalizations.of(context)!.rewards,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: myLoading.isDark
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
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
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: menuItemsWidget(myLoading.isDark))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio:
                            0.9, // Adjust according to image dimensions
                      ),
                      itemCount: rewardsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(rewardsList[index].rank),
                                fit: BoxFit.cover,
                              ),
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      rewardsList[index].rank,
                                      scale: 2,
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  rewardsList[index].name,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    rewardsList[index].votes,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white),
                                  child: Text(
                                    AppLocalizations.of(context)!.claimNow,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget menuItemsWidget(bool isDarkMode) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      icon: Image.asset(
        'assets/images/menu.png',
        height: 30,
        width: 30,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.addBankDetails,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              SlideRightRoute(page: AddBankDetailsScreen()),
            );
          },
        ),
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.wallet,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              SlideRightRoute(page: WalletScreen()),
            );
          },
        ),
      ],
    );
  }
}
