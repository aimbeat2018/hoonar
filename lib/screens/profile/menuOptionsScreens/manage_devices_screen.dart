import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/custom/data_not_found.dart';
import 'package:hoonar/model/success_models/devices_list_model.dart';
import 'package:hoonar/shimmerLoaders/devices_list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/dummy_list_model.dart';
import '../../../model/request_model/list_common_request_model.dart';
import '../../../providers/setting_provider.dart';
import '../../auth_screen/login_screen.dart';

class ManageDevicesScreen extends StatefulWidget {
  const ManageDevicesScreen({super.key});

  @override
  State<ManageDevicesScreen> createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoginDevices(context);
    });
  }

  Future<void> getLoginDevices(BuildContext context) async {
    final contestProvider =
        Provider.of<SettingProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      await contestProvider.getLoginDevices(
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.devicesListModel?.status == '200') {
        } else if (contestProvider.devicesListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.devicesListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> removeDevice(BuildContext context, String deviceId) async {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(deviceId: deviceId);

      await settingProvider.removeDevice(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (settingProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, settingProvider.errorMessage ?? '');
        Navigator.of(context).pop();
      } else {
        if (settingProvider.removeDeviceModel?.status == '200') {
          Navigator.of(context).pop();
        } else if (settingProvider.removeDeviceModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, settingProvider.removeDeviceModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        } else {
          Navigator.of(context).pop();
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
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
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
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: GradientText(
                  AppLocalizations.of(context)!.manageDevices,
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
                        myLoading.isDark ? greyTextColor8 : Colors.grey.shade700
                      ]),
                )),
                settingProvider.isDevicesLoading ||
                        settingProvider.devicesListModel == null ||
                        settingProvider.devicesListModel!.data == null
                    ? DevicesListShimmer()
                    : ValueListenableBuilder<DevicesListModel?>(
                        valueListenable: settingProvider.deviceListNotifier,
                        builder: (context, deviceData, child) {
                          if (deviceData == null) {
                            return DevicesListShimmer();
                          } else if (deviceData.data!.isEmpty) {
                            return DataNotFound();
                          }

                          return AnimatedList(
                            initialItemCount: deviceData.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index, animation) {
                              return buildItem(
                                  animation,
                                  index,
                                  myLoading.isDark,
                                  deviceData
                                      .data![index]); // Build each list item
                            },
                          );
                        })
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode,
      DevicesListData model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
      child: Row(
        children: [
          Image.asset(
            model.deviceType == 'mobile'
                ? 'assets/images/mobile.png'
                : 'assets/images/laptop.png',
            height: 25,
            width: 25,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.deviceName ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formatRelativeTime(model.createdAt ?? ''),
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF939393),
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            )
            /*  .animate()
                .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                .slideX(duration: 800.ms)*/
            ,
          ),
          InkWell(
            onTap: () {
              showRemoveDialog(
                  context, isDarkMode, model.deviceId.toString() ?? '');
            },
            child: Text(
              AppLocalizations.of(context)!.remove,
              style: GoogleFonts.poppins(
                color: orangeColor,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }

  String formatRelativeTime(String dateTimeString) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Convert to relative time
    return timeago.format(dateTime, locale: 'en');
  }

  void showRemoveDialog(
      BuildContext context, bool isDarkMode, String deviceToken) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.removeDevice,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.areYouSureYouWantToRemoveDevice,
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
                AppLocalizations.of(context)!.remove,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                removeDevice(context, deviceToken);
              },
            ),
          ],
        );
      },
    );
  }
}
