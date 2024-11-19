import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/connectShare/connect_share_screen.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/upload_video_options_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../model/star_category_model.dart';
import '../../camera/capture_video_screen.dart';
import '../../camera/sounds/select_sound_list_screen.dart';

class CreateUploadOptionsScreen extends StatefulWidget {
  const CreateUploadOptionsScreen({super.key});

  @override
  State<CreateUploadOptionsScreen> createState() =>
      _CreateUploadOptionsScreenState();
}

class _CreateUploadOptionsScreenState extends State<CreateUploadOptionsScreen> {
  List<StarCategoryModel> optionsList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      optionsList = [
        StarCategoryModel(
            'assets/light_mode_icons/upload_video_light.png',
            AppLocalizations.of(context)!.uploadVideo,
            'assets/dark_mode_icons/upload_video.png'),
        StarCategoryModel(
            'assets/light_mode_icons/gallery_light.png',
            AppLocalizations.of(context)!.gallery,
            'assets/dark_mode_icons/gallery_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/create_video_light.png',
            AppLocalizations.of(context)!.createVideo,
            'assets/dark_mode_icons/create_video_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/edit_video_light.png',
            AppLocalizations.of(context)!.editVideo,
            'assets/dark_mode_icons/edit_video_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/music_library_light.png',
            AppLocalizations.of(context)!.musicLibrary,
            'assets/dark_mode_icons/music_library_dark.png'),
        StarCategoryModel(
            'assets/light_mode_icons/connect_share_light.png',
            AppLocalizations.of(context)!.connectShare,
            'assets/dark_mode_icons/connect_share_dark.png'),
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 2 : 3;
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
                  Center(
                      child: GradientText(
                    AppLocalizations.of(context)!.createAndUpload,
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          if (index == 0) {
                            Navigator.push(
                              context,
                              SlideRightRoute(page: UploadVideoOptionsScreen()),
                            );
                          } else if (index == 2) {
                            Navigator.push(
                              context,
                              SlideRightRoute(page: const CaptureVideoScreen()),
                            );
                          } else if (index == 4) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectSoundListScreen(
                                  duration: "0",
                                ),
                              ),
                            );
                          } else if (index == 5) {
                            Navigator.push(
                              context,
                              SlideRightRoute(page: ConnectShareScreen()),
                            );
                          }
                          // Navigator.push(
                          //   context,
                          //   SlideRightRoute(page: SelectContestLevel()),
                          // );
                        },
                        child: Card(
                          elevation: 5,
                          shadowColor: myLoading.isDark
                              ? const Color(0xFF3F3F3F)
                              : Color(0x153F3F3F),
                          color: myLoading.isDark
                              ? const Color(0xFF3F3F3F)
                              : Color(0x153F3F3F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                myLoading.isDark
                                    ? optionsList[index].darkModeImage!
                                    : optionsList[index].lightModeImage!,
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
