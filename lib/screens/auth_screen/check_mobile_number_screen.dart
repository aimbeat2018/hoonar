import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/custom_dialog.dart';
import 'package:hoonar/model/request_model/check_user_request_model.dart';
import 'package:hoonar/model/request_model/signup_request_model.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:hoonar/screens/auth_screen/signup_screen.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';

import '../../constants/internet_connectivity.dart';
import '../../constants/key_res.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/no_internet_screen.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/snackbar_util.dart';

class CheckMobileNumberScreen extends StatefulWidget {
  const CheckMobileNumberScreen({super.key});

  @override
  State<CheckMobileNumberScreen> createState() =>
      _CheckMobileNumberScreenState();
}

class _CheckMobileNumberScreenState extends State<CheckMobileNumberScreen> {
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool isOtpSent = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  TextEditingController phoneController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String enteredOtp = "", receivedOtp = "";

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
    scrollController.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              // resizeToAvoidBottomInset: false,
              body: Container(
                padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(myLoading.isDark
                        ? 'assets/images/background.png'
                        : 'assets/images/bg_wht.png'),
                    // Path to your image
                    fit: BoxFit
                        .cover, // Ensures the image covers the entire container
                  ),
                ),
                child: Scrollbar(
                  controller: scrollController,
                  // Add a ScrollController
                  thumbVisibility: true,
                  thickness: 2.5,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildAppbar(context, myLoading.isDark),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.signup,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: !isOtpSent,
                          child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: TextFormField(
                                      validator: (v) {
                                        if (v!.trim().isEmpty) {
                                          return AppLocalizations.of(context)!
                                              .enterPhoneNumberError;
                                        } else if (v.length != 10) {
                                          return AppLocalizations.of(context)!
                                              .enterValidPhoneNumber;
                                        }
                                        return null;
                                      },
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.black,
                                        errorStyle: GoogleFonts.poppins(),
                                        border: GradientOutlineInputBorder(
                                          width: 1,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                      ),
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
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  authProvider.isSignUpLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            callRegisterApi();
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            margin: const EdgeInsets.only(
                                                top: 15,
                                                left: 60,
                                                right: 60,
                                                bottom: 10),
                                            decoration: ShapeDecoration(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  strokeAlign: BorderSide
                                                      .strokeAlignOutside,
                                                  color: Colors.black,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                              ),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .sendOtp,
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
                            visible: isOtpSent,
                            child: Column(
                              children: [
                                Text.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .otpSentMsg,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "\n+91 ${phoneController.text} ",
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
                                              isOtpSent = !isOtpSent;
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
                                    // print('Entered pin is $text');
                                  },
                                  onChange: (text) {
                                    setState(() {
                                      enteredOtp = text;
                                    });
                                  },
                                  onCodeChanged: (code) {
                                    setState(() {
                                      enteredOtp = code;
                                    });
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
                                        myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        greyTextColor4
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    filledFieldBorderGradient: LinearGradient(
                                      colors: [
                                        myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        greyTextColor4
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    defaultFieldBorderGradient: LinearGradient(
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
                                  maxLength: 4,
                                  showCursor: true,
                                  cursorColor: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  cursorWidth: 3,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  otpPinFieldDecoration: OtpPinFieldDecoration
                                      .defaultPinBoxDecoration,
                                ),
                                const SizedBox(height: 68),
                                InkWell(
                                  onTap: () {
                                    if (enteredOtp.isEmpty) {
                                      SnackbarUtil.showSnackBar(
                                          context,
                                          AppLocalizations.of(context)!
                                              .enterOtp);
                                    } else if (enteredOtp != receivedOtp) {
                                      SnackbarUtil.showSnackBar(
                                          context,
                                          AppLocalizations.of(context)!
                                              .enterValidOtp);
                                    } else {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          SlideRightRoute(
                                              page: SignupScreen(
                                            mobileNumber: phoneController.text,
                                          )),
                                          (route) => false);
                                    }
                                  },
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
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside,
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
              ),
            );
    });
  }

  Future<void> callRegisterApi() async {
    if (_formKey.currentState!.validate()) {
      SignupRequestModel requestModel = SignupRequestModel(
        mobileNo: phoneController.text,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.checkUserMobile(requestModel);

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else {
        if (authProvider.sendRegisterOtpSuccessModel?.status == '200') {
          SnackbarUtil.showSnackBar(context,
              authProvider.sendRegisterOtpSuccessModel?.message! ?? '');

          setState(() {
            isOtpSent = !isOtpSent;

            receivedOtp =
                authProvider.sendRegisterOtpSuccessModel!.otp!.toString();
          });
        } else {
          SnackbarUtil.showSnackBar(context,
              authProvider.sendRegisterOtpSuccessModel?.message! ?? '');
        }
      }

    }
  }
}
