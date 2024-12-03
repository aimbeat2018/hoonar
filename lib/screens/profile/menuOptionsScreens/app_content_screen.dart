import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/providers/setting_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../shimmerLoaders/page_content_shimmer.dart';
import '../../auth_screen/login_screen.dart';

class AppContentScreen extends StatefulWidget {
  final String? from;

  const AppContentScreen({super.key, this.from});

  @override
  State<AppContentScreen> createState() => _AppContentScreenState();
}

class _AppContentScreenState extends State<AppContentScreen> {
  ScrollController scrollController = ScrollController();

  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPageContent(context);
    });
  }

  Future<void> getPageContent(BuildContext context) async {
    final contestProvider =
        Provider.of<SettingProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(pageType: widget.from);

      await contestProvider.getPageContent(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.pageContentModel?.status == '200') {
        } else if (contestProvider.pageContentModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.pageContentModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
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
                  buildAppbar(context, myLoading.isDark),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: GradientText(
                      widget.from == 'termsofuse'
                          ? AppLocalizations.of(context)!.termsConditions
                          : widget.from == 'privacy'
                              ? AppLocalizations.of(context)!.privacyPolicy
                              : '',
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
                  settingProvider.isPageLoading ||
                          settingProvider.pageContentModel == null ||
                          settingProvider.pageContentModel!.data == null
                      ? PageContentShimmer()
                      : Html(
                          data: settingProvider.pageContentModel!.data!.content,
                          style: {
                              "body": Style(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black),
                            })
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
