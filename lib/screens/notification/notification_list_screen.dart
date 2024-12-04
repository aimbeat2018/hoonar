import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/my_loading/my_loading.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/custom/snackbar_util.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:hoonar/shimmerLoaders/news_event_list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/color_constants.dart';
import '../../constants/session_manager.dart';
import '../../constants/theme.dart';
import '../../custom/data_not_found.dart';
import '../../providers/contest_provider.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNotification(context);
    });
  }

  Future<void> getNotification(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(start: 1);

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
  Widget build(BuildContext context) {
    final contestProvider = Provider.of<ContestProvider>(context);
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
                      AppLocalizations.of(context)!.notification,
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
                      height: 15,
                    ),
                    contestProvider.isNewsLoading ||
                            contestProvider.newsEventSuccessModel == null
                        ? const NewsEventListShimmer()
                        : contestProvider.newsEventSuccessModel!.data == null ||
                                contestProvider
                                    .newsEventSuccessModel!.data!.isEmpty
                            ? DataNotFound()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                shrinkWrap: true,
                                itemCount: contestProvider
                                    .newsEventSuccessModel!.data!.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                              fontWeight: FontWeight.normal,
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
