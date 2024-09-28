import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/languagesSupported/change_language_screen.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/text_constants.dart';
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
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          /*image: DecorationImage(
          image: AssetImage('assets/images/screens_back.png'),
          // Path to your image
          fit: BoxFit.cover, // Ensures the image covers the entire container
        ),*/
          color: Colors.black),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppbar(context),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: GradientText(
                aboutApp,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [Colors.white, greyTextColor8]),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(),
            ),
            SizedBox(
              height: 20,
            ),
            _buildSection(context,
                icon: 'assets/images/notification.png',
                title: notification,
                subtitle: notificationSubTitle,
                trailing: _buildCustomSwitch(false)),
            _buildDivider(),
            _buildSection(
              context,
              icon: 'assets/images/app_version.png',
              title: appVersion,
              subtitle: '1.3',
            ),
            _buildDivider(),
            _buildSection(
              context,
              icon: 'assets/images/contact_email.png',
              title: contactEmail,
              subtitle: 'customercare@hoonarstar.in',
            ),
            _buildDivider(),
            _buildSection(context,
                icon: 'assets/images/language.png',
                title: language,
                subtitle: languageSubTitle, onTap: () {
              Navigator.push(
                context,
                SlideRightRoute(page: ChangeLanguageScreen()),
              );
            }),
            _buildDivider(),
            _buildSection(
              context,
              icon: 'assets/images/copyright.png',
              title: copyright,
              subtitle: copyrightSubTitle,
            ),
            _buildDivider(),
            _buildSection(
              context,
              icon: 'assets/images/faq.png',
              title: faq,
              subtitle: faqSubTitle,
            ),
            _buildDivider(),
            _buildSection(
              context,
              icon: 'assets/images/share_app.png',
              title: share,
              subtitle: shareSubTitle,
            ),
            _buildDivider(),
            _buildSection(
              context,
              icon: 'assets/images/delete_account.png',
              title: deleteAccount,
              subtitle: deleteAccountSubTitle,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildSection(BuildContext context,
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
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white60,
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
    return GestureDetector(
      onTap: () {
        // Handle switch toggle here if needed
        setState(() {
          enableNotification = !enableNotification;
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
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            enableNotification
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      on.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox(),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            !enableNotification
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      off.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: greyTextColor8,
    ); // Add spacing between sections
  }
}
