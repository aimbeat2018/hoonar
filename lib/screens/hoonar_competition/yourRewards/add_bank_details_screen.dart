import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/model/request_model/bank_detail_request_model.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/theme.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/snackbar_util.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';

class AddBankDetailsScreen extends StatefulWidget {
  const AddBankDetailsScreen({super.key});

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {
  SessionManager sessionManager = SessionManager();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  String selectedAccountType = "Savings"; // Default account type
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;

  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBankDetails(context);
    });
  }

  Future<void> getBankDetails(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel =
          CommonRequestModel(/*date: _selectedDate*/);

      await contestProvider.getBankDetails(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.bankModel?.status == 200) {
          setState(() {
            accountHolderNameController.text =
                contestProvider.bankModel?.data?.accHolderName ?? '';
            accountNumberController.text =
                contestProvider.bankModel?.data?.accNo ?? '';
            ifscCodeController.text =
                contestProvider.bankModel?.data?.ifscCode ?? '';
            bankNameController.text =
                contestProvider.bankModel?.data?.bankName ?? '';
            branchController.text =
                contestProvider.bankModel?.data?.branchName ?? '';
            selectedAccountType =
                contestProvider.bankModel?.data?.accType ?? 'Savings';
          });
        } else if (contestProvider.bankModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.bankModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> addBankDetails(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      BankDetailsRequestModel requestModel = BankDetailsRequestModel(
          accHolderName: accountHolderNameController.text,
          accNo: accountNumberController.text,
          ifscCode: ifscCodeController.text,
          bankName: bankNameController.text,
          branchName: branchController.text,
          accType: selectedAccountType);

      await contestProvider.addBankDetails(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.addBankRequestModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.addBankRequestModel?.message! ?? '');
        } else if (contestProvider.addBankRequestModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.addBankRequestModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
    setState(() {});
  }

  Future<void> updateBankDetails(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      BankDetailsRequestModel requestModel = BankDetailsRequestModel(
          accHolderName: accountHolderNameController.text,
          accNo: accountNumberController.text,
          ifscCode: ifscCodeController.text,
          bankName: bankNameController.text,
          branchName: branchController.text,
          accType: selectedAccountType);

      await contestProvider.updateBankDetails(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.addBankRequestModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.addBankRequestModel?.message! ?? '');
        } else if (contestProvider.addBankRequestModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.addBankRequestModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 10, bottom: 0),
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
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                  child: GradientText(
                                AppLocalizations.of(context)!.addBankDetails,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: myLoading.isDark
                                      ? Colors.black
                                      : Colors.white,
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
                                      myLoading.isDark
                                          ? greyTextColor8
                                          : Colors.grey.shade700
                                    ]),
                              )),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: (v) {
                                          if (v!.trim().isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .accountHolderName;
                                          }
                                          return null;
                                        },
                                        controller: accountHolderNameController,
                                        style: GoogleFonts.poppins(
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .accountHolderName,
                                          labelStyle: GoogleFonts.poppins(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                        ),
                                      ),
                                      SizedBox(height: 25),
                                      TextFormField(
                                        validator: (v) {
                                          if (v!.trim().isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .accountNumber;
                                          }
                                          return null;
                                        },
                                        controller: accountNumberController,
                                        keyboardType: TextInputType.number,
                                        style: GoogleFonts.poppins(
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .accountNumber,
                                          labelStyle: GoogleFonts.poppins(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                        ),
                                      ),
                                      SizedBox(height: 25),
                                      TextFormField(
                                        validator: (v) {
                                          if (v!.trim().isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .ifscCode;
                                          }
                                          return null;
                                        },
                                        controller: ifscCodeController,
                                        style: GoogleFonts.poppins(
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .ifscCode,
                                          labelStyle: GoogleFonts.poppins(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .accountType,
                                          labelStyle: GoogleFonts.poppins(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                      TextFormField(
                                        validator: (v) {
                                          if (v!.trim().isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .bankName;
                                          }
                                          return null;
                                        },
                                        controller: bankNameController,
                                        style: GoogleFonts.poppins(
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .bankName,
                                          labelStyle: GoogleFonts.poppins(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                        ),
                                      ),
                                      SizedBox(height: 25),
                                      TextFormField(
                                        validator: (v) {
                                          if (v!.trim().isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .branch;
                                          }
                                          return null;
                                        },
                                        controller: branchController,
                                        style: GoogleFonts.poppins(
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14),
                                        decoration: InputDecoration(
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .branch,
                                          labelStyle: GoogleFonts.poppins(
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 14),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  width: 1)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (contestProvider.bankModel ==
                                                    null ||
                                                contestProvider
                                                        .bankModel!.data ==
                                                    null ||
                                                contestProvider.bankModel!.data!
                                                        .bankName ==
                                                    null) {
                                              addBankDetails(context);
                                            } else {
                                              updateBankDetails(context);
                                            }
                                          }
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          margin: const EdgeInsets.only(
                                              top: 15, bottom: 5),
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
                                                  BorderRadius.circular(8),
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
                          if (contestProvider.isBankDetailsLoading)
                            Positioned.fill(
                              top: 0,
                              bottom: 0,
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                // semi-transparent background
                                child: Center(
                                  child: CircularProgressIndicator(),
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
