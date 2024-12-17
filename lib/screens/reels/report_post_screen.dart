import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/color_constants.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/data_not_found.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../providers/home_provider.dart';
import '../../shimmerLoaders/search_list_shimmer.dart';
import '../auth_screen/login_screen.dart';

class ReportPostScreen extends StatefulWidget {
  final int postId;

  const ReportPostScreen({super.key, required this.postId});

  @override
  State<ReportPostScreen> createState() => _ReportPostScreenState();
}

class _ReportPostScreenState extends State<ReportPostScreen> {
  SessionManager sessionManager = SessionManager();
  int reasonId = -1;
  TextEditingController reportReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getReportReasonsList(context);
  }

  Future<void> getReportReasonsList(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      /*ListCommonRequestModel requestModel =
          ListCommonRequestModel(postId: postId, interestType: interestType);*/

      await homeProvider.getReportReasonsList(ListCommonRequestModel(),
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.reportReasonsModel?.status ==
            200) {} /*else if (homeProvider.reportReasonsModel?.status ==
            ) {
          SnackbarUtil.showSnackBar(
              context, homeProvider.reportReasonsModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }*/
      }
    });
  }

  Future<void> reportPost(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
          postId: widget.postId,
          reasonId: reasonId,
          description: reportReasonController.text);

      await homeProvider.reportPost(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.reportPostModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.postInterestModel?.message! ?? '');
          Navigator.pop(context);
        } else if (homeProvider.reportPostModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.reportPostModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final homeProvider = Provider.of<HomeProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                /*image: DecorationImage(
                  image: AssetImage('assets/images/screens_back.png'),
                  // Path to your image
                  fit:
                      BoxFit.cover, // Ensures the image covers the entire container
                ),*/
                color: myLoading.isDark ? Colors.black : Colors.white),
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
                  const SizedBox(
                    height: 10,
                  ),
                  homeProvider.isReportReasonsLoading ||
                          homeProvider.reportReasonsModel == null
                      ? const SearchListShimmer()
                      : homeProvider.reportReasonsModel!.data == null ||
                              homeProvider.reportReasonsModel!.data!.isEmpty
                          ? DataNotFound()
                          : ListView.separated(
                              itemCount: homeProvider.reportReasonsModel!.data!
                                  .length /*+
                                  1*/
                              ,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                /* if (index ==
                                    homeProvider
                                        .reportReasonsModel!.data!.length) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          reasonId = -11;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            reasonId == -11
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.other,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
*/
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        reasonId = homeProvider
                                            .reportReasonsModel!
                                            .data![index]
                                            .reasonId!;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          reasonId ==
                                                  homeProvider
                                                      .reportReasonsModel!
                                                      .data![index]
                                                      .reasonId
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          homeProvider.reportReasonsModel!
                                                  .data![index].reason ??
                                              '',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider();
                              },
                            ),
                  const SizedBox(
                    height: 20,
                  ),
                  // if (reasonId == -11)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      validator: (v) {
                        if (v!.trim().isEmpty) {
                          return AppLocalizations.of(context)!.enterPhoneNumber;
                        }
                        /* else if (v.length != 10) {
                                  return AppLocalizations.of(context)!
                                      .enterValidPhoneNumber;
                                }*/
                        return null;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                          filled: false,
                          fillColor: /*myLoading.isDark
                                      ? Colors.white
                                      : */
                              Colors.black,
                          errorStyle: GoogleFonts.poppins(),
                          hintText: AppLocalizations.of(context)!.report,
                          border: GradientOutlineInputBorder(
                            width: 1.5,
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                myLoading.isDark ? Colors.white : Colors.black,
                                greyTextColor4
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5)),
                      controller: reportReasonController,
                      cursorColor:
                          myLoading.isDark ? Colors.white : Colors.black,
                      style: GoogleFonts.poppins(
                        color: /*myLoading.isDark
                                    ? Colors.black
                                    :*/
                            Colors.white,
                        fontSize: 14,
                      ),
                      keyboardType: TextInputType.text,
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.digitsOnly,
                      //   LengthLimitingTextInputFormatter(10),
                      // ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  homeProvider.isReportPostLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: () {
                            if (reasonId == -1) {
                              SnackbarUtil.showSnackBar(
                                  context, 'Select report reason');
                            } else if (reportReasonController.text.isEmpty) {
                              SnackbarUtil.showSnackBar(
                                  context, 'Enter report reason');
                            } else {
                              reportPost(context);
                            }
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 25),
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 10),
                            decoration: ShapeDecoration(
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: myLoading.isDark
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.report,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
