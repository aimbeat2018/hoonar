import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/custom/data_not_found.dart';
import 'package:hoonar/model/request_model/store_payment_request_model.dart';
import 'package:hoonar/screens/home/widgets/carousel_page_view.dart';
import 'package:provider/provider.dart';

import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../model/success_models/level_list_model.dart';
import '../../../providers/contest_provider.dart';
import '../../../shimmerLoaders/home_slider_shimmers.dart';
import '../../auth_screen/login_screen.dart';

class HoonarStarsScreen extends StatefulWidget {
  final int? categoryId;
  final String? levelId;

  const HoonarStarsScreen({super.key, this.categoryId, this.levelId});

  @override
  State<HoonarStarsScreen> createState() => _HoonarStarsScreenState();
}

class _HoonarStarsScreenState extends State<HoonarStarsScreen> {
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  List<LevelListData> zoneLevelsList = [];
  LevelListData? selectedLevel;
  SessionManager sessionManager = SessionManager();

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
      getLevelList(context);
    });
  }

  Future<void> getLevelList(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(categoryId: widget.categoryId);

      await contestProvider.getLevelList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.levelListModel?.status == '200') {
          setState(() {
            zoneLevelsList = contestProvider.levelListModel!.data!;
            selectedLevel =
                zoneLevelsList.isNotEmpty ? zoneLevelsList[0] : null;
            getHoonarStarsList(context, selectedLevel!.levelId!);
          });
        } else if (contestProvider.levelListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.levelListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> getHoonarStarsList(BuildContext context, int levelId) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      StorePaymentRequestModel requestModel = StorePaymentRequestModel(
          categoryId: widget.categoryId, levelId: levelId);

      await contestProvider.getHoonarStarList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.hoonarStarSuccessModel?.status == '200') {
        } else if (contestProvider.hoonarStarSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.hoonarStarSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
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
    final screenHeight = MediaQuery.of(context).size.height;
    final contestProvider = Provider.of<ContestProvider>(context);
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(children: [
                    contestProvider.isHoonarStarLoading ||
                            contestProvider.hoonarStarSuccessModel == null
                        ? const HomeSliderShimmers()
                        : contestProvider.hoonarStarSuccessModel!.data ==
                                    null ||
                                contestProvider
                                    .hoonarStarSuccessModel!.data!.isEmpty
                            ? const DataNotFound()
                            : SizedBox(
                                height: screenHeight * 0.58,
                                child: CarouselPageView(
                                  sliderModelList: contestProvider
                                          .hoonarStarSuccessModel!.data ??
                                      [],
                                  isDarkMode: myLoading.isDark,
                                )),
                    contestProvider.isLevelLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 45.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 3),
                                  labelText:
                                      AppLocalizations.of(context)!.level,
                                  labelStyle: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      borderSide: BorderSide(
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          width: 1))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<LevelListData>(
                                  dropdownColor: myLoading.isDark
                                      ? Colors.black
                                      : Colors.white,
                                  // Dropdown background color
                                  value: selectedLevel,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  isExpanded: true,
                                  // Make dropdown fill the width
                                  style: GoogleFonts.poppins(
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                  items: zoneLevelsList
                                      .map<DropdownMenuItem<LevelListData>>(
                                          (LevelListData value) {
                                    return DropdownMenuItem<LevelListData>(
                                      value: value,
                                      child: Text(
                                        value.levelName ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (LevelListData? newValue) {
                                    setState(() {
                                      selectedLevel = newValue!;
                                    });

                                    getHoonarStarsList(
                                        context, selectedLevel!.levelId!);
                                  },
                                ),
                              ),
                            ),
                          ),
                  ]),
                ),
              ));
    });
  }
}
