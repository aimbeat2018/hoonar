import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/change_language_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/change_theme_screen.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  bool enableNotification = false;

  @override
  Widget build(BuildContext context) {
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
          child: Column(
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
                        myLoading.isDark ? greyTextColor8 : Colors.grey.shade700
                      ]),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .then(delay: 200.ms) // baseline=800ms
                    .slide(),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildSection(context, myLoading.isDark,
                  icon: 'assets/images/notification.png',
                  title: AppLocalizations.of(context)!.notification,
                  subtitle: AppLocalizations.of(context)!.notificationSubTitle,
                  trailing: _buildCustomSwitch(false)),
              _buildDivider(),
              _buildSection(
                context,
                myLoading.isDark,
                icon: 'assets/images/app_version.png',
                title: AppLocalizations.of(context)!.appVersion,
                subtitle: '1.3',
              ),
              _buildDivider(),
              _buildSection(
                context,
                myLoading.isDark,
                icon: 'assets/images/contact_email.png',
                title: AppLocalizations.of(context)!.contactEmail,
                subtitle: 'customercare@hoonarstar.in',
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
              _buildSection(
                context,
                myLoading.isDark,
                icon: 'assets/images/faq.png',
                title: AppLocalizations.of(context)!.faq,
                subtitle: AppLocalizations.of(context)!.faqSubTitle,
              ),
              _buildDivider(),
              _buildSection(
                context,
                myLoading.isDark,
                icon: 'assets/images/share_app.png',
                title: AppLocalizations.of(context)!.share,
                subtitle: AppLocalizations.of(context)!.shareSubTitle,
              ),
              _buildDivider(),
              _buildSection(
                context,
                myLoading.isDark,
                icon: 'assets/images/delete_account.png',
                title: AppLocalizations.of(context)!.deleteAccount,
                subtitle: AppLocalizations.of(context)!.deleteAccountSubTitle,
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

  Widget _buildCustomSwitch(bool value) {
    enableNotification = value;
    return InkWell(
      onTap: () {
        setState(() {
          if (enableNotification) {
            enableNotification = false;
          } else {
            enableNotification = true;
          }
          // enableNotification = !enableNotification;
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
}
