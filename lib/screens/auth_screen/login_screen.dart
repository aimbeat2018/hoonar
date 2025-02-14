import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/model/request_model/sign_in_request_model.dart';
import 'package:hoonar/screens/auth_screen/check_mobile_number_screen.dart';
import 'package:hoonar/screens/auth_screen/forgot_password_screen.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/color_constants.dart';
import '../../constants/internet_connectivity.dart';
import '../../constants/key_res.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/no_internet_screen.dart';
import '../../constants/session_manager.dart';
import '../../custom/snackbar_util.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool passwordError = false, mobileError = false, passwordVisible = true;
  bool remeberme = false;
  bool _isObscure = true;
  String deviceName = '';
  String deviceType = '';
  SessionManager sessionManager = SessionManager();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  void initState() {
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

    fetchDeviceInfo();
    getRememberMeDetails();
  }

  Future<void> fetchDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      // For Android
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceName = "${androidInfo.brand}\n${androidInfo.model}";
        // print("device : ${androidInfo.brand}");
        // print(androidInfo.model);
        // print(androidInfo.device);
        // print(androidInfo.manufacturer);
        // print(androidInfo.product);
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

  getRememberMeDetails() async {
    await sessionManager.initPref();
    if (sessionManager.getBool(SessionManager.rememberMe)!) {
      phoneController.text =
          sessionManager.getString(SessionManager.userEmail) ?? "";
      passwordController.text =
          sessionManager.getString(SessionManager.userPassword) ?? "";
      remeberme = sessionManager.getBool(SessionManager.rememberMe) ?? false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            myLoading.isDark
                                ? 'assets/images/splash_logo.png'
                                : 'assets/images/splash_logo_black.png',
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
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.phoneNumber,
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
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: TextFormField(
                                    validator: (v) {
                                      if (v!.trim().isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .enterPhoneNumber;
                                      }
                                      /* else if (v.length != 10) {
                                  return AppLocalizations.of(context)!
                                      .enterValidPhoneNumber;
                                }*/
                                      return null;
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: /*myLoading.isDark
                                      ? Colors.white
                                      : */
                                            Colors.black,
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
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3)),
                                    controller: phoneController,
                                    cursorColor: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    style: GoogleFonts.poppins(
                                      color: /*myLoading.isDark
                                    ? Colors.black
                                    :*/
                                          Colors.white,
                                      fontSize: 14,
                                    ),
                                    keyboardType: TextInputType.text,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.digitsOnly,
                                    //   LengthLimitingTextInputFormatter(10),
                                    // ],
                                    onChanged: (value) {
                                      saveDetailsForRememberMe();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.password,
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
                                    obscureText: _isObscure,
                                    controller: passwordController,
                                    cursorColor: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    style: GoogleFonts.poppins(
                                      color: /*myLoading.isDark
                                    ?*/
                                          Colors.white /*: Colors.black*/,
                                      fontSize: 14,
                                    ),
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
                                    onChanged: (value) {
                                      saveDetailsForRememberMe();
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        side: BorderSide(
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            strokeAlign:
                                                BorderSide.strokeAlignInside),
                                        checkColor: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        focusColor: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        activeColor: Colors.grey,
                                        value: remeberme,
                                        onChanged: (value) {
                                          saveDetailsForRememberMe();

                                          setState(() {
                                            remeberme = !remeberme;
                                          });
                                        }),
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .rememberMe,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: const ForgotPasswordScreen()),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .forgotPass,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                authProvider.isSignUpLoading
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 5),
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          callLoginApi(context);
                                        },
                                        child: Container(
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
                                              side: BorderSide(
                                                strokeAlign: BorderSide
                                                    .strokeAlignOutside,
                                                color: myLoading.isDark
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                            ),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!.login,
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
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const CheckMobileNumberScreen()),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
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
                                        side: const BorderSide(
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside,
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
                        // Center(
                        //   child: Text(
                        //     AppLocalizations.of(context)!.loginWith,
                        //     textAlign: TextAlign.center,
                        //     style: GoogleFonts.poppins(
                        //       fontSize: 14,
                        //       color: myLoading.isDark ? Colors.white : Colors.black,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        /*     Row(
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
                  )*/
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }

// Function to save the credentials when "Remember Me" is selected
  Future<void> saveDetailsForRememberMe() async {
    await sessionManager.initPref();
    if (remeberme) {
      sessionManager.saveString(SessionManager.userEmail, phoneController.text);
      sessionManager.saveString(
          SessionManager.userPassword, passwordController.text);
      sessionManager.saveBoolean(SessionManager.rememberMe, remeberme);
    } else {
      sessionManager.cleanString(SessionManager.userEmail);
      sessionManager.cleanString(SessionManager.userPassword);
      sessionManager.saveBoolean(SessionManager.rememberMe, remeberme);
    }
  }

  Future<void> callLoginApi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FirebaseMessaging.instance.getToken().then((value) async {
        String? fcmToken = value;

        SignInRequestModel requestModel = SignInRequestModel();
        requestModel.identity = phoneController.text;
        requestModel.password = passwordController.text;
        requestModel.deviceToken = fcmToken;
        requestModel.deviceName = deviceName;
        requestModel.deviceType = 'mobile';
        requestModel.deviceOs = deviceType;

        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await authProvider.signInUser(requestModel);

        if (authProvider.errorMessage != null) {
          SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
        } else {
          if (authProvider.signupSuccessModel?.status == '200') {
            SnackbarUtil.showSnackBar(
                context, authProvider.signupSuccessModel?.message! ?? '');

            Navigator.pushAndRemoveUntil(
                context,
                SlideRightRoute(page: const MainScreen(fromIndex: 0)),
                (route) => false);
          } else {
            SnackbarUtil.showSnackBar(
                context, authProvider.signupSuccessModel?.message! ?? '');
          }
        }
      });
    }
  }
}
