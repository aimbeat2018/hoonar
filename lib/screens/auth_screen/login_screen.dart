import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/screens/auth_screen/signup_screen.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';

import '../../constants/color_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordError = false,
      mobileError = false,
      passwordVisible = true;
  bool remeberme = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery
              .of(context)
              .size
              .height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'), // Path to your image
              fit: BoxFit.cover, // Ensures the image covers the entire container
            ),
          ),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment(0.00, -1.00),
          //     end: Alignment(0, 1),
          //     colors: [Color(0xFF575757), Color(0xFF040404)],
          //   ),
          // ),
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
                      height: 130,
                      width: 130,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      login,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: Text(
                              phoneNumber,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: TextFormField(
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return enterPhoneNumber;
                                } else if (v.length != 10) {
                                  return enterValidPhoneNumber;
                                }
                                return null;
                              },
                              maxLines: 1,
                              controller: phoneController,
                              cursorColor: Colors.white,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.white,
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
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  // if (value.length == 10) {
                                  //   enableGetOtpButton = true;
                                  // } else {
                                  //   enableGetOtpButton = false;
                                  // }
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: Text(
                              password,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: TextFormField(
                              obscureText: false,
                              cursorColor: Colors.white,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                // filled: true,
                                // fillColor: Colors.white,
                                border: InputBorder.none,
                                // hintText: enterpassword,
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
                              keyboardType:
                              TextInputType.visiblePassword,
                              controller: passwordController,
                              onChanged: (value) {
                                if (passwordController
                                    .text.isEmpty) {
                                  setState(() {
                                    passwordError = true;
                                  });
                                } else {
                                  setState(() {
                                    passwordError = false;
                                  });
                                }
                              },
                              onSaved: (value) {
                                passwordController.text =
                                value as String;
                              },
                            ),
                          ),
                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Row(
                              children: [
                                Checkbox(
                                    side: BorderSide(color: Colors.white),
                                    checkColor: Colors.white,
                                    focusColor: Colors.white,
                                    activeColor: Colors.grey,
                                    value: remeberme,
                                    onChanged: (value) {
                                      setState(() {
                                        remeberme =
                                        !remeberme;
                                      });
                                    }),
                                Expanded(
                                  child: Text(
                                    rememberMe,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  forgotPass,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
                            },
                            child: Container(
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              margin: const EdgeInsets.only(
                                  top: 15,
                                  left: 60,
                                  right: 60,
                                  bottom: 5),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              child: Text(
                                login,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupScreen()))
                            ,
                            child: Container(
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              margin: const EdgeInsets.only(
                                  top: 10,
                                  left: 60,
                                  right: 60,
                                  bottom: 5),
                              decoration: ShapeDecoration(
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              child: Text(
                                createAcc,
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
                  SizedBox(height: 30,),
                  Center(
                    child: Text(
                      loginWith,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(width: 30,),
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
      ),
    );
  }
}
