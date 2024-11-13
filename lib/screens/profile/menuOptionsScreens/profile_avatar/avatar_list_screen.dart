import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/providers/user_provider.dart';
import 'package:hoonar/shimmerLoaders/avatar_list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/common_widgets.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/session_manager.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../custom/data_not_found.dart';
import '../../../../custom/snackbar_util.dart';
import '../../../../shimmerLoaders/grid_shimmer.dart';
import '../../../auth_screen/login_screen.dart';

class AvatarListScreen extends StatefulWidget {
  final String type;

  const AvatarListScreen({super.key, required this.type});

  @override
  State<AvatarListScreen> createState() => _AvatarListScreenState();
}

class _AvatarListScreenState extends State<AvatarListScreen> {
  SessionManager sessionManager = SessionManager();
  int selectedIndex = -1;
  String selectedAvatarId = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAvatarList(context);
    });
  }

  Future<void> getAvatarList(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel = CommonRequestModel(gender: widget.type);

      await userProvider.getAvatarList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (userProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, userProvider.errorMessage ?? '');
      } else {
        if (userProvider.avatarListModel?.status == '200') {
        } else if (userProvider.avatarListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, userProvider.avatarListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> updateAvatar(BuildContext context, String avatarId) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel = CommonRequestModel(
          avatarId: avatarId,
          userId: sessionManager.getString(SessionManager.userId) ?? '');

      await userProvider.updateProfileWithAvatar(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (userProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, userProvider.errorMessage ?? '');
      } else {
        if (userProvider.updateAvatarModel?.status == '200') {
          Navigator.pop(context);
        } else if (userProvider.updateAvatarModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, userProvider.updateAvatarModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: LoginScreen()), (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context);

    int crossAxisCount = screenWidth < 600 ? 4 : 4;

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        bottomNavigationBar: InkWell(
          onTap: () {
            updateAvatar(context, selectedAvatarId);
          },
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            decoration: BoxDecoration(
              color: buttonBlueColor1,
            ),
            child: Provider.of<AuthProvider>(context).isUpdateAvatarLoading
                ? Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    userProvider.isAvatarLoading ||
                            userProvider.avatarListModel == null
                        ? AvatarListShimmer()
                        : userProvider.avatarListModel!.data == null ||
                                userProvider.avatarListModel!.data!.isEmpty
                            ? DataNotFound()
                            : GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 1,
                                ),
                                itemCount:
                                    userProvider.avatarListModel!.data!.length,
                                itemBuilder: (context, index) {
                                  final avatarUrl = userProvider
                                          .avatarListModel!
                                          .data![index]
                                          .avatarUrl ??
                                      '';

                                  if (selectedIndex == -1) {
                                    if (userProvider.avatarListModel!
                                            .data![index].isSelected ==
                                        1) {
                                      selectedAvatarId = userProvider
                                          .avatarListModel!
                                          .data![index]
                                          .avatarId
                                          .toString();
                                    }
                                  }
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;

                                        selectedAvatarId = userProvider
                                            .avatarListModel!
                                            .data![index]
                                            .avatarId
                                            .toString();
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Circular image with border if selected
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: myLoading.isDark
                                                  ? (/*userProvider
                                                                  .avatarListModel!
                                                                  .data![index]
                                                                  .isSelected ==
                                                              1 ||*/
                                                      selectedAvatarId ==
                                                              userProvider
                                                                  .avatarListModel!
                                                                  .data![index]
                                                                  .avatarId
                                                                  .toString()
                                                          ? Colors.white
                                                          : Colors.transparent)
                                                  : (/*userProvider
                                                              .avatarListModel!
                                                              .data![index]
                                                              .isSelected ==
                                                          1*/
                                                      selectedAvatarId ==
                                                              userProvider
                                                                  .avatarListModel!
                                                                  .data![index]
                                                                  .avatarId
                                                                  .toString()
                                                          ? Colors.black
                                                          : Colors.transparent),
                                              width: 1,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: avatarUrl,
                                              fit: BoxFit.fitHeight,
                                              placeholder: (context, url) =>
                                                  Center(
                                                child: SizedBox(
                                                  height: 15,
                                                  width: 15,
                                                  child:
                                                      const CircularProgressIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      buildInitialsAvatar(
                                                'No Image',
                                                fontSize: 12,
                                              ),
                                              width: 80,
                                              height: 80,
                                            ),
                                          ),
                                        ),
                                        // Check icon in the bottom-right corner if selected
                                        if (/*userProvider.avatarListModel!
                                                    .data![index].isSelected ==
                                                1 ||*/
                                            selectedAvatarId ==
                                                userProvider.avatarListModel!
                                                    .data![index].avatarId
                                                    .toString())
                                          Positioned(
                                            bottom: 5,
                                            right: 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: myLoading.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.check,
                                                color: myLoading.isDark
                                                    ? Colors.black
                                                    : Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
