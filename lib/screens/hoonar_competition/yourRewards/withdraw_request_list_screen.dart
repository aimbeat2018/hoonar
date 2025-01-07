import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/success_models/withdraw_request_list_model.dart';
import 'package:hoonar/shimmerLoaders/wallet_transaction_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/theme.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';

class WithdrawRequestListScreen extends StatefulWidget {
  final String totalAmount;

  const WithdrawRequestListScreen({super.key, required this.totalAmount});

  @override
  State<WithdrawRequestListScreen> createState() =>
      _WithdrawRequestListScreenState();
}

class _WithdrawRequestListScreenState extends State<WithdrawRequestListScreen> {
  SessionManager sessionManager = SessionManager();
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
      getWithdrawRequest(context);
    });
  }

  Future<void> getWithdrawRequest(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(/*date: _selectedDate*/);

      await contestProvider.getWithdrawRequestList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.withdrawRequestListModel?.status == '200') {
          setState(() {});
        } else if (contestProvider.withdrawRequestListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.withdrawRequestListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
    setState(() {});
  }

  Future<void> addWithdrawRequest(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel =
          CommonRequestModel(amount: widget.totalAmount);

      await contestProvider.addWithdrawRequest(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.addWithdrawRequestModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.addWithdrawRequestModel?.message! ?? '');
          Navigator.of(context).pop();
        } else if (contestProvider.addWithdrawRequestModel?.status == '400') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.addWithdrawRequestModel?.message! ?? '');
          Navigator.of(context).pop();
        } else if (contestProvider.addWithdrawRequestModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.addWithdrawRequestModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });

    setState(() {
      isLoading = false;
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
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: InkWell(
                onTap: () {
                  showWithdrawDialog(context, myLoading.isDark);
                },
                child: Container(
                  height: 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: myLoading.isDark ? Colors.white : Colors.black),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.withdraw_request,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: myLoading.isDark ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
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
                              AppLocalizations.of(context)!
                                  .withdraw_request_list,
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
                              height: 20,
                            ),
                            contestProvider.isWithdrawTransactionLoading ||
                                    contestProvider.withdrawRequestListModel ==
                                        null
                                ? const WalletTransactionShimmer()
                                : contestProvider.withdrawRequestListModel!
                                                .data ==
                                            null ||
                                        contestProvider
                                            .withdrawRequestListModel!
                                            .data!
                                            .isEmpty
                                    ? DataNotFound()
                                    : ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        shrinkWrap: true,
                                        itemCount: contestProvider
                                            .withdrawRequestListModel!
                                            .data!
                                            .length,
                                        itemBuilder: (context, index) {
                                          WithdrawRequestList model =
                                              contestProvider
                                                  .withdrawRequestListModel!
                                                  .data![index];
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    width: 1)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0,
                                                  bottom: 15,
                                                  right: 10,
                                                  left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 6),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: myLoading
                                                                    .isDark
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          child: Text(
                                                            model.status ?? '',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 14,
                                                              color: myLoading
                                                                      .isDark
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${model.amount} coins',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          color: myLoading
                                                                  .isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    'date: ${model.transactionDate}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: myLoading.isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                          ],
                        ),
                        if (isLoading)
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
            );
    });
  }

  void showWithdrawDialog(BuildContext context1, bool isDarkMode) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.withdraw_request,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!
                .areYouSureYouWantToWithdraw(widget.totalAmount),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.withdraw,
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () {
                addWithdrawRequest(context1);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
