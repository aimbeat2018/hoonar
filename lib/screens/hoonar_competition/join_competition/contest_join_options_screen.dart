import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/competitionHub/competition_hub_screen.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/create_upload_options_screen.dart';
import 'package:hoonar/screens/hoonar_competition/documents/documents_option_screen.dart';
import 'package:hoonar/screens/hoonar_competition/documents/upload_documents_screen.dart';
import 'package:hoonar/screens/hoonar_competition/guideline/guideline_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/star_category_model.dart';
import '../../../providers/setting_provider.dart';
import '../../auth_screen/login_screen.dart';
import '../newsEvents/news_and_events_screen.dart';
import '../yourRewards/your_rewards_screen.dart';

class ContestJoinOptionsScreen extends StatefulWidget {
  final int? categoryId;
  final String? levelId;

  const ContestJoinOptionsScreen({super.key, this.categoryId, this.levelId});

  @override
  State<ContestJoinOptionsScreen> createState() =>
      _ContestJoinOptionsScreenState();
}

class _ContestJoinOptionsScreenState extends State<ContestJoinOptionsScreen> {
  List<StarCategoryModel> optionsList = [];
  SessionManager sessionManager = SessionManager();
  String mobileNumber = "", emailId = "";
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getContactData(context);
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

  Future<void> getContactData(BuildContext context) async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      await settingProvider.getContactDetails(
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (settingProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, settingProvider.errorMessage ?? '');
      } else {
        if (settingProvider.contactDetailsModel?.status == '200') {
          if (settingProvider.contactDetailsModel != null) {
            if (settingProvider.contactDetailsModel!.data != null) {
              mobileNumber =
                  settingProvider.contactDetailsModel!.data!.helpContact ?? '';
              emailId =
                  settingProvider.contactDetailsModel!.data!.helpMail ?? '';
            }
          }
        } else if (settingProvider.contactDetailsModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, settingProvider.contactDetailsModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  void showInfoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<MyLoading>(builder: (context, myLoading, child) {
          return CupertinoAlertDialog(
            title: Text(
              AppLocalizations.of(context)!.alert.toUpperCase(),
              style: GoogleFonts.poppins(
                color: myLoading.isDark ? Colors.white : Colors.black,
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    color: myLoading.isDark ? Colors.white70 : Colors.black87,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.emailUsOn(''),
                    ),
                    TextSpan(
                      text: ' $emailId', // Replace with your email
                      style: GoogleFonts.poppins(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: emailId, // Replace with your email
                          );
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri);
                          } else {
                            // Handle the error if the email app can't open
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Could not launch email app')),
                            );
                          }
                        },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  AppLocalizations.of(context)!.okay,
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 2 : 3;

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: TextButton(
                onPressed: () {
                  showInfoDialog(context);
                },
                style: TextButton.styleFrom(
                  shape: const CircleBorder(),
                  // Circular shape
                  backgroundColor:
                      myLoading.isDark ? Colors.grey.shade200 : Colors.black,
                  // Background color
                  padding: const EdgeInsets.all(
                      10), // Padding for a balanced circular button
                ),
                child: Icon(
                  Icons.question_mark_sharp,
                  color: myLoading.isDark ? Colors.black : Colors.white,
                ),
              ),

              /*InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  colors: [
                    myLoading.isDark ? greyTextColor5 : greyTextColor5,
                    myLoading.isDark ? greyTextColor6 : greyTextColor6,
                    myLoading.isDark ? greyTextColor5 : greyTextColor5,
                  ],
                ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                  blurRadius: 10, // Blur effect
                  offset: Offset(0, 4), // Horizontal and vertical offsets
                ),
              ],),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Contact Us',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),*/

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
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 30, bottom: 30),
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
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                        page:
                                            const CreateUploadOptionsScreen()),
                                  );
                                } else if (index == 1) {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: CompetitionHubScreen(
                                      levelId: widget.levelId,
                                      categoryId: widget.categoryId,
                                    )),
                                  );
                                } else if (index == 2) {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const NewsAndEventsScreen()),
                                  );
                                } else if (index == 3) {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const YourRewardsScreen()),
                                  );
                                } else if (index == 4) {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const GuidelineScreen()),
                                  );
                                } else if (index == 5) {
                                 /* Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const DocumentsOptionScreen()),
                                  );*/

                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const UploadDocumentsScreen()),
                                  );
                                }
                              },
                              child: Card(
                                elevation: 5,
                                shadowColor: myLoading.isDark
                                    ? const Color(0xFF3F3F3F)
                                    : /* Color(0x153F3F3F)*/ Colors.white,
                                color: myLoading.isDark
                                    ? const Color(0xFF3F3F3F)
                                    : /*Color(0x153F3F3F)*/ Colors.white,
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
                                    const SizedBox(
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
