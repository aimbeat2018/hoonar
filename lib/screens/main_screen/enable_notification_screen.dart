import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:notification_permissions/notification_permissions.dart' as np;
import 'package:url_launcher/url_launcher.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/common_request_model.dart';
import '../../providers/auth_provider.dart';

class EnableNotificationScreen extends StatefulWidget {
  const EnableNotificationScreen({super.key});

  @override
  State<EnableNotificationScreen> createState() =>
      _EnableNotificationScreenState();
}

class _EnableNotificationScreenState extends State<EnableNotificationScreen> {
  late AuthProvider authProvider;
  SessionManager sessionManager = SessionManager();

  void requestNotificationPermission() async {
    np.PermissionStatus status =
        await np.NotificationPermissions.requestNotificationPermissions(
      iosSettings: const np.NotificationSettingsIos(
        sound: true,
        badge: true,
        alert: true,
      ),
    );

    if (status == np.PermissionStatus.denied) {
      // Handle case when permission is denied
      if (Platform.isIOS) {
        openIosAppSettings();
      } else {
        await openAppSettings();
      }
    } else if (status == np.PermissionStatus.granted) {
      // Handle case when permission is granted
      print('Permission granted');

      enableDisableNotification(context, "1");
    }

    // _hasCheckedPermission = true; // Mark permission check as done
  }

  Future<void> enableDisableNotification(
      BuildContext context, String notificationStatus) async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      await authProvider.enableDisableNotification(
          CommonRequestModel(
              deviceToken: sessionManager
                      .getString(SessionManager.accessToken)!
                      .replaceAll('Bearer', '') ??
                  '',
              notificationStatus: notificationStatus),
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else {
        if (authProvider.unableDisableNotification?.status ==
            '200') {} /*else if (authProvider.unableDisableNotification?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
            context,
            authProvider.unableDisableNotification?.message! ?? '',
          );
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            SlideRightRoute(page: const LoginScreen()),
                (route) => false,
          );
        }*/
      }
    });
  }

  // Open app settings using url_launcher
  void openIosAppSettings() async {
    if (await canLaunch('app-settings:')) {
      await launch('app-settings:');
    } else {
      print('Could not open app settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(
      builder: (context, myLoading, child) {
        return SingleChildScrollView(
          child: Wrap(
            children: [
              Center(
                child: Container(
                  color: myLoading.isDark ? Colors.black : Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        myLoading.isDark
                            ? 'assets/light_mode_icons/notification_permission_dark.gif'
                            : 'assets/dark_mode_icons/notification_permission_light.gif',
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Enable Notifications',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: myLoading.isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'To receive real-time updates, please enable notifications.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: myLoading.isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          requestNotificationPermission();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          margin: const EdgeInsets.only(
                              top: 15, left: 60, right: 60, bottom: 5),
                          decoration: ShapeDecoration(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: myLoading.isDark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          child: Text(
                            'Ask for permission',
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
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'may be later',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
