import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/custom_camera_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/slide_right_route.dart';
import '../customCameraAndCrop/crop_image_screen.dart';

class ChangeProfilePhotoOptionScreen extends StatefulWidget {
  final bool isDarkMode;

  const ChangeProfilePhotoOptionScreen({super.key, required this.isDarkMode});

  @override
  State<ChangeProfilePhotoOptionScreen> createState() =>
      _ChangeProfilePhotoOptionScreenState();
}

class _ChangeProfilePhotoOptionScreenState
    extends State<ChangeProfilePhotoOptionScreen> {
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
                    SlideRightRoute(page: const CustomCameraScreen()),
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
                onTap: () {
                  // Navigator.pop(context);
                  /*Navigator.push(
                    context,
                    SlideRightRoute(
                        page: CustomGalleryScreen(
                      requestType: 'image',
                    )),
                  );*/
                  _selectImageFromGallery();
                },
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
              /*Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    SlideRightRoute(page: AvatarListTabScreen()),
                  );
                },
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
                ),
              ))*/
            ],
          ),
        ),
      ],
    );
  }

  XFile? imageFile;

  Future<void> _selectImageFromGallery() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = XFile(pickedFile.path);
      });

      Uint8List fileBytes = await imageFile!.readAsBytes();

      Navigator.push(
        context,
        SlideRightRoute(
          page: CropImageScreen(
            // fileBytes: fileBytes,
            selectedImageFile: imageFile,
          ),
        ),
      );
    }
  }
}
