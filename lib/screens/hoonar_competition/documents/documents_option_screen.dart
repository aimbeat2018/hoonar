import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/documents/kyc_screen.dart';
import 'package:hoonar/screens/hoonar_competition/documents/upload_documents_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/common_request_model.dart';
import '../../../model/star_category_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';

class DocumentsOptionScreen extends StatefulWidget {
  const DocumentsOptionScreen({super.key});

  @override
  State<DocumentsOptionScreen> createState() => _DocumentsOptionScreenState();
}

class _DocumentsOptionScreenState extends State<DocumentsOptionScreen> {
  List<StarCategoryModel> optionsList = [];
  SessionManager sessionManager = SessionManager();
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
      optionsList = [
        StarCategoryModel(
            'assets/light_mode_icons/upload_documents_light.png',
            AppLocalizations.of(context)!.uploadDocuments,
            'assets/dark_mode_icons/upload_documents_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/kyc_light.png',
            AppLocalizations.of(context)!.kyc,
            'assets/dark_mode_icons/kyc_dark.png'),
      ];
      setState(() {});

      getKycStatus(context, CommonRequestModel());
    });
  }

  Future<void> getKycStatus(
      BuildContext context, CommonRequestModel requestModel) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    try {
      sessionManager.initPref().then((onValue) async {
        await contestProvider.getKycStatus(requestModel,
            sessionManager.getString(SessionManager.accessToken) ?? '');

        if (contestProvider.errorMessage != null) {
          SnackbarUtil.showSnackBar(
              context, contestProvider.errorMessage ?? '');
        } else if (contestProvider.kycStatusModel?.status == '200') {
        } else if (contestProvider.kycStatusModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.kycStatusModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      });
    } finally {}
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
            content: Text(
              AppLocalizations.of(context)!.kycApprovedMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: myLoading.isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
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
                onPressed: () async {
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
    int crossAxisCount = screenWidth < 600 ? 2 : 3;

    final contestProvider = Provider.of<ContestProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
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
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 10, bottom: 0),
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
                        Center(
                            child: GradientText(
                          AppLocalizations.of(context)!.documentsAndKyc,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color:
                                myLoading.isDark ? Colors.black : Colors.white,
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
                        )),
                        SizedBox(
                          height: 30,
                        ),
                        ValueListenableBuilder<int?>(
                            valueListenable:
                                contestProvider.userKycStatusNotifier,
                            builder: (context, userKycStatus, child) {
                              return Column(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 25,
                                      mainAxisSpacing: 20,
                                      childAspectRatio:
                                          1.1, // Adjust according to image dimensions
                                    ),
                                    itemCount: optionsList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          /*  if (userKycStatus == 1) {
                                      showInfoDialog(context);
                                    } else {*/
                                          if (index == 0) {
                                            Navigator.push(
                                              context,
                                              SlideRightRoute(
                                                  page:
                                                      UploadDocumentsScreen()),
                                            );
                                          } else if (index == 1) {
                                            Navigator.push(
                                              context,
                                              SlideRightRoute(
                                                  page: KycScreen()),
                                            );
                                          }
                                          // }
                                        },
                                        child: Card(
                                          elevation: 5,
                                          shadowColor: userKycStatus == 0 ||
                                                  userKycStatus == 2
                                              ? (myLoading.isDark
                                                  ? const Color(0xFF3F3F3F)
                                                  : /*Color(0x153F3F3F)*/ Colors
                                                      .white)
                                              : (myLoading.isDark
                                                  ? const Color(0xFF3F3F3F)
                                                  : /* Color(0x153F3F3F)*/ Colors
                                                      .white),
                                          color: userKycStatus == 0 ||
                                                  userKycStatus == 2
                                              ? (myLoading.isDark
                                                  ? Colors.grey.shade700
                                                  : Colors.grey.shade500)
                                              : (myLoading.isDark
                                                  ? const Color(0xFF3F3F3F)
                                                  : /*Color(0x153F3F3F)*/ Colors
                                                      .white),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                myLoading.isDark
                                                    ? optionsList[index]
                                                        .darkModeImage!
                                                    : optionsList[index]
                                                        .lightModeImage!,
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
                                  SizedBox(
                                    height: 50,
                                  ),
                                  userKycStatus == 1
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .kycApprovedMessage,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : userKycStatus == 2
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .kycRejectedMessage,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          : SizedBox()
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
