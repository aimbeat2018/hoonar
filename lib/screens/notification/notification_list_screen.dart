import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/my_loading/my_loading.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/custom/snackbar_util.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/notification_list_model.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:hoonar/shimmerLoaders/news_event_list_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/color_constants.dart';
import '../../constants/session_manager.dart';
import '../../constants/theme.dart';
import '../../custom/data_not_found.dart';
import '../../providers/contest_provider.dart';
import '../../providers/home_provider.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  SessionManager sessionManager = SessionManager();
  final ScrollController _scrollController = ScrollController();
  List<NotificationData> notificationData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            getNotification(context);
          }
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNotification(context);
      updateNotificationCount(context);
    });
  }

  Future<void> getNotification(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
        start: notificationData.length == 10 ? notificationData.length : 0,
      );

      await homeProvider.getNotificationList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.notificationListModel?.status == '200') {
        } else if (homeProvider.notificationListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.notificationListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> updateNotificationCount(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
        start: notificationData.length == 10 ? notificationData.length : 0,
      );

      await homeProvider.markNotificationAsRead(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.notificationReadModel?.status == '200') {
        } else if (homeProvider.notificationReadModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.notificationReadModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

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
              controller: _scrollController,
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
                    ValueListenableBuilder<NotificationListModel?>(
                        valueListenable: homeProvider.notificationListNotifier,
                        builder: (context, commentData, child) {
                          if (commentData == null) {
                            return NewsEventListShimmer();
                          } else if (commentData.data == null ||
                              commentData.data!.isEmpty) {
                            return DataNotFound();
                          } else {
                            notificationData = commentData.data!;
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: notificationData.length,
                            itemBuilder: (context, index) {
                              return _buildNotificationData(
                                  notificationData[index], myLoading.isDark);
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNotificationData(NotificationData model, bool isDarkMode) {
    DateTime dateTime = DateTime.parse(model.createdAt!);

    // Format the DateTime
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isDarkMode ? Colors.white : Colors.black, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.message ?? '',
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formattedDate,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
    );
  }
}
