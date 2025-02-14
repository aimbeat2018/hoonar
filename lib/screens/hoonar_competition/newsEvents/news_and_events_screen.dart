import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/shimmerLoaders/news_event_list_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../constants/theme.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';
import 'upcoming_events_screen.dart';

class NewsAndEventsScreen extends StatefulWidget {
  const NewsAndEventsScreen({super.key});

  @override
  State<NewsAndEventsScreen> createState() => _NewsAndEventsScreenState();
}

class _NewsAndEventsScreenState extends State<NewsAndEventsScreen> {
  String _selectedDate = "Select Date";
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
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

    _selectedDate = _dateFormat.format(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNewsEvent(context);
    });
  }

  // Method to show date picker and set selected date
  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            dialogBackgroundColor: Colors.white, // calendar background color
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = _dateFormat.format(pickedDate); // Format and set date
      });
    }
  }

  Future<void> getNewsEvent(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(date: _selectedDate);

      await contestProvider.getNewsEventList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.newsEventSuccessModel?.status == '200') {
        } else if (contestProvider.newsEventSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.newsEventSuccessModel?.message! ?? '');
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
    final contestProvider = Provider.of<ContestProvider>(context);
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
                            AppLocalizations.of(context)!.news_events,
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
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: InkWell(
                                onTap: () {
                                  _pickDate(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: myLoading.isDark
                                          ? greyBackColor.withOpacity(0.5)
                                          : Colors.white70),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          _selectedDate,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      Icon(
                                        Icons.calendar_month,
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const UpcomingEventsScreen()),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/upcoming_events.png',
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .upcomingEvents,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          contestProvider.isNewsLoading ||
                                  contestProvider.newsEventSuccessModel == null
                              ? const NewsEventListShimmer()
                              : contestProvider.newsEventSuccessModel!.data ==
                                          null ||
                                      contestProvider
                                          .newsEventSuccessModel!.data!.isEmpty
                                  ? const DataNotFound()
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      shrinkWrap: true,
                                      itemCount: contestProvider
                                          .newsEventSuccessModel!.data!.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
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
                                                top: 10.0,
                                                bottom: 10,
                                                right: 10,
                                                left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  contestProvider
                                                          .newsEventSuccessModel!
                                                          .data![index]
                                                          .title ??
                                                      ''.toUpperCase(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  contestProvider
                                                          .newsEventSuccessModel!
                                                          .data![index]
                                                          .description ??
                                                      '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  /* '${AppLocalizations.of(context)!.today}, 09:00 PM',*/
                                                  contestProvider
                                                          .newsEventSuccessModel!
                                                          .data![index]
                                                          .createdAt ??
                                                      '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
