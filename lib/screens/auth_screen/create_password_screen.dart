import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/custom/snackbar_util.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/my_loading/my_loading.dart';
import '../../model/request_model/check_user_request_model.dart';
import '../../model/request_model/signup_request_model.dart';
import '../../providers/auth_provider.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String from;
  final SignupRequestModel? requestModel;
  final String? mobile;

  const CreatePasswordScreen(
      {super.key, required this.from, this.requestModel, this.mobile});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  TextEditingController newpassController = TextEditingController();
  TextEditingController conpassController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool newPasswordVisibility = true, confirmNewPasswordVisibility = true;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
              fit: BoxFit.cover,
            ),
          ),
          child: Scrollbar(
            controller: scrollController,
            // Add a ScrollController
            thumbVisibility: true,
            thickness: 2.5,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppbar(context, myLoading.isDark),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.createPass,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: myLoading.isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.newPassword,
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterNewPassword;
                                }
                                return null;
                              },
                              maxLines: 1,
                              obscureText: newPasswordVisibility,
                              controller: newpassController,
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
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        newPasswordVisibility =
                                            !newPasswordVisibility;
                                      });
                                    },
                                    child: Icon(
                                      newPasswordVisibility
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: textFieldGreyColor,
                                    ),
                                  )),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.confirmPassword,
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              validator: (v) {
                                if (v!.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterConfirmNewPassword;
                                } else if (v != newpassController.text) {
                                  return AppLocalizations.of(context)!
                                      .newPasswordAndConfirmPasswordShouldMatch;
                                }
                                return null;
                              },
                              maxLines: 1,
                              obscureText: confirmNewPasswordVisibility,
                              controller: conpassController,
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
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: textFieldGreyColor,
                                    ),
                                  )),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          authProvider.isSignUpLoading
                              ? const Center(
                                  child:
                                      CircularProgressIndicator()) // Show loader when signing up
                              : InkWell(
                                  onTap: () => widget.from == 'forgot'
                                      ? changePassword(context)
                                      : callRegisterApi(context),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
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
                                        side: const BorderSide(
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.letsGo,
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
        ),
      );
    });
  }

  Future<void> changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      CheckUserRequestModel requestModel = CheckUserRequestModel(
          mobileNo: widget.mobile, password: newpassController.text);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.changePasswordForget(requestModel);

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else {
        if (authProvider.sendOtpSuccessModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, authProvider.sendOtpSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        } else {
          SnackbarUtil.showSnackBar(
              context, authProvider.sendOtpSuccessModel?.message! ?? '');
        }
      }
    }
  }

  Future<void> callRegisterApi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FirebaseMessaging.instance.getToken().then((value) async {
        String? fcmToken = value;

        widget.requestModel?.deviceToken = fcmToken;
        widget.requestModel?.password = newpassController.text;

        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await authProvider.signUpUser(widget.requestModel!);

        if (authProvider.errorMessage != null) {
          SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
        } else {
          if (authProvider.signupSuccessModel?.status == '200') {
            SnackbarUtil.showSnackBar(
                context, authProvider.signupSuccessModel?.message! ?? '');
            Navigator.pushAndRemoveUntil(context,
                SlideRightRoute(page: LoginScreen()), (route) => false);
          } else {
            SnackbarUtil.showSnackBar(
                context, authProvider.signupSuccessModel?.message! ?? '');
          }
        }
      });
    }
  }
}
