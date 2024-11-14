import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/model/request_model/add_post_request_model.dart';
import 'package:provider/provider.dart';

import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/session_manager.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../custom/snackbar_util.dart';
import '../../../../model/request_model/list_common_request_model.dart';
import '../../../../model/success_models/hash_tag_list_model.dart';
import '../../../../providers/home_provider.dart';
import '../../../auth_screen/login_screen.dart';

class UploadVideoScreen extends StatefulWidget {
  final List<String>? videoUrl;
  final String videoThumbnail;
  final String from;

  const UploadVideoScreen(
      {super.key,
      this.videoUrl,
      required this.videoThumbnail,
      required this.from});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  SessionManager sessionManager = SessionManager();
  TextEditingController captionController = TextEditingController();
  TextEditingController hashTagController = TextEditingController();

  List<HashTagData>? hashTagList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sessionManager.initPref();
  }

  Future<void> addPost(
      BuildContext context, AddPostRequestModel requestModel) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    try {
      await sessionManager.initPref();
      await homeProvider.addPost(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else if (homeProvider.addPostModel?.status == '200') {
        Navigator.pop(context);
      } else if (homeProvider.addPostModel?.message == 'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.addPostModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: const LoginScreen()), (route) => false);
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

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
            child: Stack(
              children: [
                Column(
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
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), // Space from the top

                    // Curved Image with Edit Icon
                    Stack(
                      children: [
                        Container(
                          // width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: screenHeight * 0.50,
                          width: screenWidth * 0.75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(widget.videoThumbnail
                                      .replaceAll('file://', ''))))),
                        ),

                        // Edit Icon Overlay
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: InkWell(
                            onTap: () {},
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
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  const EdgeInsets.symmetric(horizontal: 15),
                              labelText:
                                  AppLocalizations.of(context)!.writeACaption,
                              labelStyle: GoogleFonts.poppins(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      width: 1)),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Hashtags Text Field
                          TextFormField(
                            controller: hashTagController,
                            style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              labelText: AppLocalizations.of(context)!.hashTag,
                              labelStyle: GoogleFonts.poppins(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      width: 1)),
                            ),
                            onChanged: (value) {
                              getHashTagList(context, value);
                            },
                          ),
                          if (hashTagList != null || hashTagList!.isNotEmpty)
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
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                AddPostRequestModel requestModel =
                                    AddPostRequestModel(
                                        saveAsDraft: "1",
                                        userId: int.parse(sessionManager
                                            .getString(SessionManager.userId)!),
                                        categoryId:
                                            widget.from == "normal" ? "" : "",
                                        levelId:
                                            widget.from == "normal" ? "" : "",
                                        postDescription: captionController.text,
                                        postHashTag: addCommaBeforeHashtags(
                                            hashTagController.text),
                                        postImagePath: widget.videoThumbnail
                                            .replaceAll('file://', ''),
                                        postVideoPath: widget.videoUrl!.first);
                                addPost(context, requestModel);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 30),
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 5),
                                decoration: ShapeDecoration(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.saveAsDraft,
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
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                AddPostRequestModel requestModel =
                                    AddPostRequestModel(
                                        saveAsDraft: "0",
                                        userId: int.parse(sessionManager
                                            .getString(SessionManager.userId)!),
                                        categoryId:
                                            widget.from == "normal" ? "" : "",
                                        levelId:
                                            widget.from == "normal" ? "" : "",
                                        postDescription: captionController.text,
                                        postHashTag: addCommaBeforeHashtags(
                                            hashTagController.text),
                                        postImagePath: widget.videoThumbnail
                                            .replaceAll('file://', ''),
                                        postVideoPath: widget.videoUrl!.first);
                                addPost(context, requestModel);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 40),
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 5),
                                decoration: ShapeDecoration(
                                  color: buttonBlueColor1,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.upload,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                /* if (isLoading) ...[
                  Opacity(
                    opacity: 0.5,
                    child:
                        ModalBarrier(dismissible: false, color: Colors.black),
                  ),
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ],*/
                if (isLoading)
                  Positioned.fill(
                    top: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      // semi-transparent background
                      child: Center(
                        child: CircularProgressIndicator(),
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
