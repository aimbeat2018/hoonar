import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/theme.dart';

class AddBankDetailsScreen extends StatefulWidget {
  const AddBankDetailsScreen({super.key});

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  String selectedAccountType = "Savings"; // Default account type

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(myLoading.isDark
                  ? 'assets/images/screens_back.png'
                  : 'assets/dark_mode_icons/white_screen_back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, top: 10, bottom: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/images/back_image.png',
                            height: 28,
                            width: 28,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: GradientText(
                        AppLocalizations.of(context)!.addBankDetails,
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
                      )

                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: accountHolderNameController,
                              style: GoogleFonts.poppins(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                labelText: AppLocalizations.of(context)!
                                    .accountHolderName,
                                labelStyle: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                              ),
                            ),
                            SizedBox(height: 25),
                            TextField(
                              controller: accountNumberController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.poppins(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                labelText:
                                    AppLocalizations.of(context)!.accountNumber,
                                labelStyle: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                              ),
                            ),
                            SizedBox(height: 25),
                            TextField(
                              controller: ifscCodeController,
                              style: GoogleFonts.poppins(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                labelText:
                                    AppLocalizations.of(context)!.ifscCode,
                                labelStyle: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                              ),
                            ),
                            SizedBox(height: 25),
                            DropdownButtonFormField<String>(
                              value: selectedAccountType,
                              style: GoogleFonts.poppins(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                labelText:
                                    AppLocalizations.of(context)!.accountType,
                                labelStyle: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                              ),
                              items: <String>['Savings', 'Current']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedAccountType = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 25),
                            TextField(
                              controller: bankNameController,
                              style: GoogleFonts.poppins(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                labelText:
                                    AppLocalizations.of(context)!.bankName,
                                labelStyle: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                              ),
                            ),
                            SizedBox(height: 25),
                            TextField(
                              controller: branchController,
                              style: GoogleFonts.poppins(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.branch,
                                labelStyle: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        width: 1)),
                              ),
                            ),
                            SizedBox(height: 32),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 5),
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
                                    borderRadius: BorderRadius.circular(8),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
