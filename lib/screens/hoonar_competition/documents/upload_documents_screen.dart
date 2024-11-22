import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
import '../../../model/request_model/common_request_model.dart';
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getKycStatus(context, CommonRequestModel());
    });
  }

  void pickImage() async {
    _pickedFile = (await ImagePicker().pickImage(source: ImageSource.gallery));

    if (_pickedFile != null) {
      await cropImage(_pickedFile!.path);
    }
  }

  // Method to capture an image with the camera
  void pickImageCamera() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (_pickedFile != null) {
      await cropImage(_pickedFile!.path);
    }
  }

  // Method to crop the selected or captured image
  Future<void> cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
          lockAspectRatio: true,
        ),
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

    if (croppedFile != null) {
      _pickedFile = XFile(croppedFile.path);

      UploadKycDocumentRequestModel requestModel =
          UploadKycDocumentRequestModel(
              documentName: isIdProofClick ? 'ID Proof' : 'Address Proof',
              document: File(_pickedFile!.path));
      uploadDocument(context, requestModel);

      setState(() {});
    }
  }

  void pickFile({int minSizeInKB = 1024}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf', 'doc', 'docx', // Document formats
        ],
      );

      // Check if the user picked a file
      if (result != null) {
        // File selected successfully
        PlatformFile file = result.files.first;

        // Check if file size meets the minimum requirement
        File selectedFile = File(file.path!);
        int fileSizeInKB =
            selectedFile.lengthSync() ~/ 1024; // Convert bytes to KB

        if (fileSizeInKB <= minSizeInKB) {
          UploadKycDocumentRequestModel requestModel =
              UploadKycDocumentRequestModel(
                  documentName: isIdProofClick ? 'ID Proof' : 'Address Proof',
                  document: File(file.path!));
          uploadDocument(context, requestModel);
        } else {
          SnackbarUtil.showSnackBar(context,
              'Selected file is too big. Minimum size is ${minSizeInKB} KB.');
        }

        // Further code to handle the selected file
      } else {
        print("File picking was canceled by the user.");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  // // New method to pick any file type
  // void pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //
  //   if (result != null) {
  //     File selectedFile = File(result.files.single.path!);
  //     print('Selected file path: ${selectedFile.path}');
  //     // Handle the selected file as needed
  //   }
  // }

  // Dialog to select image or file
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
                'Select Image or File',
                style: GoogleFonts.notoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.black26,
              ),
            ],
          ),
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.black),
              title: Text('Camera',
                  style: GoogleFonts.notoSans(color: Colors.black)),
              onTap: () async {
                pickImageCamera();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.black),
              title: Text('Gallery',
                  style: GoogleFonts.notoSans(color: Colors.black)),
              onTap: () async {
                pickImage();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.black),
              title: Text('Select File',
                  style: GoogleFonts.notoSans(color: Colors.black)),
              onTap: () async {
                pickFile();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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

          if (isIdProofClick) {
            contestProvider.idProofStatusNotifier.value = 1;
          } else {
            contestProvider.addressProofStatusNotifier.value = 1;
          }
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
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
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
                        ValueListenableBuilder<int?>(
                            valueListenable:
                                contestProvider.idProofStatusNotifier,
                            builder: (context, idProofStatus, child) {
                              return InkWell(
                                onTap: idProofStatus == 0
                                    ? () {
                                        setState(() {
                                          isIdProofClick = true;
                                        });
                                        selectImageDialog(context);
                                      }
                                    : null,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: idProofStatus == 0
                                          ? Colors.white
                                          : Colors.grey.shade400),
                                  child: isIdProofClick &&
                                          contestProvider.isDocumentLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!.upload,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: idProofStatus == 0
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
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
                        ValueListenableBuilder<int?>(
                            valueListenable:
                                contestProvider.addressProofStatusNotifier,
                            builder: (context, addressProofStatus, child) {
                              return InkWell(
                                onTap: addressProofStatus == 0
                                    ? () {
                                        setState(() {
                                          isIdProofClick = false;
                                        });
                                        selectImageDialog(context);
                                      }
                                    : null,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: addressProofStatus == 0
                                          ? Colors.white
                                          : Colors.grey.shade400),
                                  child: isIdProofClick &&
                                          contestProvider.isDocumentLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!.upload,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: addressProofStatus == 0
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            }),
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
