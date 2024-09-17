import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/screens/auth_screen/create_password_screen.dart';
import 'package:hoonar/screens/auth_screen/signup_screen.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            // Path to your image
            fit: BoxFit.cover, // Ensures the image covers the entire container
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppbar(context),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  forgotPass.replaceAll("?", ""),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
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
                        phone,
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
                          controller: phoneNumberController,
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
                        ),
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
                          sendOtp,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
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
                              text: otpSentMsg,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
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
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          activeFieldBorderGradient: const LinearGradient(
                            colors: [Colors.white, greyTextColor4],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          filledFieldBorderGradient: const LinearGradient(
                            colors: [Colors.white, greyTextColor4],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          defaultFieldBorderGradient: const LinearGradient(
                            colors: [Colors.white, greyTextColor4],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        maxLength: 4,
                        showCursor: true,
                        cursorColor: Colors.white,
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
                            verifyOtp,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
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
  }
}
