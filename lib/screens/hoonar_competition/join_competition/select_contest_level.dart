import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/contest_join_success_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../model/star_category_model.dart';

class SelectContestLevel extends StatefulWidget {
  const SelectContestLevel({super.key});

  @override
  State<SelectContestLevel> createState() => _SelectContestLevelState();
}

class _SelectContestLevelState extends State<SelectContestLevel> {
  List<StarCategoryModel> zoneLevelsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      zoneLevelsList = [
        StarCategoryModel('', AppLocalizations.of(context)!.zone_leve, '1'),
        StarCategoryModel('', AppLocalizations.of(context)!.divisionLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.districtLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.stateLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.regionLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.stateLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.nationalLevel, '0'),
      ];
      setState(() {});
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
                  Image.asset(
                    myLoading.isDark
                        ? 'assets/dark_mode_icons/time_to_shine_dark.png'
                        : 'assets/light_mode_icons/time_to_shine_light.png',
                    scale: 1.5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.beAContestant,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: myLoading.isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: zoneLevelsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            showPaymentPopUp(context, myLoading.isDark, index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(myLoading.isDark
                                    ? 'assets/dark_mode_icons/level_back_dark.png'
                                    : 'assets/light_mode_icons/level_back_light.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      zoneLevelsList[index].name!,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          zoneLevelsList[index].darkModeImage ==
                                                  '1'
                                              ? (myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black)
                                              : myLoading.isDark
                                                  ? Colors.grey.shade900
                                                  : Colors.grey.shade700,
                                      // Background color
                                      shape: BoxShape.circle,
                                      // Makes the container circular
                                      border: Border.all(
                                          color: zoneLevelsList[index]
                                                      .darkModeImage ==
                                                  '1'
                                              ? Colors.transparent
                                              : (myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                          width: 1), // Optional border
                                    ),
                                    child: Icon(
                                      zoneLevelsList[index].darkModeImage == '1'
                                          ? Icons.lock_open
                                          : Icons.lock_outline,
                                      color:
                                          zoneLevelsList[index].darkModeImage ==
                                                  '1'
                                              ? (myLoading.isDark
                                                  ? Colors.black
                                                  : Colors.white)
                                              : (myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                      size: 22,
                                    ),
                                  )
                                ],
                              ),
                            ),
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
      );
    });
  }

  showPaymentPopUp(BuildContext context, bool isDarkMode, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: /* isDarkMode ? Colors.black : */ Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(45.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GradientText(
                AppLocalizations.of(context)!.zone_leve,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [Colors.black, Colors.black, Colors.grey.shade700]),
              ),
              Text(
                AppLocalizations.of(context)!.payNowToBecomeContestant,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Lorem ipsum odor amet, consectetuer adipiscing elit. Laoreet molestie convallis magna per aliquet conubia suspendisse. Egestas dignissim ridiculus fusce vulputate eros.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        '₹ 599/-',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        if (zoneLevelsList[index].darkModeImage == "1") {
                          zoneLevelsList[index].darkModeImage = "0";
                        } else {
                          zoneLevelsList[index].darkModeImage = "1";
                        }
                      });

                      Navigator.push(
                        context,
                        SlideRightRoute(page: ContestJoinSuccessScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.black,
                            Color(0xFF313131),
                            Color(0xFF636363)
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.payNow,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
