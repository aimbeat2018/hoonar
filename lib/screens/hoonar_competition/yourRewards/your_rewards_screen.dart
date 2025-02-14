import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/providers/contest_provider.dart';
import 'package:hoonar/screens/hoonar_competition/yourRewards/wallet_screen.dart';
import 'package:hoonar/shimmerLoaders/grid_shimmer.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../constants/theme.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../auth_screen/login_screen.dart';
import 'add_bank_details_screen.dart';

class YourRewardsScreen extends StatefulWidget {
  const YourRewardsScreen({super.key});

  @override
  State<YourRewardsScreen> createState() => _YourRewardsScreenState();
}

class _YourRewardsScreenState extends State<YourRewardsScreen> {
  SessionManager sessionManager = SessionManager();
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
      getRewardsList(context);
    });
  }

  Future<void> getRewardsList(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(/*date: _selectedDate*/);

      await contestProvider.getRewardsList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.rewardListModel?.status == '200') {
        } else if (contestProvider.rewardListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.rewardListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> claimReward(
      BuildContext context, String rewardId, int index) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel = CommonRequestModel(rewardId: rewardId);

      await contestProvider.claimRewards(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.claimRewardsModel?.status == '200') {
          setState(() {
            contestProvider.rewardListModel!.data![index].rewardStatus =
                'claimed';
          });
        } else if (contestProvider.claimRewardsModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.claimRewardsModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  bool isExpired(String date) {
    // Parse the input date
    DateTime parsedDate = DateTime.parse(date);

    // Get today's date without the time
    DateTime today = DateTime.now();
    DateTime currentDate = DateTime(today.year, today.month, today.day);

    // Get the input date without the time
    DateTime inputDate =
        DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

    // Compare only the dates
    return currentDate.isAfter(inputDate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final contestProvider = Provider.of<ContestProvider>(context);
    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 2 : 3;
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 13),
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
                              Expanded(
                                child: Center(
                                    child: GradientText(
                                  AppLocalizations.of(context)!.rewards,
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
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: menuItemsWidget(myLoading.isDark))
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          contestProvider.isRewardsLoading ||
                                  contestProvider.rewardListModel == null
                              ? const GridShimmer()
                              : contestProvider.rewardListModel!.data == null ||
                                      contestProvider
                                          .rewardListModel!.data!.isEmpty
                                  ? const DataNotFound()
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 15,
                                        childAspectRatio:
                                            0.9, // Adjust according to image dimensions
                                      ),
                                      itemCount: contestProvider
                                          .rewardListModel!.data!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              // image: DecorationImage(
                                              //   image: AssetImage(
                                              //       rewardsList[index].rank),
                                              //   fit: BoxFit.cover,
                                              // ),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.55),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: contestProvider
                                                                  .rewardListModel!
                                                                  .data![index]
                                                                  .image ??
                                                              '',

                                                          placeholder:
                                                              (context, url) =>
                                                                  const Center(
                                                            child: SizedBox(
                                                                height: 15,
                                                                width: 15,
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              buildInitialsAvatar(
                                                                  'No Image',
                                                                  fontSize: 12),
                                                          fit: BoxFit.cover,
                                                          // width: 80,
                                                          // // Match the size of the CircleAvatar
                                                          // height: 80,
                                                        )),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      contestProvider
                                                              .rewardListModel!
                                                              .data![index]
                                                              .rewardName ??
                                                          '',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: Text(
                                                        contestProvider
                                                                .rewardListModel!
                                                                .data![index]
                                                                .description ??
                                                            '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                    contestProvider
                                                                .rewardListModel!
                                                                .data![index]
                                                                .rewardStatus !=
                                                            'claimed'
                                                        ? InkWell(
                                                            onTap: () {
                                                              claimReward(
                                                                  context,
                                                                  contestProvider
                                                                      .rewardListModel!
                                                                      .data![
                                                                          index]
                                                                      .rewardId!
                                                                      .toString(),
                                                                  index);
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 10),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          3),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .white),
                                                              child: contestProvider
                                                                      .isClaimRewardsLoading
                                                                  ? const SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      contestProvider.rewardListModel!.data![index].rewardType ==
                                                                              'cashback'
                                                                          ? AppLocalizations.of(context)!
                                                                              .claimNow
                                                                          : AppLocalizations.of(context)!
                                                                              .claimNow, // redeem now
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                                if (isExpired(contestProvider
                                                        .rewardListModel!
                                                        .data![index]
                                                        .expirationDate ??
                                                    ''))
                                                  Positioned.fill(
                                                      top: 0,
                                                      bottom: 0,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.55),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'reward expired',
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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

  Widget menuItemsWidget(bool isDarkMode) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      icon: Image.asset(
        'assets/images/menu.png',
        height: 30,
        width: 30,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.addBankDetails,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              SlideRightRoute(page: const AddBankDetailsScreen()),
            );
          },
        ),
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.wallet,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              SlideRightRoute(page: const WalletScreen()),
            );
          },
        ),
      ],
    );
  }
}
