import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/auth_screen/create_password_screen.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';

import '../../constants/my_loading/my_loading.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  bool otpVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(myLoading.isDark
                  ? 'assets/images/background.png'
                  : 'assets/images/bg_wht.png'),
              // Path to your image
              fit:
                  BoxFit.cover, // Ensures the image covers the entire container
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppbar(context, myLoading.isDark),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .forgotPass
                        .replaceAll("?", ""),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: myLoading.isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 98,
                ),
                Visibility(
                  visible: !otpVisible,
                  child: Form(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          AppLocalizations.of(context)!.phone,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          maxLines: 1,
                          controller: phoneNumberController,
                          cursorColor: Colors.white,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            errorStyle: GoogleFonts.poppins(),
                            border: GradientOutlineInputBorder(
                              width: 1,
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: [
                                  myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  greyTextColor4
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            hintStyle: GoogleFonts.poppins(
                              color: hintGreyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: textFieldGreyColor,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: textFieldGreyColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
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
                        ),
                      ),
                      const SizedBox(height: 68),
                      InkWell(
                        onTap: () => setState(() {
                          otpVisible = !otpVisible;
                        }),
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
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.sendOtp,
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
                  )),
                ),
                Visibility(
                    visible: otpVisible,
                    child: Column(
                      children: [
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.otpSentMsg,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "\n+91 ${phoneNumberController.text} ",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFFFFCDB3),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      otpVisible = !otpVisible;
                                    });
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.redAccent,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        OtpPinField(
                          key: _otpPinFieldController,
                          autoFillEnable: false,
                          textInputAction: TextInputAction.done,
                          onSubmit: (text) {
                            print('Entered pin is $text');
                          },
                          onChange: (text) {
                            print('Enter on change pin is $text');
                          },
                          onCodeChanged: (code) {
                            print('onCodeChanged  is $code');
                          },
                          otpPinFieldStyle: OtpPinFieldStyle(
                            textStyle: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            activeFieldBorderGradient: LinearGradient(
                              colors: [
                                myLoading.isDark ? Colors.white : Colors.black,
                                greyTextColor4
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            filledFieldBorderGradient: LinearGradient(
                              colors: [
                                myLoading.isDark ? Colors.white : Colors.black,
                                greyTextColor4
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            defaultFieldBorderGradient: LinearGradient(
                              colors: [
                                myLoading.isDark ? Colors.white : Colors.black,
                                greyTextColor4
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          maxLength: 4,
                          showCursor: true,
                          cursorColor:
                              myLoading.isDark ? Colors.white : Colors.black,
                          cursorWidth: 3,
                          mainAxisAlignment: MainAxisAlignment.center,
                          otpPinFieldDecoration:
                              OtpPinFieldDecoration.defaultPinBoxDecoration,
                        ),
                        const SizedBox(height: 68),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            SlideRightRoute(
                                page: const CreatePasswordScreen(
                              from: 'forgot',
                            )),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            margin: const EdgeInsets.only(
                                top: 15, left: 60, right: 60, bottom: 5),
                            decoration: ShapeDecoration(
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
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
                              AppLocalizations.of(context)!.verifyOtp,
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
                    ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
