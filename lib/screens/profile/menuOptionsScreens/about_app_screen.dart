import 'dart:io';

import 'package:custom_social_share/custom_social_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/change_language_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/change_theme_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/faq_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../providers/auth_provider.dart';
import '../../auth_screen/login_screen.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  late AuthProvider authProvider;
  SessionManager sessionManager = SessionManager();
  String appVersion = '';
  bool enableNotification = false;

  @override
  void initState() {
    super.initState();
    sessionManager.initPref();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version; // e.g., "1.0.0"
      // If you need the build number, you can use packageInfo.buildNumber
    });
  }

  Future<void> deleteAccount(BuildContext context) async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      await authProvider.deleteAccount(
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else {
        if (authProvider.deleteAccountModel?.status == '200') {
          Navigator.pop(context);
          await sessionManager.clean();
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            SlideRightRoute(page: const LoginScreen()),
            (route) => false,
          );
        } else if (authProvider.deleteAccountModel?.message ==
            'Unauthorized Access!') {
          Navigator.pop(context);
          SnackbarUtil.showSnackBar(
            context,
            authProvider.deleteAccountModel?.message! ?? '',
          );
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            SlideRightRoute(page: const LoginScreen()),
            (route) => false,
          );
        }
      }
    });
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
        if (authProvider.unableDisableNotification?.status == '200') {
          setState(() {
            if (notificationStatus == "0") {
              enableNotification = false;
            } else {
              enableNotification = true;
            }
          });
        } else if (authProvider.unableDisableNotification?.message ==
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
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
          body: Container(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            /*image: DecorationImage(
          image: AssetImage('assets/images/screens_back.png'),
          // Path to your image
          fit: BoxFit.cover, // Ensures the image covers the entire container
        ),*/
            color: myLoading.isDark ? Colors.black : Colors.white),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppbar(context, myLoading.isDark),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: GradientText(
                    AppLocalizations.of(context)!.aboutApp,
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
                    height: 20,
                  ),
                  _buildSection(context, myLoading.isDark,
                      icon: 'assets/images/notification.png',
                      title: AppLocalizations.of(context)!.notification,
                      subtitle:
                          AppLocalizations.of(context)!.notificationSubTitle,
                      trailing: _buildCustomSwitch()),
                  _buildDivider(),
                  _buildSection(
                    context,
                    myLoading.isDark,
                    icon: 'assets/images/app_version.png',
                    title: AppLocalizations.of(context)!.appVersion,
                    subtitle: appVersion,
                  ),
                  _buildDivider(),
                  _buildSection(
                    context,
                    myLoading.isDark,
                    icon: 'assets/images/contact_email.png',
                    title: AppLocalizations.of(context)!.contactEmail,
                    subtitle: 'customercare@hoonarstar.com',
                  ),
                  _buildDivider(),
                  _buildSection(context, myLoading.isDark,
                      icon: 'assets/images/language.png',
                      title: AppLocalizations.of(context)!.language,
                      subtitle: AppLocalizations.of(context)!.languageSubTitle,
                      onTap: () {
                    Navigator.push(
                      context,
                      SlideRightRoute(page: const ChangeLanguageScreen()),
                    );
                  }),
                  _buildDivider(),
                  _buildSection(context, myLoading.isDark,
                      icon: 'assets/images/change_theme.png',
                      title: AppLocalizations.of(context)!.darkMode,
                      subtitle: AppLocalizations.of(context)!.darkModeSubtitle,
                      onTap: () {
                    Navigator.push(
                      context,
                      SlideRightRoute(page: const ChangeThemeScreen()),
                    );
                  }),
                  _buildDivider(),
                  _buildSection(
                    context,
                    myLoading.isDark,
                    icon: 'assets/images/copyright.png',
                    title: AppLocalizations.of(context)!.copyright,
                    subtitle: AppLocalizations.of(context)!.copyrightSubTitle,
                  ),
                  _buildDivider(),
                  _buildSection(context, myLoading.isDark,
                      icon: 'assets/images/faq.png',
                      title: AppLocalizations.of(context)!.faq,
                      subtitle: AppLocalizations.of(context)!.faqSubTitle,
                      onTap: () => Navigator.push(
                          context, SlideRightRoute(page: const FaqScreen()))),
                  _buildDivider(),
                  _buildSection(context, myLoading.isDark,
                      icon: 'assets/images/share_app.png',
                      title: AppLocalizations.of(context)!.share,
                      subtitle: AppLocalizations.of(context)!.shareSubTitle,
                      onTap: () {
                    final message = Platform.isAndroid
                        ? 'Check out this app on Google Play: https://play.google.com/store/apps/details?id=com.hoonar.hoonar'
                        : 'Check out this app on the App Store: https://apps.apple.com/app/id1234567890';

                    CustomSocialShare().toAll(message);
                  }),
                  _buildDivider(),
                  _buildSection(context, myLoading.isDark,
                      icon: 'assets/images/delete_account.png',
                      title: AppLocalizations.of(context)!.deleteAccount,
                      subtitle: AppLocalizations.of(context)!
                          .deleteAccountSubTitle, onTap: () {
                    showDeleteAccountDialog(context, myLoading.isDark);
                  }),
                ],
              ),
              if (authProvider.isDeleteAccountLoading)
                Positioned.fill(
                  top: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    // semi-transparent background
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ));
    });
  }

  Widget _buildSection(BuildContext context, bool isDarkMode,
      {required String icon,
      required String title,
      required String subtitle,
      Widget? trailing,
      Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    icon,
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white60 : Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing, // Show trailing widget if it exists
          ],
        ),
      ),
    );
  }

  Widget _buildCustomSwitch() {
    return InkWell(
      onTap: () {
        setState(() {
          // enableNotification = !enableNotification;

          enableDisableNotification(context, enableNotification ? "0" : "1");
        });
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: enableNotification ? Colors.green : Colors.grey,
          // Change color based on value
          borderRadius: BorderRadius.circular(15),
        ),
        alignment:
            enableNotification ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            enableNotification
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.on.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(),
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            !enableNotification
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.off.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: greyTextColor8,
    ); // Add spacing between sections
  }

  void showDeleteAccountDialog(BuildContext context, bool isDarkMode) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.deleteAccount,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            '${AppLocalizations.of(context)!.areYouSureYouWantToDeleteAccount}\n\n${AppLocalizations.of(context)!.areYouSureYouWantToDeleteAccountMsg}',
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }
}
