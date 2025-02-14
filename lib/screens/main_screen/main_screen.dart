import 'package:flutter/material.dart';
import 'package:hoonar/constants/sizedbox_constants.dart';
import 'package:hoonar/screens/camera/capture_video_screen.dart';
import 'package:hoonar/screens/home/home_screen.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/select_category_screen.dart';
import 'package:hoonar/screens/main_screen/enable_notification_screen.dart';
import 'package:hoonar/screens/profile/profile_screen.dart';
import 'package:hoonar/screens/search/search_screen.dart';
import 'package:notification_permissions/notification_permissions.dart' as np;

// import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:ve_sdk_flutter/export_result.dart';
// import 'package:ve_sdk_flutter/features_config.dart';
// import 'package:ve_sdk_flutter/ve_sdk_flutter.dart';

import '../../constants/key_res.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';
// import '../camera/camera_screen.dart';

class MainScreen extends StatefulWidget {
  final int? fromIndex;

  const MainScreen({super.key, this.fromIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget? screen1, screen2, screen3, screen4;
  int selectedIndex = 0;

  // final _veSdkFlutterPlugin = VeSdkFlutter();
  // String _errorMessage = '';
  // final _licenseToken =
  //     "Qk5CIB92NbTLDkLauz8nj8BFLW78AUUKhBlysKBq4wht6dQXkwDwcqHZPqsiiXpj8wdw3TT/uCOH2l8xKvAhxFPfj2JtImGqoWfFhzRgWPVo8QioCJ5DkF1S7EzQf2+QJIBdI00zhPhuRO9SkkN82RH87e7F2jHrWz+atQ3Az4/fzaWZaIqVvetNDI8AeUBzsflnlmzXlh/YbVCqAS0HyBmb4oxGqlMfWVyv9zW8sEDJuVB01uhtwzITtplCGKT9Gq0mznZXoIYbxS74JkWhI6676WGqwks8PwqVEsqf43AQXj1Ud/1EBUe27CHNKu7RwG7HG3alX84B+2l90AkeB98ti57RzyvyChOfMKUFKXt98zokLcrsAGck/f8Vr5OPAvgoCclorMWPxA0dAxKhXGaA9JNPHzSXIFpgsTKUJy08S1k/eFoHmilPUNcyYyZJ3GREkIL9ZhUxK/VPJT1dojE8w+795wE9KRA8p5BpDC+g4oNtx+b5w5dADQT/af3V5/Y5CL4ncBZCNHTwFcm4PxDPKQ56n+HuGPMAXOGk8FwIeUaEpzshDVJQmK5uItzjEtDj4UpuYVF+U1DkAkZmxZKnVEnUecsAlB+463AF+4p9X9k/3pB5EJ84vJ6pIUTX6ZPFw7Wn74/s8ulSLrD0to76";

  @override
  void initState() {
    super.initState();

    checkNotificationPermission();

    if (widget.fromIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedIndex = widget.fromIndex!;
          getBody();
        });
      });
    }

    screen1 = const HomeScreen();
    screen2 = const SearchScreen();
    screen3 = const ProfileScreen(from: 'main');
  }

  // Function to check the notification permission status
  void checkNotificationPermission() async {
    if (KeyRes.hasCheckedPermission) return; // Skip if already checked

    np.PermissionStatus status =
        await np.NotificationPermissions.getNotificationPermissionStatus();

    if (status == np.PermissionStatus.denied) {
      _openBottomSheet(context);
    } else if (status == np.PermissionStatus.granted) {
      // Permission granted, proceed as normal
      print('Notification permissions granted');
    } else {
      // Permission not requested or undetermined, request permission
      _openBottomSheet(context);
    }

    KeyRes.hasCheckedPermission = true; // Mark permission check as done
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const SafeArea(child: EnableNotificationScreen());
      },
    );
  }

  // Open app settings using url_launcher
  void openIosAppSettings() async {
    if (await canLaunch('app-settings:')) {
      await launch('app-settings:');
    } else {
      print('Could not open app settings');
    }
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return screen1!;
    } else if (selectedIndex == 1) {
      return screen2!;
    } else {
      return screen3!;
    }
  }

  // Handle back button press to reset to index 0
  Future<bool> _onWillPop() async {
    if (selectedIndex != 0) {
      setState(() {
        selectedIndex = 0;
      });
      return false; // Prevent default back button action
    }
    return true; // Allow back button to work as expected
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: UpgradeAlert(
          barrierDismissible: false,
          dialogStyle: UpgradeDialogStyle.cupertino,
          showIgnore: false,
          showLater: true,
          upgrader: Upgrader(
            durationUntilAlertAgain: const Duration(days: 1),
            debugLogging: true,
            // debugDisplayAlways: true,
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor:
                myLoading.isDark ? Colors.transparent : Colors.white,
            body: getBody(),
            floatingActionButton: SizedBox(
              height: 65, // Set custom height
              width: 65, // Set custom width
              child: FloatingActionButton(
                backgroundColor: myLoading.isDark ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    SlideRightRoute(page: const SelectCategoryScreen()),
                  );
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 10,
                      child: Image.asset(
                        'assets/images/star.png',
                        color: myLoading.isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(30)),
              child: BottomAppBar(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                height: 60,
                color: myLoading.isDark ? Colors.white : Colors.black,
                shape: const CircularNotchedRectangle(),
                notchMargin: 7.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (selectedIndex == 0) {
                              setState(() {
                                selectedIndex = 0;
                              });
                            } else {
                              onTapHandler(0);
                            }
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/home.png",
                                height: selectedIndex == 0 ? 25 : 23,
                                width: selectedIndex == 0 ? 25 : 23,
                                color: myLoading.isDark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              sizedBoxH2,
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            openCameraScreen();
                            // _startVideoEditorInCameraMode();
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/camera.png",
                                height: selectedIndex == 1 ? 25 : 23,
                                width: selectedIndex == 1 ? 25 : 23,
                                color: myLoading.isDark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()), // Handle FAB spacing
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onTapHandler(1);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/search.png",
                                height: selectedIndex == 2 ? 25 : 23,
                                width: selectedIndex == 2 ? 25 : 23,
                                color: myLoading.isDark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            onTapHandler(2);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/profile.png",
                                height: selectedIndex == 3 ? 25 : 23,
                                width: selectedIndex == 3 ? 25 : 23,
                                color: myLoading.isDark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void openCameraScreen() {
    Navigator.push(
      context,
      SlideRightRoute(
          page: const CaptureVideoScreen(
        from: "normal",
      )),
    );
  }
/*-----Banuba SDK CODE----*/
/*  Future<void> _startVideoEditorInCameraMode() async {
    // Specify your Config params in the builder below

    final config = FeaturesConfigBuilder()
        .setAudioBrowser(AudioBrowser.fromSource(AudioBrowserSource.local))
        .setDraftsConfig(DraftsConfig.fromOption(DraftsOption.disabled))
        .build();

    // Export data example

    // const exportData = ExportData(exportedVideos: [
    //   ExportedVideo(
    //       fileName: "export_HD",
    //       videoResolution: VideoResolution.hd720p
    //   )],
    //     watermark: Watermark(
    //        imagePath: "assets/watermark.png",
    //        alignment: WatermarkAlignment.topLeft
    //     )
    // );

    try {
      dynamic exportResult =
          await _veSdkFlutterPlugin.openCameraScreen(_licenseToken, config);
      _handleExportResult(exportResult);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  void _handleExportResult(ExportResult? result) {
    if (result == null) {
      debugPrint(
          'No export result! The user has closed video editor before export');
      return;
    }

    */ /*   // The list of exported video file paths
    debugPrint('Exported video files = ${result.videoSources}');

    // Preview as a image file taken by the user. Null - when preview screen is disabled.
    debugPrint('Exported preview file = ${result.previewFilePath}');

    // Meta file where you can find short data used in exported video
    debugPrint('Exported meta file = ${result.metaFilePath}');*/ /*

    Navigator.push(
      context,
      SlideRightRoute(
          page: UploadVideoScreen(
        videoThumbnail: result.previewFilePath!,
        videoUrl: result.videoSources.first,
        from: "normal",
      )),
    );
  }

  void _handlePlatformException(PlatformException exception) {
    _errorMessage = exception.message ?? 'unknown error';
    // You can find error codes 'package:ve_sdk_flutter/errors.dart';
    debugPrint("Error: code = ${exception.code}, message = $_errorMessage");

    setState(() {});
  }*/
}
