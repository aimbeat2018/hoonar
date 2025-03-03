import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/success_models/sound_category_list_model.dart';
import 'package:hoonar/screens/camera/sounds/local_video_selected_screen.dart';
import 'package:hoonar/screens/camera/sounds/trim_audio_screen.dart';
import 'package:hoonar/shimmerLoaders/following_list_shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/success_models/sound_by_category_list_model.dart';
import '../../../model/success_models/sound_list_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';

class SelectSoundListScreen extends StatefulWidget {
  final String? duration;

  const SelectSoundListScreen({super.key, this.duration});

  @override
  State<SelectSoundListScreen> createState() => _SelectSoundListScreenState();
}

class _SelectSoundListScreenState extends State<SelectSoundListScreen> {
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  TextEditingController searchController = TextEditingController();
  ScrollController soundListScrollController = ScrollController();
  SessionManager sessionManager = SessionManager();
  bool isAudioPlaying = false, isLoading = false, isMoreLoading = false;
  late AudioPlayer audioPlayer;
  int selectedIndex = -1;
  int page = 1, searchPage = 1;
  bool? isSearching = false;
  String? selectedCategoryId = "";
  List<SoundByCategoryListData> soundListData = [];
  List<SoundByCategoryListData> newSoundListData = [];

  @override
  void initState() {
    // TODO: implement initState
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

    audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSoundCategoryList(context);
    });

    soundListScrollController.addListener(loadMore);
  }

  loadMore() {
    if (soundListScrollController.position.maxScrollExtent ==
        soundListScrollController.position.pixels) {
      if (!isLoading) {
        setState(() {
          isMoreLoading = true;
          page++;
        });

        getSoundList(context, selectedCategoryId!);
      }
    }
  }

  Future<void> getSoundList(BuildContext context, String categoryId) async {
    setState(() {
      if (page == 1) {
        isLoading = true;
      } else {
        isMoreLoading = true;
      }
    });

    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel =
          CommonRequestModel(soundCategoryId: categoryId, start: page);

      await contestProvider.getSoundByCategoryList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.soundByCategoryListModel?.status == '200') {
          if (contestProvider.soundByCategoryListModel != null ||
              contestProvider.soundByCategoryListModel!.data != null ||
              contestProvider.soundByCategoryListModel!.data!.isNotEmpty) {
            if (page == 1) {
              soundListData = contestProvider.soundByCategoryListModel!.data!;
            } else {
              newSoundListData = [];
              newSoundListData =
                  contestProvider.soundByCategoryListModel!.data!;

              if (newSoundListData.isNotEmpty) {
                soundListData.addAll(newSoundListData);
                soundListData = soundListData.toSet().toList();
              }
            }
          }
        } else if (contestProvider.soundByCategoryListModel?.status == '401') {
          if (page == 1) {
            soundListData = contestProvider.soundByCategoryListModel!.data!;
          } else {
            newSoundListData = [];
            newSoundListData = contestProvider.soundByCategoryListModel!.data!;

            if (newSoundListData.isNotEmpty) {
              soundListData.addAll(newSoundListData);
              soundListData = soundListData.toSet().toList();
            }
          }
        } else if (contestProvider.soundByCategoryListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.soundByCategoryListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });

    if (page == 1) {
      isLoading = false;
    } else {
      isMoreLoading = false;
    }
    setState(() {});
  }

  Future<void> getSoundCategoryList(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel =
          CommonRequestModel(/*date: _selectedDate*/);

      await contestProvider.getSoundCategoryList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.soundCategoryListModel?.status == '200') {
          if (mounted) {
            setState(() {
              selectedCategoryId = contestProvider
                  .soundCategoryListModel?.data?[0].soundCategoryId
                  .toString();
            });

            getSoundList(context, selectedCategoryId!);
          }
        } else if (contestProvider.soundCategoryListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.soundCategoryListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> searchSound(BuildContext context, String searchKey) async {
    setState(() {
      if (searchPage == 1) {
        isLoading = true;
      } else {
        isMoreLoading = true;
      }
    });

    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel = CommonRequestModel(
          soundCategoryId: selectedCategoryId,
          start: searchPage,
          searchTerm: searchKey);

      await contestProvider.getSoundSearchList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.searchSoundByCategoryListModel?.status == '200') {
          if (contestProvider.searchSoundByCategoryListModel != null ||
              contestProvider.searchSoundByCategoryListModel!.data != null ||
              contestProvider
                  .searchSoundByCategoryListModel!.data!.isNotEmpty) {
            if (searchPage == 1) {
              soundListData =
                  contestProvider.searchSoundByCategoryListModel!.data!;
            } else {
              newSoundListData = [];
              newSoundListData =
                  contestProvider.searchSoundByCategoryListModel!.data!;

              if (newSoundListData.isNotEmpty) {
                soundListData.addAll(newSoundListData);
                soundListData = soundListData.toSet().toList();
              }
            }
          }
        } else if (contestProvider.searchSoundByCategoryListModel?.status ==
            '401') {
          if (searchPage == 1) {
            soundListData =
                contestProvider.searchSoundByCategoryListModel!.data!;
          } else {
            newSoundListData = [];
            newSoundListData =
                contestProvider.searchSoundByCategoryListModel!.data!;

            if (newSoundListData.isNotEmpty) {
              soundListData.addAll(newSoundListData);
              soundListData = soundListData.toSet().toList();
            }
          }
        } else if (contestProvider.searchSoundByCategoryListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.searchSoundByCategoryListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });

    if (searchPage == 1) {
      isLoading = false;
    } else {
      isMoreLoading = false;
    }
    setState(() {});
  }

  Future<void> saveSound(
      BuildContext context, String soundId, int index1, int index2) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel = CommonRequestModel(soundId: soundId);

      await contestProvider.saveSound(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.savedSoundModel?.status == '200') {
          if (contestProvider.savedSoundModel?.message ==
              'Sound added to saved list') {
            setState(() {
              contestProvider
                  .soundListModel!.data![index1].soundList![index2].isSaved = 1;
            });
          } else {
            setState(() {
              contestProvider
                  .soundListModel!.data![index1].soundList![index2].isSaved = 0;
            });
          }
        } else if (contestProvider.savedSoundModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.savedSoundModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<bool> _onWillPop() async {
    // Stop audio when back button is pressed
    if (isAudioPlaying) {
      await audioPlayer.stop();
      setState(() {
        isAudioPlaying = false;
      });
    }
    return true; // Allow back navigation
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final contestProvider = Provider.of<ContestProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : WillPopScope(
              onWillPop: _onWillPop,
              child: AbsorbPointer(
                // Absorbs all UI interactions when loading
                absorbing: isLoading,
                child: Scaffold(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if (isAudioPlaying) {
                                          await audioPlayer.stop();
                                          setState(() {
                                            isAudioPlaying = false;
                                          });
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 13),
                                        child: Image.asset(
                                          'assets/images/back_image.png',
                                          height: 28,
                                          width: 28,
                                          color: myLoading.isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: GradientText(
                                          AppLocalizations.of(context)!
                                              .musicLibrary,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
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
                                                  : Colors.grey.shade700,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: menuItemsWidget(myLoading.isDark),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    height: 40, // Adjust height as needed
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: contestProvider
                                              .soundCategoryListModel
                                              ?.data
                                              ?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        return buildCategoryItem(
                                          contestProvider
                                              .soundCategoryListModel!
                                              .data![index],
                                          index,
                                          myLoading.isDark,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'search song by name',
                                      hintStyle: GoogleFonts.poppins(
                                        color: hintGreyColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      border: GradientOutlineInputBorder(
                                        width: 1,
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          colors: [
                                            myLoading.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            greyTextColor4
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 20),
                                    ),
                                    controller: searchController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        if (value.length > 5) {
                                          setState(() {
                                            isSearching = true;
                                            searchPage = 1;
                                          });
                                          searchSound(context, value);
                                        }
                                      } else {
                                        setState(() {
                                          isSearching = false;
                                          page = 1;
                                        });
                                        getSoundList(
                                            context, selectedCategoryId!);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  // Makes the list scrollable properly
                                  child: isLoading && soundListData.isEmpty
                                      ? const FollowingListShimmer()
                                      : soundListData.isEmpty
                                          ? const DataNotFound()
                                          : ListView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              controller:
                                                  soundListScrollController,
                                              itemCount: soundListData.length,
                                              itemBuilder: (context, index) {
                                                /*return buildSoundItem(
                                                  contestProvider
                                                      .soundByCategoryListModel!
                                                      .data![index],
                                                  index,
                                                  myLoading.isDark,
                                                );*/

                                                return soundItem(
                                                    soundListData[index],
                                                    index,
                                                    myLoading.isDark,
                                                    index);
                                              },
                                            ),
                                ),
                                if (isMoreLoading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: myLoading.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                              ],
                            ),
                            if (isLoading)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
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

  Future<File> _downloadAudio(String url) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(url));
    final directory = await getTemporaryDirectory();
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${directory.path}/${timestamp}_temp_audio.mp3';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Widget soundItem(
      SoundByCategoryListData model, int index, bool isDarkMode, int index1) {
    // int selectedSoundId = -1;
    // final AudioPlayer audioPlayer = AudioPlayer();

    return InkWell(
      onTap: () async {
        if (widget.duration != '0') {
          String duration1 = model.duration!;

          Duration duration2 = Duration(
              milliseconds: (double.parse(widget.duration!) * 1000).toInt());

          List<String> parts =
              duration1.split(duration1.contains(":") ? ":" : ".");
          int minutes = int.parse(parts[0]);
          int seconds = int.parse(parts[1]);
          Duration parsedDuration1 =
              Duration(minutes: minutes, seconds: seconds);

          if (parsedDuration1 > duration2) {
            File localMusic = await _downloadAudio(model.sound ?? '');

            _openTrimBottomSheet(context, localMusic.path,
                double.parse(widget.duration!).toInt(), model);
          } else {
            if (mounted) {
              Navigator.pop(context, model);
            }
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 5),
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: model.soundImage ?? '',
                    // Replace with your image URL
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.soundTitle ?? '',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      model.singer ?? '',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.black26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),
                InkWell(
                  onTap: () async {
                    if (isAudioPlaying) {
                      await audioPlayer.stop();
                      setState(() {
                        isAudioPlaying = false;
                        selectedIndex = index;
                      });
                    } else {
                      setState(() {
                        isAudioPlaying = true;
                        selectedIndex = index;
                      });
                      await audioPlayer.play(UrlSource(model.sound ?? ''));
                    }
                  },
                  child: Icon(
                    isAudioPlaying && selectedIndex == index
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 25,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    saveSound(
                        context, model.soundId!.toString(), index1, index);
                  },
                  child: Provider.of<ContestProvider>(context)
                              .isSavedSoundLoading &&
                          selectedIndex == index
                      ? Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        )
                      : Image.asset(
                          model.isSaved == 0
                              ? 'assets/images/unsave_music.png'
                              : 'assets/images/save_music.png',
                          height: 23,
                          width: 23,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem(
      SoundCategoryData model, int index, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedCategoryId = model.soundCategoryId.toString();
          });

          getSoundList(context, selectedCategoryId!);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                model.soundCategoryName ?? '',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (selectedCategoryId == model.soundCategoryId.toString())
              Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: 1.5,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ],
              ), // Space between text and divider
          ],
        ),
      ),
    );
  }

  /* Widget buildSoundItem(
      SoundByCategoryListData model, int index, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: model.soundList!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index1) {
                return soundItem(
                    model.soundList![index1], index1, isDarkMode, index);
                */ /* return SoundItemWidget(
                    model: model.soundList![index1],
                    index: index1,
                    isDarkMode: isDarkMode,
                    index1: index);*/ /*
              })
        ],
      ),
    );
  }
*/
  Widget menuItemsWidget(bool isDarkMode) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      icon: Image.asset(
        'assets/images/menu.png',
        height: 30,
        width: 30,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        /*   PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.uploadedMusic,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              SlideRightRoute(page: const AddBankDetailsScreen()),
            );
          },
        ),*/
        PopupMenuItem(
          height: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.savedFile,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              SlideRightRoute(
                  page: LocalVideoSelectedScreen(
                duration: widget.duration,
              )),
            );
          },
        ),
      ],
    );
  }

  void _openTrimBottomSheet(BuildContext context, String audioFilePath,
      int trimSecs, SoundByCategoryListData model) {
    setState(() {
      isLoading = false;
      isAudioPlaying = false;
    });
    audioPlayer.stop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return TrimAudioScreen(
          audioFilePath: audioFilePath,
          selectedDuration: trimSecs,
          model: model,
        );
      },
    ).then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            model.trimAudioPath = onValue;
          });

          Navigator.pop(context, model);
        }
      }
    });
  }
}
