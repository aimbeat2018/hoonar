import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/upload_kyc_document_request_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';

class UploadDocumentsScreen extends StatefulWidget {
  const UploadDocumentsScreen({super.key});

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  XFile? _pickedFile;
  bool isIdProofClick = false, isLoading = false;
  SessionManager sessionManager = SessionManager();

  void pickImage() async {
    _pickedFile = (await ImagePicker().pickImage(source: ImageSource.gallery))!;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _pickedFile!.path,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: blueButtonColor,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            // initAspectRatio: CropAspectRatioPreset.original,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );

    XFile imageFile = XFile(croppedFile!.path);
    _pickedFile = imageFile;
    setState(() {});
  }

  void pickImageCamera() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _pickedFile!.path,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: blueButtonColor,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: true,
            // initAspectRatio: CropAspectRatioPreset.original,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );

    XFile imageFile = XFile(croppedFile!.path);
    _pickedFile = imageFile;

    UploadKycDocumentRequestModel requestModel = UploadKycDocumentRequestModel(
        documentName: isIdProofClick ? 'ID Proof' : 'Address Proof',
        document: File(_pickedFile!.path));
    uploadDocument(context, requestModel);
  }

  void selectImageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Select Image',
                  style: GoogleFonts.notoSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black26,
                ),
              ],
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: InkWell(
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 25,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Camera',
                          style: GoogleFonts.notoSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    pickImageCamera();
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: InkWell(
                  child: Row(
                    children: [
                      Icon(
                        Icons.image,
                        size: 25,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Gallery',
                          style: GoogleFonts.notoSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    pickImage();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  Future<void> uploadDocument(
      BuildContext context, UploadKycDocumentRequestModel requestModel) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    try {
      sessionManager.initPref().then((onValue) async {
        await contestProvider.uploadKycDocuments(requestModel,
            sessionManager.getString(SessionManager.accessToken) ?? '');

        if (contestProvider.errorMessage != null) {
          SnackbarUtil.showSnackBar(
              context, contestProvider.errorMessage ?? '');
        } else if (contestProvider.uploadDocumentSuccessModel?.status ==
            '200') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.uploadDocumentSuccessModel?.message! ?? '');
          // Navigator.pop(context);
        } else if (contestProvider.uploadDocumentSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.uploadDocumentSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contestProvider = Provider.of<ContestProvider>(context);
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
                        const EdgeInsets.only(left: 15.0, top: 30, bottom: 0),
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
                    AppLocalizations.of(context)!.documents,
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
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.uploadIdProof,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.uploadIdProofDesc,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        )),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isIdProofClick = true;
                            });
                            selectImageDialog(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: isIdProofClick &&
                                    contestProvider.isDocumentLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.upload,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.residenceProof,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.residenceProofDesc,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        )),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isIdProofClick = false;
                            });
                            selectImageDialog(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: isIdProofClick &&
                                    contestProvider.isDocumentLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.upload,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
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
