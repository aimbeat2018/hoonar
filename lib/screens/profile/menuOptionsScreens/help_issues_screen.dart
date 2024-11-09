import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/providers/setting_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../shimmerLoaders/devices_list_shimmer.dart';
import '../../auth_screen/login_screen.dart';

class HelpIssuesScreen extends StatefulWidget {
  final bool isDarkMode;

  const HelpIssuesScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<HelpIssuesScreen> createState() => _HelpIssuesScreenState();
}

class _HelpIssuesScreenState extends State<HelpIssuesScreen> {
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHelpIssues(context);
    });
  }

  Future<void> getHelpIssues(BuildContext context) async {
    final contestProvider =
        Provider.of<SettingProvider>(context, listen: false);
    sessionManager.initPref().then((onValue) async {
      await contestProvider.getHelpIssueList(
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.helpIssuesListModel?.status == '200') {
        } else if (contestProvider.helpIssuesListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.helpIssuesListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double halfScreenHeight = MediaQuery.of(context).size.height * 0.7;
    final settingProvider = Provider.of<SettingProvider>(context);
    return SizedBox(
      height: halfScreenHeight, // Set the height to half of the screen
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

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: GradientText(
                AppLocalizations.of(context)!.helpSelectIssue,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: widget.isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      widget.isDarkMode ? Colors.white : Colors.black,
                      widget.isDarkMode ? Colors.white : Colors.black,
                      widget.isDarkMode ? greyTextColor8 : Colors.grey.shade700
                    ]),
              ),
            ),
          ),

          // City List
          Expanded(
            child: settingProvider.isDevicesLoading ||
                    settingProvider.helpIssuesListModel == null ||
                    settingProvider.helpIssuesListModel!.data == null
                ? DevicesListShimmer()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount:
                        settingProvider.helpIssuesListModel!.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          /*    if ((widget.selectedStateId == null ||
                                  widget.selectedStateId == "")) {*/
                          Navigator.pop(
                              context,
                              settingProvider
                                  .helpIssuesListModel!.data![index]);
                          // }
                        },
                        title: Text(
                          settingProvider.helpIssuesListModel!.data![index]
                                  .issueName ??
                              '',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // Customize the city item as needed
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
