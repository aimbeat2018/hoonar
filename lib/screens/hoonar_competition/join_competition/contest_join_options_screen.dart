import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/competitionHub/competition_hub_screen.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/create_upload_options_screen.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/select_contest_level.dart';
import 'package:provider/provider.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../model/star_category_model.dart';

class ContestJoinOptionsScreen extends StatefulWidget {
  const ContestJoinOptionsScreen({super.key});

  @override
  State<ContestJoinOptionsScreen> createState() =>
      _ContestJoinOptionsScreenState();
}

class _ContestJoinOptionsScreenState extends State<ContestJoinOptionsScreen> {
  List<StarCategoryModel> optionsList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      optionsList = [
        StarCategoryModel(
            'assets/light_mode_icons/create_upload_light.png',
            AppLocalizations.of(context)!.createAndUpload,
            'assets/dark_mode_icons/create_upload.png'),
        StarCategoryModel(
            'assets/light_mode_icons/hub_light.png',
            AppLocalizations.of(context)!.competitionHub,
            'assets/dark_mode_icons/hub_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/news_events_light.png',
            AppLocalizations.of(context)!.news_events,
            'assets/dark_mode_icons/news_event_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/rewards_light.png',
            AppLocalizations.of(context)!.rewards,
            'assets/dark_mode_icons/reward_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/guidelines_light.png',
            AppLocalizations.of(context)!.guidelines,
            'assets/dark_mode_icons/guidelines_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/documents_light.png',
            AppLocalizations.of(context)!.documents,
            'assets/dark_mode_icons/documents.png'),
      ];
      setState(() {});
    });
  }

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
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 30, bottom: 30),
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 15,
                      childAspectRatio:
                          1.1, // Adjust according to image dimensions
                    ),
                    itemCount: optionsList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.push(
                              context,
                              SlideRightRoute(
                                  page: CreateUploadOptionsScreen()),
                            );
                          } else if (index == 1) {
                            Navigator.push(
                              context,
                              SlideRightRoute(page: CompetitionHubScreen()),
                            );
                          }
                        },
                        child: Card(
                          elevation: 5,
                          shadowColor: myLoading.isDark
                              ? const Color(0xFF3F3F3F)
                              : Color(0x153F3F3F),
                          color: myLoading.isDark
                              ? const Color(0xFF3F3F3F)
                              : Color(0x153F3F3F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                myLoading.isDark
                                    ? optionsList[index].darkModeImage!
                                    : optionsList[index].lightModeImage!,
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                optionsList[index].name!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
      );
    });
  }
}
