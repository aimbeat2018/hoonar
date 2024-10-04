import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/editVideo/edit_video_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/slide_right_route.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 30, bottom: 30),
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
                SizedBox(height: screenHeight * 0.01), // Space from the top

                // Curved Image with Edit Icon
                Stack(
                  children: [
                    Container(
                      // width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: screenHeight * 0.50,
                      width: screenWidth * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/images/image1.png',
                              ))),
                    ),

                    // Edit Icon Overlay
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            SlideRightRoute(page: const EditVideoScreen()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 16),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!.edit,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
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
                      SizedBox(height: 30),

                      TextFormField(
                        style: GoogleFonts.poppins(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontSize: 14),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                      SizedBox(height: 25),

                      // Hashtags Text Field
                      TextFormField(
                        style: GoogleFonts.poppins(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontSize: 14),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                    margin: const EdgeInsets.only(top: 15, bottom: 5),
                    decoration: ShapeDecoration(
                      color: buttonBlueColor1,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.upload,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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
}
