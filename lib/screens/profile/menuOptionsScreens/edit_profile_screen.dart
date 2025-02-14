import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/model/request_model/update_profile_request_model.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/change_password_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/change_profile_photo_option_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/theme.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/success_models/profile_success_model.dart';
import '../../../providers/auth_provider.dart';
import '../../auth_screen/login_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  SessionManager sessionManager = SessionManager();
  bool isLoading = false, isFirstTimeSet = false;
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
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
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> _selectDate(BuildContext context, bool isDarkMode) async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      // initialDate: DateTime(2020),
      firstDate: DateTime(1970),
      // lastDate: DateTime(2090),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      itemTextStyle: GoogleFonts.poppins(
        fontSize: 15,
        color: isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      locale: DateTimePickerLocale.en_us,
      looping: false,
      reverse: true,
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      textColor: isDarkMode ? Colors.white : Colors.black,
      titleText: AppLocalizations.of(context)!.dob.replaceAll("*", ""),
      confirmText: AppLocalizations.of(context)!.yes,
      cancelText: AppLocalizations.of(context)!.cancel,
    );
    if (datePicked != null) {
      // Calculate the user's age
      int age = DateTime.now().year - datePicked.year;
      // Check if the user is at least 15 years old
      if (age < 15 ||
          (age == 15 &&
              DateTime.now()
                  .isBefore(datePicked.add(const Duration(days: 15 * 365))))) {
        // Show an error message or prevent the user from proceeding
        SnackbarUtil.showSnackBar(
          context,
          AppLocalizations.of(context)!.youMustBeAtLeast,
        );
      } else {
        dobController.text = DateFormat('yyyy-MM-dd').format(datePicked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              // resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: myLoading.isDark ? Colors.black : Colors.white),
                child: SafeArea(
                  child: Scrollbar(
                    thickness: 2.5,
                    radius: const Radius.circular(10),
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                buildAppbar(context, myLoading.isDark),
                                const SizedBox(
                                  height: 10,
                                ),
                                GradientText(
                                  AppLocalizations.of(context)!.editProfile,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: myLoading.isDark
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        myLoading.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        myLoading.isDark
                                            ? greyTextColor8
                                            : Colors.grey.shade700
                                      ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ValueListenableBuilder<ProfileSuccessModel?>(
                                    valueListenable:
                                        authProvider.profileNotifier,
                                    builder: (context, profile, child) {
                                      if (profile == null) {
                                        return const LoaderDialog();
                                      } else if (profile.message ==
                                          'Unauthorized Access!') {
                                        Future.microtask(() {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              SlideRightRoute(
                                                  page: const LoginScreen()),
                                              (route) => false);
                                        });
                                      }
                                      String initials = "";

                                      if (!isFirstTimeSet) {
                                        initials =
                                            profile.data?.fullName != null ||
                                                    profile.data?.fullName != ""
                                                ? profile.data!.fullName!
                                                    .trim()
                                                    .split(' ')
                                                    .map((e) => e[0])
                                                    .take(2)
                                                    .join()
                                                    .toUpperCase()
                                                : '';

                                        fullNameController.text =
                                            profile.data!.fullName ?? '';
                                        dobController.text =
                                            profile.data!.dob ?? '';
                                        bioController.text =
                                            profile.data!.bio ?? '';
                                        userNameController.text =
                                            profile.data!.userName ?? '';
                                        emailController.text =
                                            profile.data!.userEmail ?? '';
                                        phoneController.text =
                                            profile.data!.userMobileNo ?? '';
                                        isFirstTimeSet = true;
                                      }

                                      return Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Hero(
                                                tag: 'profileImage',
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor: myLoading
                                                          .isDark
                                                      ? Colors.grey.shade700
                                                      : Colors.grey.shade200,
                                                  child: ClipOval(
                                                    child: profile.data
                                                                ?.userProfile !=
                                                            ""
                                                        ? CachedNetworkImage(
                                                            imageUrl: profile
                                                                .data!
                                                                .userProfile!,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                buildInitialsAvatar(
                                                                    initials),
                                                            fit: BoxFit.cover,
                                                            // width: 80,
                                                            // // Match the size of the CircleAvatar
                                                            // height: 80,
                                                          )
                                                        : buildInitialsAvatar(
                                                            initials),
                                                  ),
                                                ),
                                              ),
                                              /*camera_edit.png*/
                                              Positioned(
                                                      bottom: 5,
                                                      right: 1,
                                                      child: InkWell(
                                                        onTap: () {
                                                          _openChangeProfileOptionsSheet(
                                                              context,
                                                              myLoading.isDark);
                                                        },
                                                        child: Image.asset(
                                                          'assets/images/camera_edit.png',
                                                          height: 25,
                                                          width: 25,
                                                        ),
                                                      ))
                                                  .animate()
                                                  .moveY(
                                                      begin: 200,
                                                      end:
                                                          0) // Moves from +200px to 0px (bottom to center)
                                                  .fadeIn(duration: 800.ms),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Form(
                                              key: _formKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .fullName,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                            top: 3),
                                                    child: TextFormField(
                                                      validator: (v) {
                                                        if (v!.trim().isEmpty) {
                                                          return AppLocalizations
                                                                  .of(context)!
                                                              .enterFullName;
                                                        }
                                                        return null;
                                                      },
                                                      maxLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                              errorStyle:
                                                                  GoogleFonts
                                                                      .poppins(),
                                                              border:
                                                                  GradientOutlineInputBorder(
                                                                width: 1.5,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    myLoading
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    greyTextColor4
                                                                  ],
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                ),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          3),
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                              ),
                                                              hintText:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .fullName),
                                                      controller:
                                                          fullNameController,
                                                      cursorColor:
                                                          myLoading.isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .hoonarStarId,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                            top: 3),
                                                    child: TextFormField(
                                                      validator: (v) {
                                                        if (v!.trim().isEmpty) {
                                                          return AppLocalizations
                                                                  .of(context)!
                                                              .enterHoonarStarId;
                                                        }
                                                        return null;
                                                      },
                                                      readOnly: true,
                                                      maxLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                              errorStyle:
                                                                  GoogleFonts
                                                                      .poppins(),
                                                              border:
                                                                  GradientOutlineInputBorder(
                                                                width: 1.5,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    myLoading
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    greyTextColor4
                                                                  ],
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                ),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          3),
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                              ),
                                                              hintText:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .userName),
                                                      controller:
                                                          userNameController,
                                                      cursorColor:
                                                          myLoading.isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .dob,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                            top: 3),
                                                    child: TextFormField(
                                                      validator: (v) {
                                                        if (v!.trim().isEmpty) {
                                                          return AppLocalizations
                                                                  .of(context)!
                                                              .enterDob;
                                                        }
                                                        return null;
                                                      },
                                                      maxLines: 1,
                                                      readOnly: true,
                                                      onTap: () async {
                                                        _selectDate(context,
                                                            myLoading.isDark);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              errorStyle:
                                                                  GoogleFonts
                                                                      .poppins(),
                                                              border:
                                                                  GradientOutlineInputBorder(
                                                                width: 1.5,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    myLoading
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    greyTextColor4
                                                                  ],
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                ),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          3),
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                              ),
                                                              hintText:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .dob),
                                                      controller: dobController,
                                                      cursorColor:
                                                          myLoading.isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .bio,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                            top: 3),
                                                    child: TextFormField(
                                                      maxLines: 4,
                                                      decoration:
                                                          InputDecoration(
                                                              errorStyle:
                                                                  GoogleFonts
                                                                      .poppins(),
                                                              border:
                                                                  GradientOutlineInputBorder(
                                                                width: 1.5,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    myLoading
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    greyTextColor4
                                                                  ],
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                ),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          3),
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                              ),
                                                              hintText:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .bio),
                                                      controller: bioController,
                                                      cursorColor:
                                                          myLoading.isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .phone,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                            top: 3),
                                                    child: TextFormField(
                                                      validator: (v) {
                                                        if (v!.trim().isEmpty) {
                                                          return AppLocalizations
                                                                  .of(context)!
                                                              .enterPhoneNumber;
                                                        }
                                                        return null;
                                                      },
                                                      readOnly: true,
                                                      maxLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                              errorStyle:
                                                                  GoogleFonts
                                                                      .poppins(),
                                                              border:
                                                                  GradientOutlineInputBorder(
                                                                width: 1.5,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    myLoading
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    greyTextColor4
                                                                  ],
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                ),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          3),
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                              ),
                                                              hintText:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .phone),
                                                      controller:
                                                          phoneController,
                                                      cursorColor:
                                                          myLoading.isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .email,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                            top: 3),
                                                    child: TextFormField(
                                                      validator: (v) {
                                                        if (v!.trim().isEmpty) {
                                                          return AppLocalizations
                                                                  .of(context)!
                                                              .enterEmail;
                                                        }
                                                        return null;
                                                      },
                                                      readOnly: true,
                                                      maxLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                              errorStyle:
                                                                  GoogleFonts
                                                                      .poppins(),
                                                              border:
                                                                  GradientOutlineInputBorder(
                                                                width: 1.5,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    myLoading
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    greyTextColor4
                                                                  ],
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                ),
                                                              ),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          3),
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                              ),
                                                              hintText:
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .email),
                                                      controller:
                                                          emailController,
                                                      cursorColor:
                                                          myLoading.isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: myLoading.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      onChanged: (value) {},
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      );
                                    }),
                                const SizedBox(
                                  height: 50,
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    SlideRightRoute(
                                        page: const ChangePasswordScreen()),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 15),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            width: 1,
                                            color: myLoading.isDark
                                                ? Colors.white
                                                : Colors.black)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .changePassword,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: myLoading.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      updateUserProfile(context);
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    margin: const EdgeInsets.only(
                                        top: 15,
                                        left: 60,
                                        right: 60,
                                        bottom: 10),
                                    decoration: ShapeDecoration(
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.save,
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
                                ),
                              ],
                            ),
                            authProvider.isProfileLoading
                                ? const Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    top: 0,
                                    child: LoaderDialog())
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
    });
  }

  Future<void> updateUserProfile(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    sessionManager.initPref().then((onValue) async {
      UpdateProfileRequestModel requestModel = UpdateProfileRequestModel(
          fullName: fullNameController.text,
          dob: dobController.text,
          userName: userNameController.text,
          bio: bioController.text);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.updateProfile(requestModel);

      if (authProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, authProvider.errorMessage ?? '');
      } else {
        if (authProvider.profileSuccessModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, authProvider.profileSuccessModel!.message ?? '');
        } else if (authProvider.profileSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, authProvider.profileSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(
              context, SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  void _openChangeProfileOptionsSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ChangeProfilePhotoOptionScreen(
          isDarkMode: isDarkMode,
        );
      },
    );
  }
}
