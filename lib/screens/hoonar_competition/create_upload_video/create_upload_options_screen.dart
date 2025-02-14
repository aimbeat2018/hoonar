import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/key_res.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/success_models/upload_video_status_model.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/video_share_options_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/star_category_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';
import '../../camera/capture_video_screen.dart';
import '../../camera/sounds/select_sound_list_screen.dart';
import '../../camera/video_preview_screen.dart';

class CreateUploadOptionsScreen extends StatefulWidget {
  const CreateUploadOptionsScreen({super.key});

  @override
  State<CreateUploadOptionsScreen> createState() =>
      _CreateUploadOptionsScreenState();
}

class _CreateUploadOptionsScreenState extends State<CreateUploadOptionsScreen> {
  List<StarCategoryModel> optionsList = [];
  File? _videoFile;
  SessionManager sessionManager = SessionManager();
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /*---- kyc check-----*/
  int? isVerified;
  int? iDProof;
  int? addressProof;
  int? face;

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
        /*   StarCategoryModel(
            'assets/light_mode_icons/upload_video_light.png',
            AppLocalizations.of(context)!.uploadVideo,
            'assets/dark_mode_icons/upload_video.png'),*/

        StarCategoryModel(
            'assets/light_mode_icons/create_video_light.png',
            AppLocalizations.of(context)!.createAndUpload,
            'assets/dark_mode_icons/create_video_dark.png'),
        /*StarCategoryModel(
            'assets/light_mode_icons/gallery_light.png',
            AppLocalizations.of(context)!.gallery,
            'assets/dark_mode_icons/gallery_dark.png'),
*/
        /* StarCategoryModel(
            'assets/light_mode_icons/edit_video_light.png',
            AppLocalizations.of(context)!.editVideo,
            'assets/dark_mode_icons/edit_video_dark.png'),*/
        StarCategoryModel(
            'assets/light_mode_icons/music_library_light.png',
            AppLocalizations.of(context)!.musicLibrary,
            'assets/dark_mode_icons/music_library_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/connect_share_light.png',
            AppLocalizations.of(context)!.connectShare,
            'assets/dark_mode_icons/connect_share_dark.png'),
      ];
      if (mounted) {
        setState(() {});
      }
      getKycStatus(context, CommonRequestModel());
      getUploadVideoStatus(context);
      showInfoDialog(context);
    });
  }

  Future<void> getUploadVideoStatus(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel =
          CommonRequestModel(levelId: KeyRes.selectedLevelId.toString());

      await contestProvider.uploadVideoStatus(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.uploadVideoStatusModel?.status == '200') {
        } else if (contestProvider.uploadVideoStatusModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.uploadVideoStatusModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
    setState(() {});
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
          setState(() {
            isVerified = contestProvider.kycStatusModel!.data!.isVerified;
            iDProof = contestProvider.kycStatusModel!.data!.iDProof;
            addressProof = contestProvider.kycStatusModel!.data!.addressProof;
            face = contestProvider.kycStatusModel!.data!.face;
          });
        } else if (contestProvider.kycStatusModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.kycStatusModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        } else {
          SnackbarUtil.showSnackBar(
              context, contestProvider.kycStatusModel?.message! ?? '');
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
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.instructions,
                style: GoogleFonts.poppins(
                  color: myLoading.isDark ? Colors.white70 : Colors.black87,
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

/*  void showKycDialog(BuildContext context) {
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
              child: Text(
                AppLocalizations.of(context)!.instructions,
                style: GoogleFonts.poppins(
                  color: myLoading.isDark ? Colors.white70 : Colors.black87,
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
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }*/

  void checkKYCStatus(
      BuildContext context, int? iDProof, int? addressProof, int? face) {
    String title = "KYC Status";
    List<String> pending = [];
    List<String> rejected = [];

    // Identify pending and rejected KYC sections
    if (iDProof == 3) pending.add("ID Proof");
    if (addressProof == 3) pending.add("Address Proof");
    if (face == 3) pending.add("Face Verification");

    if (iDProof == 2) rejected.add("ID Proof");
    if (addressProof == 2) rejected.add("Address Proof");
    if (face == 2) rejected.add("Face Verification");

    String message = "";

    if (pending.isNotEmpty) {
      message += "Your KYC is pending for: ${pending.join(", ")}.\n\n"
          "Please submit the required documents to complete verification.\n\n";
    }

    if (rejected.isNotEmpty) {
      message += "Your KYC verification failed for: ${rejected.join(", ")}.\n\n"
          "Please re-upload the correct documents to proceed.\n\n";
    }

    if (message.isEmpty) {
      message = "Congratulations! Your KYC has been successfully approved.";
    }

    // Show CupertinoDialog with styled text
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                "OK",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void showCompetitionDateDialog(
      BuildContext context, UploadVideoStatusData model) {
    DateTime startDate = DateFormat('yyyy-MM-dd').parse(model.uploadStartDate!);
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);

    DateTime endDate = DateFormat('yyyy-MM-dd').parse(model.uploadEndDate!);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);

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
              AppLocalizations.of(context)!
                  .uploadVideoMsg(formattedEndDate, formattedStartDate),
              style: GoogleFonts.poppins(
                color: myLoading.isDark ? Colors.white70 : Colors.black87,
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

  Future<void> getVideoDuration(File filePath) async {
    final controller = VideoPlayerController.file(filePath); // For assets
    // or use controller = VideoPlayerController.file(File(filePath)); for file path
    await controller.initialize();
    Duration duration = controller.value.duration;
    print("Video Duration: $duration");
    controller.dispose();

    _goToPreviewScreen(filePath, duration.inSeconds.toString());
  }

  Future<void> _selectVideoFromGallery() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
      print('Selected video: ${_videoFile!.path}');

      getVideoDuration(_videoFile!);
    }
  }

  void _goToPreviewScreen(File mergedFile, String duration) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          videoFile: mergedFile,
          selectedMusic: null,
          duration: duration,
          from: "level",
        ),
      ),
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
                              left: 15.0, top: 10, bottom: 30),
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
                          AppLocalizations.of(context)!.createAndUpload,
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
                        const SizedBox(
                          height: 30,
                        ),
                        // GridView.builder(
                        //   shrinkWrap: true,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   padding: const EdgeInsets.symmetric(horizontal: 25),
                        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: crossAxisCount,
                        //     crossAxisSpacing: 25,
                        //     mainAxisSpacing: 20,
                        //     childAspectRatio:
                        //         1.1, // Adjust according to image dimensions
                        //   ),
                        //   itemCount: optionsList.length,
                        //   itemBuilder: (context, index) {
                        //     return InkWell(
                        //       onTap: () {
                        //         if (index == 0) {
                        //           /*  Navigator.push(
                        //             context,
                        //             SlideRightRoute(page: UploadVideoOptionsScreen()),
                        //           );*/
                        //           if (contestProvider.uploadVideoStatusModel !=
                        //                   null &&
                        //               contestProvider
                        //                       .uploadVideoStatusModel!.status ==
                        //                   "200") {
                        //             Navigator.push(
                        //               context,
                        //               SlideRightRoute(
                        //                   page: const CaptureVideoScreen(
                        //                 from: "level",
                        //               )),
                        //             );
                        //           } else {
                        //             showCompetitionDateDialog(
                        //                 context,
                        //                 contestProvider
                        //                     .uploadVideoStatusModel!.data!);
                        //           }
                        //         } else if (index == 1) {
                        //           if (contestProvider.uploadVideoStatusModel !=
                        //                   null &&
                        //               contestProvider
                        //                       .uploadVideoStatusModel!.status ==
                        //                   "200") {
                        //             _selectVideoFromGallery();
                        //           } else {
                        //             showCompetitionDateDialog(
                        //                 context,
                        //                 contestProvider
                        //                     .uploadVideoStatusModel!.data!);
                        //           }
                        //         }
                        //         /*else if (index == 2) {
                        //           Navigator.push(
                        //             context,
                        //             SlideRightRoute(
                        //                 page: const CaptureVideoScreen(
                        //               from: "level",
                        //             )),
                        //           );
                        //         } else if (index == 3) {
                        //           Navigator.push(
                        //             context,
                        //             SlideRightRoute(page: UploadVideoOptionsScreen()),
                        //           );
                        //         }*/
                        //         else if (index == 2) {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => SelectSoundListScreen(
                        //                 duration: "0",
                        //               ),
                        //             ),
                        //           );
                        //         } else if (index == 3) {
                        //           Navigator.push(
                        //             context,
                        //             SlideRightRoute(page: VideoShareOptionsScreen()),
                        //           );
                        //         }
                        //         // Navigator.push(
                        //         //   context,
                        //         //   SlideRightRoute(page: SelectContestLevel()),
                        //         // );
                        //       },
                        //       child: Card(
                        //         elevation: 5,
                        //         shadowColor: myLoading.isDark
                        //             ? const Color(0xFF3F3F3F)
                        //             : /*Color(0x153F3F3F)*/ Colors.white,
                        //         color: myLoading.isDark
                        //             ? const Color(0xFF3F3F3F)
                        //             : /*Color(0x153F3F3F)*/ Colors.white,
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(10)),
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Image.asset(
                        //               myLoading.isDark
                        //                   ? optionsList[index].darkModeImage!
                        //                   : optionsList[index].lightModeImage!,
                        //               height: 50,
                        //               width: 50,
                        //             ),
                        //             SizedBox(
                        //               height: 20,
                        //             ),
                        //             Text(
                        //               optionsList[index].name!,
                        //               textAlign: TextAlign.center,
                        //               style: GoogleFonts.poppins(
                        //                 fontSize: 14,
                        //                 color: myLoading.isDark
                        //                     ? Colors.white
                        //                     : Colors.black,
                        //                 fontWeight: FontWeight.w500,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: optionsList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (index == 0) {
                                  if (isVerified == 1) {
                                    Navigator.push(
                                      context,
                                      SlideRightRoute(
                                          page: const CaptureVideoScreen(
                                        from: "level",
                                      )),
                                    );
                                  } else {
                                    checkKYCStatus(
                                        context, iDProof, addressProof, face);
                                  }
                                  /*if (contestProvider.uploadVideoStatusModel !=
                                          null &&
                                      contestProvider
                                              .uploadVideoStatusModel!.status ==
                                          "200") {
                                    Navigator.push(
                                      context,
                                      SlideRightRoute(
                                          page: const CaptureVideoScreen(
                                        from: "level",
                                      )),
                                    );
                                  } else {
                                    showCompetitionDateDialog(
                                        context,
                                        contestProvider
                                            .uploadVideoStatusModel!.data!);
                                  }*/
                                } else if (index == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectSoundListScreen(
                                        duration: "0",
                                      ),
                                    ),
                                  );
                                } else if (index == 2) {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const VideoShareOptionsScreen()),
                                  );
                                }
                                // Navigator.push(
                                //   context,
                                //   SlideRightRoute(page: SelectContestLevel()),
                                // );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                child: Card(
                                  elevation: 5,
                                  shadowColor: myLoading.isDark
                                      ? const Color(0xFF3F3F3F)
                                      : /*Color(0x153F3F3F)*/ Colors.white,
                                  color: myLoading.isDark
                                      ? const Color(0xFF3F3F3F)
                                      : /*Color(0x153F3F3F)*/ Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
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
                                        const SizedBox(
                                          height: 10,
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
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
