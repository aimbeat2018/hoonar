import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/key_res.dart';
import 'package:hoonar/model/request_model/add_post_request_model.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/success_models/sound_by_category_list_model.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';

import '../../../../constants/internet_connectivity.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/no_internet_screen.dart';
import '../../../../constants/session_manager.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../custom/snackbar_util.dart';
import '../../../../model/request_model/list_common_request_model.dart';
import '../../../../model/success_models/hash_tag_list_model.dart';
import '../../../../providers/contest_provider.dart';
import '../../../../providers/home_provider.dart';
import '../../../auth_screen/login_screen.dart';

class UploadVideoScreen extends StatefulWidget {
  final String? videoUrl;
  final int? postId;
  final String videoThumbnail;
  final String from;
  final String? caption;
  final String? hashTag;

  // final SoundList? selectedMusic;
  final SoundByCategoryListData? selectedMusic;

  const UploadVideoScreen(
      {super.key,
      this.videoUrl,
      required this.videoThumbnail,
      required this.from,
      this.selectedMusic,
      this.caption,
      this.hashTag,
      this.postId});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  SessionManager sessionManager = SessionManager();
  TextEditingController captionController = TextEditingController();
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // TextEditingController hashTagController = TextEditingController();

  List<HashTagData>? hashTagList = [];
  bool isLoading = false;
  List<String> hashTags = [];

  final hashTagController = DetectableTextEditingController(
    regExp: detectionRegExp(atSign: false, hashtag: true, url: false),
  );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

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

    sessionManager.initPref();

    if (mounted) {
      setState(() {
        if (widget.caption != null) {
          captionController.text = widget.caption ?? '';
          hashTagController.text = widget.hashTag ?? '';
        }
      });
    }

