import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_async_autocomplete/flutter_async_autocomplete.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/model/success_models/city_list_model.dart';
import 'package:hoonar/model/success_models/state_list_model.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/screens/auth_screen/create_password_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/my_loading/my_loading.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool accept = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String selectedStateId = "", selectedCityId = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
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
              fit:
                  BoxFit.cover, // Ensures the image covers the entire container
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
                  buildAppbar(context, false),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.signup,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: myLoading.isDark ? Colors.white : Colors.black,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.fullName,
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
                                      .enterFullName;
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                              ),
                              controller: fullNameController,
                              cursorColor: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.name,
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              AppLocalizations.of(context)!.email,
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
                                      .enterEmail;
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                              ),
                              controller: emailController,
                              cursorColor: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
                                contentPadding: const EdgeInsets.symmetric(
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
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.dob,
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
                                  return AppLocalizations.of(context)!.enterDob;
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                              ),
                              controller: dobController,
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
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.pinCode,
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
                                      .enterPincode;
                                }
                                return null;
                              },
                              maxLines: 1,
                              controller: pinCodeController,
                              cursorColor: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              style: GoogleFonts.poppins(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                errorStyle: GoogleFonts.poppins(),
                                border: GradientOutlineInputBorder(
                                  width: 1,
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
                                    horizontal: 10, vertical: 3),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.state,
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
                                      child: AsyncAutocomplete<StateListData>(
                                        controller: stateController,
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .selectCity;
                                          }
                                          return null;
                                        },
                                        onTapItem: (StateListData stateData) {
                                          stateController.text =
                                              stateData.name ?? '';
                                          setState(() {
                                            selectedStateId =
                                                stateData.id.toString();
                                          });
                                        },
                                        suggestionBuilder: (data) => ListTile(
                                          title: Text(
                                            data.name ?? '',
                                            style: GoogleFonts.poppins(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        asyncSuggestions: (searchValue) async {
                                          return await Provider.of<
                                                      AuthProvider>(context,
                                                  listen: false)
                                              .getFilteredStates(searchValue);
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.black,
                                          errorStyle: GoogleFonts.poppins(),
                                          border: GradientOutlineInputBorder(
                                            width: 1,
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
                                                  vertical: 3, horizontal: 20),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: textFieldGreyColor,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: textFieldGreyColor,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.city,
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
                                          horizontal: 8.0),
                                      child: AsyncAutocomplete<CityListData>(
                                        controller: cityController,
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .selectCity;
                                          }
                                          return null;
                                        },
                                        onTapItem: (CityListData cityData) {
                                          cityController.text =
                                              cityData.name ?? '';
                                        },
                                        suggestionBuilder: (data) => ListTile(
                                          title: Text(
                                            data.name ?? '',
                                            style: GoogleFonts.poppins(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        asyncSuggestions: (searchValue) async {
                                          return await Provider.of<
                                                      AuthProvider>(context,
                                                  listen: false)
                                              .getFilteredCities(
                                                  searchValue, selectedStateId);
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.black,
                                          errorStyle: GoogleFonts.poppins(),
                                          border: GradientOutlineInputBorder(
                                            width: 1,
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
                                                  vertical: 3, horizontal: 20),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: textFieldGreyColor,
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                              color: textFieldGreyColor,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              AppLocalizations.of(context)!.school,
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
                          Container(
                            padding: const EdgeInsets.all(1),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                // Background color for TextFormField
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                maxLines: 1,
                                controller: schoolController,
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
                                  filled: true,
                                  fillColor: Colors.black,
                                  errorStyle: GoogleFonts.poppins(),
                                  border: GradientOutlineInputBorder(
                                    width: 1,
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Row(
                              children: [
                                Checkbox(
                                    side: const BorderSide(color: Colors.white),
                                    checkColor: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    focusColor: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    activeColor: Colors.grey,
                                    value: accept,
                                    onChanged: (value) {
                                      setState(() {
                                        accept = !accept;
                                      });
                                    }),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .acceptTer,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .privacyPolicy,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: const Color(0xFFFFCDB3),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              callRegisterApi();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              margin: const EdgeInsets.only(
                                  top: 15, left: 60, right: 60, bottom: 10),
                              decoration: ShapeDecoration(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.createAcc,
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  callRegisterApi() {
    if (_formKey.currentState!.validate()) {}

    /*Navigator.push(
                              context,
                              SlideRightRoute(
                                  page: const CreatePasswordScreen(
                                from: 'register',
                              )),
                            )*/
  }
}
