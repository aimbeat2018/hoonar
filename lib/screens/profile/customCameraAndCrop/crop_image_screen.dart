import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/request_model/update_profile_image_request_model.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart'; // For saving the file
import 'package:path/path.dart'; // For path manipulations
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/snackbar_util.dart';
import '../../auth_screen/login_screen.dart';
import '../menuOptionsScreens/edit_profile_screen.dart';

class CropImageScreen extends StatefulWidget {
  final XFile? selectedImageFile;
  final Uint8List? fileBytes;

  const CropImageScreen({super.key, this.selectedImageFile, this.fileBytes});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final _cropController = CropController();
  Uint8List? fileBytes;
  XFile? croppedXFile;
  SessionManager sessionManager = SessionManager();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedImageFile != null) {
        setState(() {
          isLoading = true;
        });

        covertFileToBytes();
      } else {
        fileBytes = widget.fileBytes;
        setState(() {});
      }
    });
  }

  Future<void> updateProfileImage(
      BuildContext context, UpdateProfileImageRequestModel requestModel) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      sessionManager.initPref().then((onValue) async {
        await authProvider.updateProfileImage(
            requestModel,
            sessionManager.getString(SessionManager.accessToken) ?? '',
            CommonRequestModel(
                userId: sessionManager.getString(SessionManager.userId) ?? '',
                myUserId:
                    sessionManager.getString(SessionManager.userId) ?? ''));

        if (authProvider.errorMessage != null) {
          SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
        } else if (authProvider.updateProfileImageModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, authProvider.updateProfileImageModel?.message! ?? '');
          navigateToEditProfile(croppedXFile!, context);
          // Navigator.pop(context);
        } else if (authProvider.updateProfileImageModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, authProvider.updateProfileImageModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      });
    } finally {}
  }

  Future<Uint8List> getFileAsBytes(File file) async {
    return await file.readAsBytes();
  }

  covertFileToBytes() async {
    if (widget.selectedImageFile != null) {
      fileBytes = await getFileAsBytes(File(widget.selectedImageFile!.path));
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save the cropped image as an XFile
  Future<XFile> saveCroppedImage(Uint8List croppedImageData) async {
    final directory =
        await getTemporaryDirectory(); // Get a temporary directory
    final filePath =
        join(directory.path, 'cropped_image.png'); // Set the file path
    final File croppedFile = File(filePath);

    await croppedFile.writeAsBytes(
        croppedImageData); // Save the cropped image bytes to a file

    return XFile(croppedFile.path); // Return as XFile
  }

  // Navigate to Edit Profile with SlideRightRoute and remove camera/crop screens
  void navigateToEditProfile(XFile croppedImage, BuildContext context) {
    Navigator.push(
      context,
      SlideRightRoute(
        page: const MainScreen(fromIndex: 3),
      ),
    ).then((_) {
      // When returning, you can perform additional actions if necessary
      Navigator.pop(context); // Remove the Crop Image screen from the stack
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator until fileBytes is available
    final authProvider = Provider.of<AuthProvider>(context);

    if (fileBytes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: myLoading.isDark ? Colors.white : Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Upper half of the screen - Crop widget
                Expanded(
                  flex: 5, // Give more space to the Crop widget
                  child: Crop(
                    image: fileBytes!,
                    controller: _cropController,
                    fixCropRect: true,
                    withCircleUi: true,
                    initialSize: 0.8,
                    cornerDotBuilder: (size, edgeAlignment) =>
                        const SizedBox.shrink(),
                    interactive: true,
                    onCropped: (image) async {
                      // When cropped, store the cropped image as an XFile
                      croppedXFile = await saveCroppedImage(image);

                      // After saving the cropped image, navigate to the edit profile screen
                      if (croppedXFile != null) {
                        updateProfileImage(
                            context,
                            UpdateProfileImageRequestModel(
                                profileImage: File(croppedXFile!.path)));
                      }
                    },
                  ),
                ),
                // Lower half - Crop button
                Expanded(
                  flex: 2, // Less space for the button area
                  child: Center(
                    child: authProvider.isUpdateProfileImageLoading
                        ? CircularProgressIndicator(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                          )
                        : InkWell(
                            onTap: () {
                              _cropController.crop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30),
                              margin: const EdgeInsets.only(top: 15, bottom: 5),
                              decoration: ShapeDecoration(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.save,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: myLoading.isDark
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
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
      );
    });
  }
}
