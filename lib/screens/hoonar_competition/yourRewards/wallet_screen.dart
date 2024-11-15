import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/success_models/wallet_transaction_list_model.dart';
import 'package:hoonar/shimmerLoaders/wallet_transaction_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/theme.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWalletTransaction(context);
    });
  }

  Future<void> getWalletTransaction(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(/*date: _selectedDate*/);

      await contestProvider.getWalletTransaction(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.walletTransactionListModel?.status == '200') {
        } else if (contestProvider.walletTransactionListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.walletTransactionListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  String formatTransactionDate(String transactionDate) {
    // Parse the original date string into a DateTime object
    DateTime parsedDate = DateTime.parse(transactionDate);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('d MMMM yyyy').format(parsedDate);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

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
                          color: myLoading.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Center(
                      child: GradientText(
                    AppLocalizations.of(context)!.wallet,
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
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  contestProvider.isWalletTransactionLoading || contestProvider.walletTransactionListModel==null
                      ? const WalletTransactionShimmer()
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .availableBalance,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  contestProvider.walletTransactionListModel!
                                              .walletBalance !=
                                          null
                                      ? '${contestProvider.walletTransactionListModel!.walletBalance} coins'
                                      : '0 coins',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: myLoading.isDark
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade400,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/wallet.png',
                                    height: 23,
                                    width: 23,
                                    color: myLoading.isDark
                                        ? Color(0xff7D7D7D)
                                        : Colors.grey.shade900,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .rechargeHistory,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: myLoading.isDark
                                          ? Color(0xff7D7D7D)
                                          : Colors.grey.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            contestProvider.walletTransactionListModel!.data ==
                                        null ||
                                    contestProvider.walletTransactionListModel!
                                        .data!.isEmpty
                                ? DataNotFound()
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    shrinkWrap: true,
                                    itemCount: contestProvider
                                        .walletTransactionListModel!
                                        .data!
                                        .length,
                                    itemBuilder: (context, index) {
                                      WalletTransactionData model =
                                          contestProvider
                                              .walletTransactionListModel!
                                              .data![index];
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
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
                                              top: 15.0, bottom: 15, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  child: Text(
                                                    'Date - ${formatTransactionDate(model.transactionDate ?? '')}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: myLoading.isDark
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${model.amount} coins',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
