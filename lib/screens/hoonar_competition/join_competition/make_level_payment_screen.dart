import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/contest_join_success_screen.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../custom/upper_case_text_formatter.dart';
import '../../../model/request_model/common_request_model.dart';
import '../../../model/request_model/store_payment_request_model.dart';
import '../../../model/success_models/level_list_model.dart';
import '../../../model/success_models/signup_success_model.dart';
import '../../../providers/contest_provider.dart';

class MakeLevelPaymentScreen extends StatefulWidget {
  final bool isDarkMode;
  final int index;
  final LevelListData model;
  final int categoryId;

  const MakeLevelPaymentScreen(
      {super.key,
      required this.isDarkMode,
      required this.index,
      required this.model,
      required this.categoryId});

  @override
  State<MakeLevelPaymentScreen> createState() => _MakeLevelPaymentScreenState();
}

class _MakeLevelPaymentScreenState extends State<MakeLevelPaymentScreen> {
  String discountPrice = '', couponErrorMsg = '';
  bool couponApply = false;
  TextEditingController couponCodeController = TextEditingController();
  SessionManager sessionManager = SessionManager();
  String couponCode = "";

  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> storePayment(
      BuildContext context, StorePaymentRequestModel requestModel) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      await contestProvider.storePayment(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.storePaymentSuccessModel?.status == '200') {
          Navigator.of(context).pop();
          if (requestModel.paymentStatus != 'failed') {
            if (mounted) {
              setState(() {
                KeyRes.selectedLevelId = requestModel.levelId!;
                couponCodeController.text = '';
              });
            }

            Navigator.push(
              context,
              SlideRightRoute(
                  page: ContestJoinSuccessScreen(
                      categoryId: widget.categoryId,
                      levelId: requestModel.levelId.toString())),
            );
          }
        } else if (contestProvider.storePaymentSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.storePaymentSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> applyCouponCode(
      BuildContext context, CommonRequestModel requestModel) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      await contestProvider.applyCouponCode(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.applyCouponCodeModel?.status == '200') {
          if (contestProvider.applyCouponCodeModel != null &&
              contestProvider.applyCouponCodeModel!.data != null) {
            double actualAmount = double.parse(widget.model.fees.toString());

            double discountPercentage = double.parse(
                contestProvider.applyCouponCodeModel!.data!.discountValue!);

            double discountAmount = actualAmount * discountPercentage / 100;

            double payAmount = actualAmount - discountAmount;

            setState(() {
              discountPrice = payAmount.toString();
              couponApply = true;
              couponErrorMsg = '';
            });
          }
        } else if (contestProvider.applyCouponCodeModel?.status == '404') {
          setState(() {
            couponErrorMsg =
                contestProvider.applyCouponCodeModel?.message! ?? '';
          });
          return;
        } else if (contestProvider.applyCouponCodeModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.applyCouponCodeModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    SnackbarUtil.showSnackBar(context,
        "Payment Failed: Code: ${response.code}\nDescription: ${response.message}}");

    int amountPaid = 100 * int.parse(widget.model.fees.toString());

    storePayment(
        context,
        StorePaymentRequestModel(
            userId: signupSuccessModel!.data!.userId!,
            levelId: widget.model.levelId,
            categoryId: widget.categoryId,
            amount: amountPaid.toDouble(),
            couponCode: couponCode,
            isCouponApply: "0",
            actualAmount: widget.model.fees.toString(),
            transactionId: "",
            // transactionId will change when payment gateway received
            paymentStatus:
                'failed' /*(e.g., 'completed', 'pending', 'failed')*/));
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    int amountPaid = 100 * int.parse(widget.model.fees.toString());
    // int amountPaid = 100 * 1;

    storePayment(
        context,
        StorePaymentRequestModel(
            userId: signupSuccessModel!.data!.userId!,
            levelId: widget.model.levelId,
            categoryId: widget.categoryId,
            amount: amountPaid.toDouble(),
            couponCode: couponCode,
            isCouponApply: couponApply ? "1" : "0",
            actualAmount: widget.model.fees.toString(),
            transactionId: response.paymentId,
            // transactionId will change when payment gateway received
            paymentStatus:
                'completed' /*(e.g., 'completed', 'pending', 'failed')*/));
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    SnackbarUtil.showSnackBar(
        context, "External Wallet Selected${response.walletName}");
  }

  SignupSuccessModel? signupSuccessModel;

  getUser() async {
    sessionManager.initPref().then((onValue) {
      signupSuccessModel = sessionManager.getUser()!;
    });
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

    setState(() {
      couponCodeController.text = '';
    });
    getUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus == KeyRes.connectivityCheck
        ? const NoInternetScreen()
        : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GradientText(
                    widget.model.levelName ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: widget.isDarkMode ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.black,
                          Colors.black,
                          Colors.grey.shade700
                        ]),
                  ),
                  Text(
                    AppLocalizations.of(context)!.payNowToBecomeContestant,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      widget.model.description ?? '',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Colors.black, greyTextColor4],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1), // Width of the border
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Background color of the inner container
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (v) {
                                    if (v!.trim().isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .enterCouponCode;
                                    }
                                    return null;
                                  },
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    errorStyle: GoogleFonts.poppins(),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    hintText: AppLocalizations.of(context)!
                                        .enterCouponCode,
                                    hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  controller: couponCodeController,
                                  cursorColor: Colors.black,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                    // Custom Uppercase TextFormatter
                                  ],
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        discountPrice = '';
                                        couponApply = false;
                                        couponErrorMsg = "";
                                      });
                                    }
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (couponCodeController.text.isEmpty) {
                                    setState(() {
                                      couponErrorMsg =
                                          AppLocalizations.of(context)!
                                              .enterCouponCode;
                                    });
                                  } else if (couponApply) {
                                    setState(() {
                                      discountPrice = '';
                                      couponApply = false;
                                      couponCodeController.text = "";
                                    });
                                  } else {
                                    applyCouponCode(
                                        context,
                                        CommonRequestModel(
                                            couponCode:
                                                couponCodeController.text));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Provider.of<ContestProvider>(context)
                                          .isApplyCouponCodeLoading
                                      ? const SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          couponApply
                                              ? AppLocalizations.of(context)!
                                                  .remove
                                              : AppLocalizations.of(context)!
                                                  .apply,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (couponErrorMsg != '')
                    Column(
                      children: [
                        const SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              couponErrorMsg,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (couponApply)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 10),
                                child: Text(
                                  discountPrice == '0.0'
                                      ? '₹ 0/-'
                                      : '₹ $discountPrice/-',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: couponApply ? 0.0 : 25.0),
                              child: Text(
                                '₹ ${widget.model.fees}/-',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                    fontSize: couponApply ? 16 : 18,
                                    color: Colors.black,
                                    fontWeight: couponApply
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    decoration: couponApply
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Provider.of<ContestProvider>(context)
                                  .isStorePaymentLoading
                              ? const Center(
                                  // Centering the progress indicator
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      couponCode = couponCodeController.text;
                                    });

                                    if (discountPrice == "" ||
                                        discountPrice != '0.0') {
                                      Razorpay razorpay = Razorpay();

                                      int amountPaid = 100 *
                                          int.parse(discountPrice == ''
                                              ? widget.model.fees.toString()
                                              : discountPrice);

                                      // int amountPaid = 100 * 1;

                                      var options = {
                                        // 'key': 'rzp_test_sbZKuVhaj5HMeB',
                                        'key': 'rzp_live_SUTM4whjgSbsHL',
                                        'amount': amountPaid,
                                        'name': widget.model.levelName,
                                        // name of the product
                                        'description': widget.model.description,
                                        // description of the product
                                        'retry': {
                                          'enabled': true,
                                          'max_count': 1
                                        },
                                        'send_sms_hash': true,
                                        'prefill': {
                                          'contact': signupSuccessModel!
                                              .data!.userMobileNo,
                                          'email': signupSuccessModel!
                                              .data!.userEmail
                                        },
                                        'external': {
                                          'wallets': ['paytm']
                                        }
                                      };

                                      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                          handlePaymentErrorResponse);
                                      razorpay.on(
                                          Razorpay.EVENT_PAYMENT_SUCCESS,
                                          handlePaymentSuccessResponse);
                                      razorpay.on(
                                          Razorpay.EVENT_EXTERNAL_WALLET,
                                          handleExternalWalletSelected);
                                      razorpay.open(options);
                                    } else {
                                      /*When coupon apply*/
                                      storePayment(
                                          context,
                                          StorePaymentRequestModel(
                                              userId: signupSuccessModel!
                                                  .data!.userId!,
                                              levelId: widget.model.levelId,
                                              categoryId: widget.categoryId,
                                              amount:
                                                  double.parse(discountPrice),
                                              couponCode:
                                                  couponCodeController.text,
                                              transactionId: '',
                                              isCouponApply:
                                                  couponApply ? "1" : "0",
                                              actualAmount:
                                                  widget.model.fees.toString(),
                                              // transactionId will change when payment gateway received
                                              paymentStatus:
                                                  'completed' /*(e.g., 'completed', 'pending', 'failed')*/));
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    margin: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Color(0xFF313131),
                                          Color(0xFF636363)
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.payNow,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
  }
}
