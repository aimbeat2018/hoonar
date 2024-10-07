import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/change_password_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/change_profile_photo_option_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              /*image: DecorationImage(
            image: AssetImage('assets/images/screens_back.png'),
            fit: BoxFit.cover,
          ),*/
              color: myLoading.isDark ? Colors.black : Colors.white),
          child: SafeArea(
            child: Scrollbar(
              thickness: 2.5,
              radius: const Radius.circular(10),
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      buildAppbar(context, myLoading.isDark),
                      SizedBox(
                        height: 10,
                      ),
                      GradientText(
                        AppLocalizations.of(context)!.editProfile,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          const Hero(
                            tag: 'profileImage',
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg',
                              ),
                            ),
                          ),
                          /*camera_edit.png*/
                          Positioned(
                                  bottom: 5,
                                  right: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _openChangeProfileOptionsSheet(
                                          context, myLoading.isDark);
                                    },
                                    child: Image.asset(
                                      'assets/images/camera_edit.png',
                                      height: 25,
                                      width: 25,
                                    ),
                                  ))
                              .animate()
                              .moveY(
                                  begin: 200,
                                  end:
                                      0) // Moves from +200px to 0px (bottom to center)
                              .fadeIn(duration: 800.ms),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.fullName,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(1),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black)),
                            child: TextFormField(
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterFullName;
                                }
                                return null;
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  hintText:
                                      AppLocalizations.of(context)!.fullName),
                              controller: fullNameController,
                              cursorColor: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.name,
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.dob,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(1),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black)),
                            child: TextFormField(
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return AppLocalizations.of(context)!.enterDob;
                                }
                                return null;
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  hintText: AppLocalizations.of(context)!.dob),
                              controller: dobController,
                              cursorColor: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.name,
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.bio,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(1),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black)),
                            child: TextFormField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  hintText: AppLocalizations.of(context)!.bio),
                              controller: bioController,
                              cursorColor: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.text,
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.phone,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(1),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black)),
                            child: TextFormField(
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterPhoneNumber;
                                }
                                return null;
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  hintText:
                                      AppLocalizations.of(context)!.phone),
                              controller: phoneController,
                              cursorColor: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.email,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(1),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black)),
                            child: TextFormField(
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterEmail;
                                }
                                return null;
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  hintText:
                                      AppLocalizations.of(context)!.email),
                              controller: emailController,
                              cursorColor: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          SlideRightRoute(page: const ChangePasswordScreen()),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.changePassword,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          margin: const EdgeInsets.only(
                              top: 15, left: 60, right: 60, bottom: 10),
                          decoration: ShapeDecoration(
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(80),
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

  void _openChangeProfileOptionsSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ChangeProfilePhotoOptionScreen(
          isDarkMode: isDarkMode,
        );
      },
    );
  }
}