    hashTagController.addListener(() {
      setState(() {});
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getKycStatus(context, CommonRequestModel());
    // });
  }

  Future<void> addPost(
      BuildContext context, AddPostRequestModel requestModel) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    try {
      await sessionManager.initPref();
      // Simulate API call progress
      await homeProvider.addPost(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');

      } else if (homeProvider.addPostModel?.status == '200') {
        if (mounted) {
          setState(() {
            KeyRes.selectedLevelId = -1;
            KeyRes.selectedCategoryId = -1;
            KeyRes.selectedCategoryName = '';
          });
        }

        Navigator.pushAndRemoveUntil(
            context,
            SlideRightRoute(
                page: const MainScreen(
              fromIndex: 0,
            )),
            (route) => false);
      } else if (homeProvider.addPostModel?.message == 'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.addPostModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: const LoginScreen()), (route) => false);
      } else if (homeProvider.addPostModel?.status == '201') {
        /* if (mounted) {
          setState(() {
            KeyRes.selectedLevelId = -1;
            KeyRes.selectedCategoryId = -1;
            KeyRes.selectedCategoryName = '';
          });
        }*/

        SnackbarUtil.showSnackBar(
            context, homeProvider.addPostModel?.message! ?? '');
      } else {
        /* if (mounted) {
          setState(() {
            KeyRes.selectedLevelId = -1;
            KeyRes.selectedCategoryId = -1;
            KeyRes.selectedCategoryName = '';
           });
        }*/

        SnackbarUtil.showSnackBar(
            context, 'Something went wrong.. please try later');
      }
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  Future<void> updatePost(
      BuildContext context, AddPostRequestModel requestModel) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    try {
      await sessionManager.initPref();
      // Simulate API call progress
      await homeProvider.updatePost(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      // Handle API response
      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else if (homeProvider.addPostModel?.status == '200') {
        if (mounted) {
          setState(() {
            KeyRes.selectedLevelId = -1;
            KeyRes.selectedCategoryId = -1;
            KeyRes.selectedCategoryName = '';
          });
        }

        Navigator.pushAndRemoveUntil(
            context,
            SlideRightRoute(
                page: const MainScreen(
              fromIndex: 0,
            )),
            (route) => false);
      } else if (homeProvider.addPostModel?.message == 'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.addPostModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: const LoginScreen()), (route) => false);
      } else if (homeProvider.addPostModel?.status == '201') {
        if (mounted) {
          setState(() {
            KeyRes.selectedLevelId = -1;
            KeyRes.selectedCategoryId = -1;
            KeyRes.selectedCategoryName = '';
          });
        }

        SnackbarUtil.showSnackBar(
            context, homeProvider.addPostModel?.message! ?? '');
      } else {
        if (mounted) {
          setState(() {
            KeyRes.selectedLevelId = -1;
            KeyRes.selectedCategoryId = -1;
            KeyRes.selectedCategoryName = '';
          });
        }

        SnackbarUtil.showSnackBar(context,
            'Something went wrong.. please try again later in sometime');
      }
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  Future<void> getHashTagList(BuildContext context, String searchKey) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(limit: 10, search: searchKey);

      await homeProvider.getHashTagList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.hashTagListModel?.status == '200') {
          if (homeProvider.hashTagListModel?.data != null) {
            hashTagList = homeProvider.hashTagListModel?.data!;
          } else {
            hashTagList = [];
          }
          setState(() {});
        } else if (homeProvider.hashTagListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.hashTagListModel?.message! ?? '');
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

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
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
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
                            SizedBox(height: screenHeight * 0.01),
                            // Space from the top

                            // Curved Image with Edit Icon
                            Stack(
                              children: [
                                Container(
                                  // width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  height: screenHeight * 0.50,
                                  width: screenWidth * 0.75,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: widget.from == 'feed'
                                              ? NetworkImage(
                                                  widget.videoThumbnail ?? '')
                                              : FileImage(File(widget
                                                  .videoThumbnail
                                                  .replaceAll(
                                                      'file://', ''))))),
                                ),

                                // Edit Icon Overlay
                                /* Positioned(
                            bottom: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () async {
                              */ /*  if (widget.from == 'feed') {
                                  try {
                                    String? downloadedFile =
                                        await downloadAndConvertM3U8(
                                            widget.videoUrl!);
                                    File outPutFile = File(downloadedFile!);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPreviewScreen(
                                          videoFile: outPutFile,
                                          selectedMusic: widget.selectedMusic,
                                        ),
                                      ),
                                    );
                                  } catch (error) {
                                    print(
                                        "Error during video download or conversion: $error");
                                  }
                                }*/ /*
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.edit,
                                        color: Colors.white, size: 12),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context)!.edit,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                              ],
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 30),

                                  TextFormField(
                                    controller: captionController,
                                    style: GoogleFonts.poppins(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15),
                                      labelText: AppLocalizations.of(context)!
                                          .writeACaption,
                                      labelStyle: GoogleFonts.poppins(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 1)),
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  // Hashtags Text Field
                                  // TextFormField(
                                  //   controller: hashTagController,
                                  //   style: GoogleFonts.poppins(
                                  //       color: myLoading.isDark
                                  //           ? Colors.white
                                  //           : Colors.black,
                                  //       fontSize: 14),
                                  //   decoration: InputDecoration(
                                  //     contentPadding:
                                  //         const EdgeInsets.symmetric(horizontal: 15),
                                  //     labelText: AppLocalizations.of(context)!.hashTag,
                                  //     labelStyle: GoogleFonts.poppins(
                                  //         color: myLoading.isDark
                                  //             ? Colors.white
                                  //             : Colors.black,
                                  //         fontSize: 14),
                                  //     border: OutlineInputBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //         borderSide: BorderSide(
                                  //             color: myLoading.isDark
                                  //                 ? Colors.white
                                  //                 : Colors.black,
                                  //             width: 1)),
                                  //     enabledBorder: OutlineInputBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //         borderSide: BorderSide(
                                  //             color: myLoading.isDark
                                  //                 ? Colors.white
                                  //                 : Colors.black,
                                  //             width: 1)),
                                  //     focusedBorder: OutlineInputBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //         borderSide: BorderSide(
                                  //             color: myLoading.isDark
                                  //                 ? Colors.white
                                  //                 : Colors.black,
                                  //             width: 1)),
                                  //   ),
                                  //   onChanged: (value) {
                                  //     getHashTagList(context, value);
                                  //   },
                                  // ),

                                  // Hashtags Text Field

                                  DetectableTextField(
                                    controller: hashTagController,
                                    style: GoogleFonts.poppins(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14),
                                    maxLines: 1,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(175)
                                    ],
                                    enableSuggestions: false,
                                    onChanged: onChangeDetectableTextField,
                                    onTapOutside: (event) => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15),
                                      labelText:
                                          AppLocalizations.of(context)!.hashTag,
                                      labelStyle: GoogleFonts.poppins(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 1)),
                                    ),
                                  ),

                                  /*  if (hashTagList != null || hashTagList!.isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      String hashTagAdded = hashTagController.text
                                          .replaceAll(" ", ",");
                                      hashTagAdded +=
                                          "${hashTagList![index].hashTagName!},";
                                      // Remove the last comma if it exists
                                      if (hashTagAdded.endsWith(',')) {
                                        hashTagAdded = hashTagAdded.substring(
                                            0, hashTagAdded.length - 1);
                                      }

                                      setState(() {
                                        hashTagController.text = hashTagAdded;
                                      });
                                    },
                                    child: Text(
                                      hashTagList![index].hashTagName ?? '',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                                itemCount: hashTagList!.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  );
                                },
                              ),*/
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  widget.from != "feed"
                                      ? Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              AddPostRequestModel requestModel = AddPostRequestModel(
                                                  saveAsDraft: "1",
                                                  userId: int.parse(sessionManager.getString(
                                                      SessionManager.userId)!),
                                                  categoryId: widget.from !=
                                                          'normal'
                                                      ? (KeyRes.selectedCategoryId == -1
                                                          ? ""
                                                          : KeyRes
                                                              .selectedCategoryId
                                                              .toString())
                                                      : "",
                                                  levelId: widget.from != 'normal'
                                                      ? (KeyRes.selectedLevelId == -1
                                                          ? ""
                                                          : KeyRes
                                                              .selectedLevelId
                                                              .toString())
                                                      : "",
                                                  postDescription:
                                                      captionController.text,
                                                  postHashTag:
                                                      hashTags.join(', '),
                                                  postImagePath: widget
                                                      .videoThumbnail
                                                      .replaceAll('file://', ''),
                                                  postVideoPath: widget.videoUrl!);
                                              addPost(context, requestModel);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 30),
                                              margin: const EdgeInsets.only(
                                                  top: 15, bottom: 5),
                                              decoration: ShapeDecoration(
                                                color: myLoading.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    strokeAlign: BorderSide
                                                        .strokeAlignOutside,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .saveAsDraft,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: myLoading.isDark
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  if (widget.from != 'feed')
                                    const SizedBox(
                                      width: 15,
                                    ),
                                  Expanded(
                                    child: ValueListenableBuilder<int?>(
                                        valueListenable:
                                            Provider.of<ContestProvider>(
                                                    context)
                                                .userKycStatusNotifier,
                                        builder:
                                            (context, userKycStatus, child) {
                                          return InkWell(
                                            onTap: /*userKycStatus == 1 &&
                                                    widget.from != "normal"
                                                ? */
                                                () {
                                              if (widget.from == 'feed') {
                                                AddPostRequestModel
                                                    requestModel =
                                                    AddPostRequestModel(
                                                  postId: widget.postId!,
                                                  saveAsDraft: "0",
                                                  userId: int.parse(
                                                      sessionManager.getString(
                                                          SessionManager
                                                              .userId)!),
                                                  categoryId: widget.from !=
                                                          'normal'
                                                      ? (KeyRes.selectedCategoryId ==
                                                              -1
                                                          ? ""
                                                          : KeyRes
                                                              .selectedCategoryId
                                                              .toString())
                                                      : "",
                                                  levelId: widget.from !=
                                                          'normal'
                                                      ? (KeyRes.selectedLevelId ==
                                                              -1
                                                          ? ""
                                                          : KeyRes
                                                              .selectedLevelId
                                                              .toString())
                                                      : "",
                                                  postDescription:
                                                      captionController.text,
                                                  postHashTag:
                                                      hashTags.join(', '),
                                                );

                                                updatePost(
                                                    context, requestModel);
                                              } else {
                                                AddPostRequestModel requestModel = AddPostRequestModel(
                                                    saveAsDraft: "0",
                                                    userId: int.parse(
                                                        sessionManager.getString(
                                                            SessionManager
                                                                .userId)!),
                                                    categoryId: widget.from != 'normal'
                                                        ? (KeyRes.selectedCategoryId == -1
                                                            ? ""
                                                            : KeyRes.selectedCategoryId
                                                                .toString())
                                                        : "",
                                                    levelId: widget.from != 'normal'
                                                        ? (KeyRes.selectedLevelId == -1
                                                            ? ""
                                                            : KeyRes.selectedLevelId
                                                                .toString())
                                                        : "",
                                                    postDescription:
                                                        captionController.text,
                                                    postHashTag:
                                                        hashTags.join(', '),
                                                    postImagePath: widget
                                                        .videoThumbnail
                                                        .replaceAll('file://', ''),
                                                    postVideoPath: widget.videoUrl!);

                                                if (widget.selectedMusic !=
                                                    null) {
                                                  if (widget.selectedMusic!
                                                              .isLocalSong !=
                                                          null ||
                                                      widget.selectedMusic!
                                                              .isLocalSong ==
                                                          "0") {
                                                    requestModel
                                                        .isOrignalSound = "1";
                                                    requestModel.postSound =
                                                        widget.selectedMusic!
                                                            .trimAudioPath!;
                                                    requestModel.soundImage =
                                                        widget.selectedMusic!
                                                            .soundImage!;
                                                    requestModel.soundTitle =
                                                        widget.selectedMusic!
                                                            .soundTitle!;
                                                    requestModel.duration =
                                                        widget.selectedMusic!
                                                            .duration!;
                                                    requestModel.singer = widget
                                                        .selectedMusic!.singer!;
                                                  } else {
                                                    requestModel
                                                        .isOrignalSound = "0";
                                                    // requestModel.postSound = widget.selectedMusic!.sound!;
                                                    requestModel.soundId =
                                                        widget.selectedMusic!
                                                            .soundId!
                                                            .toString();
                                                  }
                                                }

                                                addPost(context, requestModel);
                                              }
                                            }
                                            /*: widget.from == "normal"
                                                    ? () {
                                                        AddPostRequestModel requestModel = AddPostRequestModel(
                                                            saveAsDraft: "0",
                                                            userId: int.parse(
                                                                sessionManager.getString(
                                                                    SessionManager
                                                                        .userId)!),
                                                            categoryId: widget.from !=
                                                                    'normal'
                                                                ? (KeyRes.selectedCategoryId == -1
                                                                    ? ""
                                                                    : KeyRes
                                                                        .selectedCategoryId
                                                                        .toString())
                                                                : "",
                                                            levelId: widget.from !=
                                                                    'normal'
                                                                ? (KeyRes.selectedLevelId == -1
                                                                    ? ""
                                                                    : KeyRes
                                                                        .selectedLevelId
                                                                        .toString())
                                                                : "",
                                                            postDescription:
                                                                captionController.text,
                                                            postHashTag: hashTags.join(', '),
                                                            postImagePath: widget.videoThumbnail.replaceAll('file://', ''),
                                                            postVideoPath: widget.videoUrl!);

                                                        if (widget
                                                                .selectedMusic !=
                                                            null) {
                                                          if (widget.selectedMusic!
                                                                      .isLocalSong !=
                                                                  null ||
                                                              widget.selectedMusic!
                                                                      .isLocalSong ==
                                                                  "0") {
                                                            requestModel
                                                                    .isOrignalSound =
                                                                "1";
                                                            requestModel
                                                                    .postSound =
                                                                widget
                                                                    .selectedMusic!
                                                                    .trimAudioPath!;
                                                            requestModel
                                                                    .soundImage =
                                                                widget
                                                                    .selectedMusic!
                                                                    .soundImage!;
                                                            requestModel
                                                                    .soundTitle =
                                                                widget
                                                                    .selectedMusic!
                                                                    .soundTitle!;
                                                            requestModel
                                                                    .duration =
                                                                widget
                                                                    .selectedMusic!
                                                                    .duration!;
                                                            requestModel
                                                                    .singer =
                                                                widget
                                                                    .selectedMusic!
                                                                    .singer!;
                                                          } else {
                                                            requestModel
                                                                    .isOrignalSound =
                                                                "0";
                                                            // requestModel.postSound = widget.selectedMusic!.sound!;
                                                            requestModel
                                                                    .soundId =
                                                                widget
                                                                    .selectedMusic!
                                                                    .soundId!
                                                                    .toString();
                                                          }
                                                        }
                                                        // showProgressLoader(context);
                                                        addPost(context,
                                                            requestModel);
                                                      }
                                                    : () {
                                                        SnackbarUtil.showSnackBar(
                                                            context,
                                                            'Your KYC not completed');
                                                      }*/
                                            ,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 40),
                                              margin: const EdgeInsets.only(
                                                  top: 15, bottom: 5),
                                              decoration: ShapeDecoration(
                                                color: /*userKycStatus == 1 &&
                                                        widget.from != "normal"
                                                    ?*/
                                                    buttonBlueColor1
                                                /*  : widget.from == "normal"
                                                        ? buttonBlueColor1
                                                        : greyTextColor8*/
                                                ,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    strokeAlign: BorderSide
                                                        .strokeAlignOutside,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .upload,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isLoading)
                          Positioned.fill(
                            child: ModalBarrier(
                              dismissible: false, // Prevent closing by touch
                              color: Colors.black
                                  .withOpacity(0.5), // Optional: Dim background
                            ),
                          ),
                        if (isLoading)
                          Selector<HomeProvider, double>(
                            selector: (_, provider) => provider.uploadProgress,
                            builder: (_, uploadProgress, __) {
                              return Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: Wrap(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              value: uploadProgress,
                                              backgroundColor: Colors.grey[200],
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.blue),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              // '${(uploadProgress * 100).toStringAsFixed(1)}%',
                                              '${(uploadProgress * 100).round()}%',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: myLoading.isDark
                                                    ? Colors.black
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
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

  void onChangeDetectableTextField(String value) {
    hashTags = TextPatternDetector.extractDetections(value, hashTagRegExp);
    setState(() {});
  }

  String addCommaBeforeHashtags(String text) {
    // Pattern to add comma before each `#` that is preceded by a character or space (not at the start)
    final modifiedText = text.replaceAllMapped(
      RegExp(r'(?<=\S| )#'),
      // Match any `#` preceded by a non-space or space character
      (match) => ',#',
    );
    return modifiedText;
  }
}
