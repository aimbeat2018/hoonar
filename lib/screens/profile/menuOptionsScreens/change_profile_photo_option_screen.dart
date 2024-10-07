import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/crop_image_screen.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/custom_camera_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/slide_right_route.dart';

class ChangeProfilePhotoOptionScreen extends StatefulWidget {
  final bool isDarkMode;

  const ChangeProfilePhotoOptionScreen({super.key, required this.isDarkMode});

  @override
  State<ChangeProfilePhotoOptionScreen> createState() =>
      _ChangeProfilePhotoOptionScreenState();
}

class _ChangeProfilePhotoOptionScreenState
    extends State<ChangeProfilePhotoOptionScreen> {
  File? _imageFile;

  // Method to request camera permission
  Future<void> _requestPermissionAndCaptureImage() async {
    // Request camera permission
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      // If permission is granted, capture the image
      _captureImageFromCamera();
    } else if (status.isDenied) {
      // If permission is denied, show a message
      _showPermissionDeniedDialog();
    } else if (status.isPermanentlyDenied) {
      // If permission is permanently denied, open app settings
      openAppSettings();
    }
  }

  // Method to capture image from camera
  Future<void> _captureImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Navigator.push(
        context,
        SlideRightRoute(
            page: CropImageScreen(
          selectedImageFile: pickedFile,
        )),
      );
      // Navigator.pop(context);
      // _imageFile = File(croppedFile.path);
      // if (croppedFile != null) {
      //   setState(() {
      //
      //   });
      // }
    }
  }

  // Show dialog if permission is denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Camera permission is required to take photos.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(bottom: 30, left: 15, right: 15, top: 30),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            // Adjust as per your theme
            border: Border(
              top: BorderSide(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  width: 1.5), // Top border
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  // _requestPermissionAndCaptureImage();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    SlideRightRoute(page: CustomCameraScreen()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      widget.isDarkMode
                          ? 'assets/light_mode_icons/camera_light.png'
                          : 'assets/dark_mode_icons/camera_dark.png',
                      height: 65,
                      width: 65,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.camera,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Image.asset(
                      widget.isDarkMode
                          ? 'assets/light_mode_icons/gallery_profile_light.png'
                          : 'assets/dark_mode_icons/gallery_profile_dark.png',
                      height: 65,
                      width: 65,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.gallery,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
              Expanded(
                  child: Column(
                children: [
                  Image.asset(
                    widget.isDarkMode
                        ? 'assets/light_mode_icons/avatar_light.png'
                        : 'assets/dark_mode_icons/avatar_dark.png',
                    height: 65,
                    width: 65,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.avatar,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ],
    );
  }
}
