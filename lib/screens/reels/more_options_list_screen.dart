import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/providers/home_provider.dart';
import 'package:hoonar/screens/reels/report_post_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../model/star_category_model.dart';
import '../auth_screen/login_screen.dart';

class MoreOptionsListScreen extends StatefulWidget {
  final int postId;
  final int postUserId;
  final String userId;
  final String followStatus;

  const MoreOptionsListScreen(
      {super.key,
      required this.postId,
      required this.followStatus,
      required this.postUserId,
      required this.userId});

  @override
  State<MoreOptionsListScreen> createState() => _MoreOptionsListScreenState();
}

class _MoreOptionsListScreenState extends State<MoreOptionsListScreen>
    with SingleTickerProviderStateMixin {
  // double _height = 250;
  SessionManager sessionManager = SessionManager();

  List<StarCategoryModel> optionsList = [];

  // void updateHeight(double height) {
  //   setState(() {
  //     _height = height;
  //   });
  // }

  Future<void> postInterest(
      BuildContext context, int postId, String interestType) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(postId: postId, interestType: interestType);

      await homeProvider.postInterest(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.postInterestModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.postInterestModel?.message! ?? '');
          Navigator.pop(context);
        } else if (homeProvider.postInterestModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.postInterestModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  String userId = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      optionsList = [
        StarCategoryModel("", AppLocalizations.of(context)!.interested, ''),
        StarCategoryModel('', AppLocalizations.of(context)!.not_interested, ''),
        StarCategoryModel('', AppLocalizations.of(context)!.report, ''),
      ];

      userId = sessionManager.getString(SessionManager.userId)!;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final homeProvider = Provider.of<HomeProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return SafeArea(
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            widget.userId != widget.postUserId.toString()
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: InkWell(
                          onTap: () {
                            postInterest(context, widget.postId, "1");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                color: myLoading.isDark
                                    ? Colors.white60
                                    : Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                optionsList[0].name!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: myLoading.isDark
                                    ? Colors.white60
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      if (widget.followStatus == "0")
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 15),
                          child: InkWell(
                            onTap: () {
                              postInterest(context, widget.postId, "2");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.visibility_off_outlined,
                                  color: myLoading.isDark
                                      ? Colors.white60
                                      : Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  optionsList[1].name!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15,
                                  color: myLoading.isDark
                                      ? Colors.white60
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.followStatus == "0") Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              SlideRightRoute(
                                page: ReportPostScreen(
                                  postId: widget.postId,
                                ),
                              ),
                            );

                            // Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.report_gmailerrorred,
                                color:
                                    myLoading.isDark ? Colors.red : Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                optionsList[2].name!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: myLoading.isDark
                                      ? Colors.red
                                      : Colors.red,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color:
                                    myLoading.isDark ? Colors.red : Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: InkWell(
                          onTap: () {
                            postInterest(context, widget.postId, "1");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: myLoading.isDark
                                    ? Colors.white60
                                    : Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Delete video',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: myLoading.isDark
                                    ? Colors.white60
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      );
    });
  }
}
