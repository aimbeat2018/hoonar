import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../../model/success_models/home_post_success_model.dart';
import '../auth_screen/login_screen.dart';

class MoreOptionsListScreen extends StatefulWidget {
  final int postId;
  final int postUserId;
  final String userId;
  final String followStatus;
  final List<PostsListData>? postList;
  final int index;

  const MoreOptionsListScreen(
      {super.key,
      required this.postId,
      required this.followStatus,
      required this.postUserId,
      required this.userId,
      this.postList,
      required this.index});

  @override
  State<MoreOptionsListScreen> createState() => _MoreOptionsListScreenState();
}

class _MoreOptionsListScreenState extends State<MoreOptionsListScreen>
    with SingleTickerProviderStateMixin {
  // double _height = 250;
  SessionManager sessionManager = SessionManager();

  List<StarCategoryModel> optionsList = [];
  String userId = "";

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

  Future<void> deletePost(BuildContext context, int postId, int index) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(postId: postId);

      await homeProvider.deletePost(
        context,
        requestModel,
        sessionManager.getString(SessionManager.accessToken) ?? '',
        /* CommonRequestModel(
              userId: sessionManager.getString(SessionManager.userId)!,
              myUserId: sessionManager.getString(SessionManager.userId)!)*/
      );

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.deletePostModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.deletePostModel?.message! ?? '');
          // setState(() {
          //   widget.postList!.removeAt(index);
          // });
        } else if (homeProvider.deletePostModel?.status == '401') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.deletePostModel?.message! ?? '');
        } else if (homeProvider.deletePostModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.deletePostModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
    await Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void showDeleteDialog(
      BuildContext context, bool isDarkMode, BuildContext context1) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.deleteAccount,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.areYouSureYouWantToDeleteThisVideo,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                // Navigator.pop(context1);
                deletePost(context, widget.postId, widget.index);
              },
            ),
          ],
        );
      },
    );
  }

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
            const SizedBox(
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
                              const SizedBox(
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
                              const Spacer(),
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
                      const Divider(),
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
                                const SizedBox(
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
                                const Spacer(),
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
                      if (widget.followStatus == "0") const Divider(),
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
                              const SizedBox(
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
                              const Spacer(),
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
                : widget.postList![widget.index].canVote != 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 15),
                            child: InkWell(
                              onTap: () {
                                showDeleteDialog(
                                    context, myLoading.isDark, context);
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
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.deleteVideo,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const Spacer(),
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
                      )
                    : const SizedBox(),
          ],
        ),
      );
    });
  }
}
