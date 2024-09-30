import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/text_constants.dart';
import '../../../constants/theme.dart';

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
                  buildAppbar(context, false),
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
                        Container(
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black)),
                          child: TextFormField(
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
                              border: InputBorder.none,
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
                        Container(
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black)),
                          child: TextFormField(
                            maxLines: 1,
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
                            style: GoogleFonts.poppins(
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
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
                        Container(
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black)),
                          child: TextFormField(
                            maxLines: 1,
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
                            style: GoogleFonts.poppins(
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
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
                        Container(
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black)),
                          child: TextFormField(
                            maxLines: 1,
                            readOnly: true,
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
                            style: GoogleFonts.poppins(
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
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
                        Container(
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black)),
                          child: TextFormField(
                            maxLines: 5,
                            cursorColor:
                                myLoading.isDark ? Colors.white : Colors.black,
                            style: GoogleFonts.poppins(
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
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
}
