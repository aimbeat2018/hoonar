import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_search_data_request_model.dart';
import 'package:hoonar/shimmerLoaders/search_history_shimmer.dart';
import 'package:hoonar/shimmerLoaders/search_list_shimmer.dart';
import 'package:provider/provider.dart';

import '../../constants/common_widgets.dart';
import '../../constants/internet_connectivity.dart';
import '../../constants/key_res.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/no_internet_screen.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/data_not_found.dart';
import '../../custom/snackbar_util.dart';
import '../../model/success_models/user_search_history_model.dart';
import '../../providers/home_provider.dart';
import '../auth_screen/login_screen.dart';
import '../profile/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchNameController = TextEditingController();
  List<UserSearchHistory>? userSearchHistoryList = [];
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  FacebookAppEvents facebookAppEvents = FacebookAppEvents();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userSearchHistory(context);
    });
  }

  void logSearchEvent(String username) {
    facebookAppEvents.logEvent(
      name: 'Search',
      parameters: {
        'user_name': username,
      },
    );
  }

  Future<void> searchUser(BuildContext context, String searchKey) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    ListCommonRequestModel requestModel =
        ListCommonRequestModel(searchTerm: searchKey);
    await homeProvider.searchUser(requestModel, "");

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.searchListModel?.status == '200') {
        userSearchHistory(context);

        /*Log search event*/
        logSearchEvent(searchKey);

      } else if (homeProvider.searchListModel?.message ==
          'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.searchListModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: const LoginScreen()), (route) => false);
      }
    }

    setState(() {});
  }

  Future<void> userSearchHistory(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    await homeProvider.userSearchHistory(ListCommonRequestModel(), "");

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.userSearchHistoryModel?.status == '200') {
        if (homeProvider.userSearchHistoryModel!.userSearchHistory != null) {
          setState(() {
            userSearchHistoryList =
                homeProvider.userSearchHistoryModel?.userSearchHistory!;
          });
        }
      } else if (homeProvider.userSearchHistoryModel?.message ==
          'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.userSearchHistoryModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: const LoginScreen()), (route) => false);
      }
    }
  }

  Future<void> storeSearchHistory(
      BuildContext context, StoreSearchDataRequestModel requestModel) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    await homeProvider.storeSearchData(requestModel, "");

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.addPostModel?.status == '200') {
      } else if (homeProvider.addPostModel?.message == 'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.addPostModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: const LoginScreen()), (route) => false);
      }
    }
  }

  Future<void> deleteSearchData(
      BuildContext context, String searchId, int index) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    ListCommonRequestModel requestModel =
        ListCommonRequestModel(searchId: searchId);
    await homeProvider.deleteSearchData(requestModel, "");

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.addPostModel?.status == '200') {
        setState(() {
          userSearchHistoryList!.remove(userSearchHistoryList![index]);
        });
      } else if (homeProvider.addPostModel?.message == 'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.addPostModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: const LoginScreen()), (route) => false);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: Colors.transparent,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: myLoading.isDark
                                    ? Colors.white
                                        .withOpacity(0.12999999523162842)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!
                                            .searchHint,
                                        hintStyle: GoogleFonts.poppins(
                                          color: hintGreyColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 20),
                                      ),
                                      controller: searchNameController,
                                      cursorColor: Colors.white,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                      keyboardType: TextInputType.text,
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {

                                          searchUser(context, value);



                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: InkWell(
                                        onTap: () {
                                          if (searchNameController
                                              .text.isNotEmpty) {
                                            searchNameController.clear();
                                            searchUser(context, "");
                                          }
                                        },
                                        child: Icon(
                                          searchNameController.text.isEmpty
                                              ? Icons.search
                                              : Icons.close,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          if (searchNameController.text.isEmpty)
                            homeProvider.isSearchLoading ||
                                    homeProvider.userSearchHistoryModel == null
                                ? const SearchHistoryShimmer()
                                : homeProvider.userSearchHistoryModel!
                                                .userSearchHistory ==
                                            null ||
                                        homeProvider.userSearchHistoryModel!
                                            .userSearchHistory!.isEmpty
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .recentSearch,
                                              style: GoogleFonts.sourceSans3(
                                                fontSize: 15,
                                                color: myLoading.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ListView.builder(
                                            itemCount: /* homeProvider
                                          .userSearchHistoryModel!
                                          .userSearchHistory!*/
                                                userSearchHistoryList!.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    SlideRightRoute(
                                                        page: ProfileScreen(
                                                      from: 'profile',
                                                      userId: /*homeProvider
                                                    .userSearchHistoryModel!
                                                    .userSearchHistory!*/
                                                          userSearchHistoryList![
                                                                  index]
                                                              .searchedUserId
                                                              .toString(),
                                                    )),
                                                  );
                                                },
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: 0,
                                                        vertical: -2),
                                                leading: Icon(
                                                  Icons.search,
                                                  color: myLoading.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  size: 20,
                                                ),
                                                title: Text(
                                                  /*  homeProvider
                                                    .userSearchHistoryModel!
                                                    .userSearchHistory!*/
                                                  userSearchHistoryList![index]
                                                          .searchedFullName ??
                                                      '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: myLoading.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    deleteSearchData(
                                                        context,
                                                        /*homeProvider
                                                      .userSearchHistoryModel!
                                                      .userSearchHistory!*/
                                                        userSearchHistoryList![
                                                                index]
                                                            .searchHistoryId
                                                            .toString(),
                                                        index);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                          if (searchNameController.text.isNotEmpty)
                            homeProvider.isSearchLoading ||
                                    homeProvider.searchListModel == null
                                ? const SearchListShimmer()
                                : homeProvider.searchListModel!.data == null ||
                                        homeProvider
                                            .searchListModel!.data!.isEmpty
                                    ? const DataNotFound()
                                    : ListView.builder(
                                        itemCount: homeProvider
                                            .searchListModel!.data!.length,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          String initials = homeProvider
                                                          .searchListModel!
                                                          .data![index]
                                                          .fullName !=
                                                      null ||
                                                  homeProvider
                                                          .searchListModel!
                                                          .data![index]
                                                          .fullName !=
                                                      ""
                                              ? homeProvider.searchListModel!
                                                  .data![index].fullName!
                                                  .trim()
                                                  .split(' ')
                                                  .map((e) => e[0])
                                                  .take(2)
                                                  .join()
                                                  .toUpperCase()
                                              : '';

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: InkWell(
                                              onTap: () {
                                                StoreSearchDataRequestModel
                                                    requestModel =
                                                    StoreSearchDataRequestModel(
                                                        clickedUserId:
                                                            homeProvider
                                                                .searchListModel!
                                                                .data![index]
                                                                .userId,
                                                        clickedFullName:
                                                            homeProvider
                                                                .searchListModel!
                                                                .data![index]
                                                                .fullName,
                                                        clickedUserName:
                                                            homeProvider
                                                                .searchListModel!
                                                                .data![index]
                                                                .userName);
                                                storeSearchHistory(
                                                    context, requestModel);

                                                Navigator.push(
                                                  context,
                                                  SlideRightRoute(
                                                      page: ProfileScreen(
                                                    from: 'profile',
                                                    userId: homeProvider
                                                        .searchListModel!
                                                        .data![index]
                                                        .userId
                                                        .toString(),
                                                  )),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor: myLoading
                                                            .isDark
                                                        ? Colors.grey.shade700
                                                        : Colors.grey.shade200,
                                                    child: ClipOval(
                                                      child: homeProvider
                                                                  .searchListModel!
                                                                  .data![index]
                                                                  .userProfile !=
                                                              null
                                                          ? CachedNetworkImage(
                                                              imageUrl: homeProvider
                                                                  .searchListModel!
                                                                  .data![index]
                                                                  .userProfile!,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  buildInitialsAvatar(
                                                                      initials,
                                                                      fontSize:
                                                                          13),
                                                              fit: BoxFit.cover,
                                                              width: 80,
                                                              // Match the size of the CircleAvatar
                                                              height: 80,
                                                            )
                                                          : buildInitialsAvatar(
                                                              initials,
                                                              fontSize: 13),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        homeProvider
                                                                .searchListModel!
                                                                .data![index]
                                                                .fullName ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 13,
                                                          color: myLoading
                                                                  .isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        homeProvider
                                                                .searchListModel!
                                                                .data![index]
                                                                .userName ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: myLoading
                                                                  .isDark
                                                              ? Colors.white60
                                                              : Colors.black26,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ))
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
