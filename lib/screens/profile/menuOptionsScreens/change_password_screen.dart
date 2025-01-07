import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/check_user_request_model.dart';
import '../../../providers/auth_provider.dart';
import '../../auth_screen/login_screen.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey();
  SessionManager sessionManager = SessionManager();
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      CheckUserRequestModel requestModel =
          CheckUserRequestModel(password: newpassController.text);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      sessionManager.initPref().then((onValue) async {
        await authProvider.updatePassword(requestModel,
            sessionManager.getString(SessionManager.accessToken) ?? '');

        if (authProvider.errorMessage != null) {
          SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
        } else {
          if (authProvider.changePasswordModel?.status == '200') {
            Navigator.pop(context);
          } else if (authProvider.changePasswordModel?.message ==
              'Unauthorized Access!') {
            SnackbarUtil.showSnackBar(
                context, authProvider.changePasswordModel?.message! ?? '');
            Navigator.pushAndRemoveUntil(context,
                SlideRightRoute(page: LoginScreen()), (route) => false);
          }
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckInternet.initConnectivity().then((value) => setState(() {
          _connectionStatus = value;
        }));

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      CheckInternet.updateConnectionStatus(result).then((value) => setState(() {
            _connectionStatus = value;
          }));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    /*image: DecorationImage(
            image: AssetImage('assets/images/screens_back.png'),
            // Path to your image
            fit: BoxFit.cover, // Ensures the image covers the entire container
          ),*/
                    color: myLoading.isDark ? Colors.black : Colors.white),
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
                        buildAppbar(context, myLoading.isDark),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: GradientText(
                            AppLocalizations.of(context)!.changePassword,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: [
                                  myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  greyTextColor8
                                ]),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: TextFormField(
                                  maxLines: 1,
                                  validator: (v) {
                                    if (v!.trim().isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .enterNewPassword;
                                    }
                                    return null;
                                  },
                                  obscureText: newPasswordVisibility,
                                  controller: newpassController,
                                  cursorColor: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  style: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                ).animate().slide(),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
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
                                  cursorColor: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  style: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                ).animate().slide(),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              InkWell(
                                onTap: () {
                                  changePassword(context);
                                },
                                child: Provider.of<AuthProvider>(context)
                                        .isChangePasswordLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        margin: const EdgeInsets.only(
                                            top: 15,
                                            left: 60,
                                            right: 60,
                                            bottom: 5),
                                        decoration: ShapeDecoration(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              strokeAlign:
                                                  BorderSide.strokeAlignOutside,
                                              color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(80),
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
