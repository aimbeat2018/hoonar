import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController newpassController = TextEditingController();
  TextEditingController conpassController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool newPasswordVisibility = true, confirmNewPasswordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          /*image: DecorationImage(
            image: AssetImage('assets/images/screens_back.png'),
            // Path to your image
            fit: BoxFit.cover, // Ensures the image covers the entire container
          ),*/
          color: Colors.black
        ),
        child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          thickness: 2.5,
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppbar(context),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: GradientText(
                    changePassword,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [Colors.white, Colors.white, greyTextColor8]),
                  ),
                ),
                const SizedBox(
                  height: 35,
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
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(1),
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: TextFormField(
                          maxLines: 1,
                          obscureText: !newPasswordVisibility,
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
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    newPasswordVisibility =
                                        !newPasswordVisibility;
                                  });
                                },
                                child: Icon(
                                  newPasswordVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: textFieldGreyColor,
                                ),
                              )),
                          keyboardType: TextInputType.text,
                        ),
                      ).animate().slide(),
                      const SizedBox(height: 20),
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
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(1),
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: TextFormField(
                          maxLines: 1,
                          obscureText: confirmNewPasswordVisibility,
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
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    confirmNewPasswordVisibility =
                                        !confirmNewPasswordVisibility;
                                  });
                                },
                                child: Icon(
                                  confirmNewPasswordVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: textFieldGreyColor,
                                ),
                              )),
                          keyboardType: TextInputType.text,
                        ),
                      ).animate().slide(),
                      const SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
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
                            save,
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
