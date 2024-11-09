import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hoonar/model/request_model/add_help_request_model.dart';
import 'package:hoonar/model/success_models/help_issues_list_model.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../providers/setting_provider.dart';
import '../../auth_screen/login_screen.dart';
import 'help_issues_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController selectIssueController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  int issueId = -1;
  final GlobalKey<FormState> _formKey = GlobalKey();
  SessionManager sessionManager = SessionManager();

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
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
                    height: 10,
                  ),
                  Center(
                    child: GradientText(
                      AppLocalizations.of(context)!.help,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: myLoading.isDark ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [
                            myLoading.isDark ? Colors.white : Colors.black,
                            myLoading.isDark ? Colors.white : Colors.black,
                            myLoading.isDark
                                ? greyTextColor8
                                : Colors.grey.shade700
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            AppLocalizations.of(context)!.helpName,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextFormField(
                            validator: (v) {
                              if (v!.trim().isEmpty) {
                                return AppLocalizations.of(context)!.helpName;
                              }
                              /* else if (v.length != 10) {
                                  return AppLocalizations.of(context)!
                                      .enterValidPhoneNumber;
                                }*/
                              return null;
                            },
                            maxLines: 1,
                            controller: nameController,
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
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
                              hintText: AppLocalizations.of(context)!.helpName,
                              hintStyle: GoogleFonts.poppins(
                                color: hintGreyColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            AppLocalizations.of(context)!.helpEmail,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextFormField(
                            validator: (v) {
                              if (v!.trim().isEmpty) {
                                return AppLocalizations.of(context)!.helpEmail;
                              }
                              /* else if (v.length != 10) {
                                  return AppLocalizations.of(context)!
                                      .enterValidPhoneNumber;
                                }*/
                              return null;
                            },
                            maxLines: 1,
                            controller: emailController,
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
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
                              hintText: AppLocalizations.of(context)!.helpEmail,
                              hintStyle: GoogleFonts.poppins(
                                color: hintGreyColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            AppLocalizations.of(context)!.helpPhone,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                            controller: phoneController,
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
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
                              hintText: AppLocalizations.of(context)!.helpPhone,
                              hintStyle: GoogleFonts.poppins(
                                color: hintGreyColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            AppLocalizations.of(context)!.helpSelectIssue,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextFormField(
                            validator: (v) {
                              if (v!.trim().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .helpSelectIssue;
                              }
                              /* else if (v.length != 10) {
                                  return AppLocalizations.of(context)!
                                      .enterValidPhoneNumber;
                                }*/
                              return null;
                            },
                            maxLines: 1,
                            readOnly: true,
                            controller: selectIssueController,
                            onTap: () {
                              _showIssueBottomSheet(context, myLoading.isDark);
                            },
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
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
                                hintText: AppLocalizations.of(context)!
                                    .helpSelectIssue,
                                hintStyle: GoogleFonts.poppins(
                                  color: hintGreyColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                suffixIcon: Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                )),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            AppLocalizations.of(context)!.helpMessage,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextFormField(
                            validator: (v) {
                              if (v!.trim().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .helpMessage;
                              }
                              /* else if (v.length != 10) {
                                  return AppLocalizations.of(context)!
                                      .enterValidPhoneNumber;
                                }*/
                              return null;
                            },
                            maxLines: 5,
                            controller: messageController,
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
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
                              hintText:
                                  AppLocalizations.of(context)!.helpMessage,
                              hintStyle: GoogleFonts.poppins(
                                color: hintGreyColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Provider.of<SettingProvider>(context)
                                .isAddHelpRequestLoading
                            ? const Center(child: CircularProgressIndicator())
                            : InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    addHelpRequest(context);
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  margin: const EdgeInsets.only(
                                      top: 15, left: 60, right: 60, bottom: 5),
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
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.send,
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
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: ShapeDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(1.00, 0.00),
                                    end: Alignment(-1, 0),
                                    colors: [
                                      Color(0xFF9D9D9D),
                                      Color(0xFF5A5A5A)
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.13),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/phone.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .helpCallUs
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: ShapeDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(1.00, 0.00),
                                    end: Alignment(-1, 0),
                                    colors: [
                                      Color(0xFF9D9D9D),
                                      Color(0xFF5A5A5A)
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.13),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/mail.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .helpMailUs
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        )
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

  void _showIssueBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade900 : Colors.white,
              // Adjust as per your theme
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: HelpIssuesScreen(
                isDarkMode: isDarkMode,
              ),
            ));
      },
    ).then((value) {
      if (value != null) {
        HelpIssuesListData model = value;
        selectIssueController.text = model.issueName ?? '';
        issueId = model.issueId ?? -1;
        setState(() {});
      }
    });
  }

  Future<void> addHelpRequest(BuildContext context) async {
    final contestProvider =
        Provider.of<SettingProvider>(context, listen: false);
    sessionManager.initPref().then((onValue) async {
      AddHelpRequestModel requestModel = AddHelpRequestModel(
          name: nameController.text,
          phone: phoneController.text,
          email: emailController.text,
          issueId: issueId,
          message: messageController.text);

      await contestProvider.addHelpRequest(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.addHelpRequestModel?.status == '200') {
          Navigator.pop(context);
        } else if (contestProvider.addHelpRequestModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.addHelpRequestModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        }
      }
    });
  }
}
