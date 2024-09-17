import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/screens/auth_screen/signup_screen.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String from;

  const CreatePasswordScreen({super.key, required this.from});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  TextEditingController newpassController = TextEditingController();
  TextEditingController conpassController = TextEditingController();

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
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  createPass,
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
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      newPassword,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
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
                        obscureText: true,
                        controller: newpassController,
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
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 68),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      confirmPassword,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
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
                        obscureText: true,
                        maxLines: 1,
                        controller: conpassController,
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
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      SlideRightRoute(page: MainScreen()),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.only(
                          top: 15, left: 60, right: 60, bottom: 5),
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
                        letsGo,
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
