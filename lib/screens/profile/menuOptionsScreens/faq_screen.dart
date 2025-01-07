import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/success_models/faq_list_model.dart';
import 'package:hoonar/shimmerLoaders/faq_list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../providers/setting_provider.dart';
import '../../auth_screen/login_screen.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
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
      getFaqs(context);
    });
  }

  Future<void> getFaqs(BuildContext context) async {
    final contestProvider =
        Provider.of<SettingProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      await contestProvider
          .getFaqs(sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.faqListModel?.status == '200') {
        } else if (contestProvider.faqListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.faqListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
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
    final settingProvider = Provider.of<SettingProvider>(context);
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              body: Container(
                padding: const EdgeInsets.only(/*top: 20,*/ left: 5, right: 5),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    /*image: DecorationImage(
                image: AssetImage('assets/images/screens_back.png'),
                // Path to your image
                fit: BoxFit.cover, // Ensures the image covers the entire container
              ),*/
                    color: myLoading.isDark ? Colors.black : Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildAppbar(context, myLoading.isDark),
                      Center(
                          child: GradientText(
                        AppLocalizations.of(context)!.faq,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: myLoading.isDark ? Colors.white : Colors.black,
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
                      settingProvider.isFaqLoading ||
                              settingProvider.faqListModel == null
                          ? FaqListShimmer()
                          : settingProvider.faqListModel!.data == null ||
                                  settingProvider.faqListModel!.data!.isEmpty
                              ? DataNotFound()
                              : AnimatedList(
                                  initialItemCount: settingProvider
                                      .faqListModel!.data!.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index, animation) {
                                    return buildItem(
                                        animation,
                                        index,
                                        myLoading.isDark,
                                        settingProvider.faqListModel!.data![
                                            index]); // Build each list item
                                  },
                                )
                    ],
                  ),
                ),
              ),
            );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode,
      FaqListData model) {
    return InkWell(
      onTap: () {
        setState(() {
          model.isExpanded = !model.isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.80,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            borderRadius: BorderRadius.circular(6.19),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    model.question ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      model.isExpanded = !model.isExpanded;
                    });
                  },
                  child: Icon(
                    model.isExpanded
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
            model.isExpanded
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        Divider(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.answer ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
