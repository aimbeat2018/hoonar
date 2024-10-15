import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/auth_screen/forgot_password_screen.dart';
import 'package:hoonar/screens/auth_screen/signup_screen.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/color_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordError = false, mobileError = false, passwordVisible = true;
  bool remeberme = false;
  bool _isObscure = true;
  String deviceName = '';
  String deviceType = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDeviceInfo();
  }

  Future<void> fetchDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      // For Android
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceName = androidInfo.model ?? 'Unknown Android Device';
        deviceType = 'Android';
      });
    } else if (Platform.isIOS) {
      // For iOS
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceName = iosInfo.name ?? 'Unknown iOS Device';
        deviceType = 'iOS';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover, // Ensures the image covers the entire container
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    fit: BoxFit.fill,
                    scale: 4,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.login,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        AppLocalizations.of(context)!.phoneNumber,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.all(1),
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Colors.white, greyTextColor4],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          // Background color for TextFormField
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          validator: (v) {
                            if (v!.trim().isEmpty) {
                              return AppLocalizations.of(context)!
                                  .enterPhoneNumber;
                            } else if (v.length != 10) {
                              return AppLocalizations.of(context)!
                                  .enterValidPhoneNumber;
                            }
                            return null;
                          },
                          maxLines: 1,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3)),
                          controller: phoneController,
                          cursorColor: Colors.white,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.text,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly,
                          //   LengthLimitingTextInputFormatter(10),
                          // ],
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        AppLocalizations.of(context)!.password,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(1),
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Colors.white, greyTextColor4],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          // Background color for TextFormField
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          maxLines: 1,
                          obscureText: _isObscure,
                          controller: passwordController,
                          cursorColor: Colors.white,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: enterPhoneNumber,
                              hintStyle: GoogleFonts.poppins(
                                color: hintGreyColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: textFieldGreyColor,
                                ),
                              )),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                            side: const BorderSide(
                                color: Colors.white,
                                strokeAlign: BorderSide.strokeAlignInside),
                            checkColor: Colors.white,
                            focusColor: Colors.white,
                            activeColor: Colors.grey,
                            value: remeberme,
                            onChanged: (value) {
                              setState(() {
                                remeberme = !remeberme;
                              });
                            }),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.rememberMe,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            SlideRightRoute(page: ForgotPasswordScreen()),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.forgotPass,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideRightRoute(page: MainScreen(fromIndex: 0)),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        margin: const EdgeInsets.only(
                            top: 15, left: 60, right: 60, bottom: 5),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        SlideRightRoute(page: SignupScreen()),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        margin: const EdgeInsets.only(
                            top: 10, left: 60, right: 60, bottom: 5),
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.createAcc,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.loginWith,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Image.asset(
                      'assets/images/apple.png',
                      height: 40,
                      width: 40,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
