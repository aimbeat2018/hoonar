import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/screens/camera/sounds/local_video_selected_screen.dart';
import 'package:hoonar/screens/camera/sounds/trim_audio_screen.dart';
import 'package:hoonar/shimmerLoaders/following_list_shimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/session_manager.dart';
import '../../../constants/slide_right_route.dart';
import '../../../constants/theme.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/success_models/sound_list_model.dart';
import '../../../providers/contest_provider.dart';
import '../../auth_screen/login_screen.dart';
import '../../hoonar_competition/yourRewards/wallet_screen.dart';

class SelectSoundListScreen extends StatefulWidget {
  final String? duration;

  const SelectSoundListScreen({super.key, this.duration});

  @override
  State<SelectSoundListScreen> createState() => _SelectSoundListScreenState();
}

class _SelectSoundListScreenState extends State<SelectSoundListScreen> {
  SessionManager sessionManager = SessionManager();
  bool isAudioPlaying = false;
  late AudioPlayer audioPlayer;
  int selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSoundList(context);
    });
  }

  Future<void> getSoundList(BuildContext context) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      CommonRequestModel requestModel =
          CommonRequestModel(/*date: _selectedDate*/);

      await contestProvider.getSoundList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (contestProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, contestProvider.errorMessage ?? '');
      } else {
        if (contestProvider.soundListModel?.status == '200') {
        } else if (contestProvider.soundListModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, contestProvider.soundListModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
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
  Widget build(BuildContext context) {
    final contestProvider = Provider.of<ContestProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return WillPopScope(
        onWillPop: _onWillPop,
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
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Column(
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
                              padding: const EdgeInsets.only(left: 13),
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
                              AppLocalizations.of(context)!.musicLibrary,
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
                                        : Colors.grey.shade700
                                  ]),
                            )),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: menuItemsWidget(myLoading.isDark))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      contestProvider.isSoundLoading ||
                              contestProvider.soundListModel == null
                          ? FollowingListShimmer()
                          : contestProvider.soundListModel!.data == null ||
                                  contestProvider.soundListModel!.data!.isEmpty
                              ? DataNotFound()
                              : AnimatedList(
                                  shrinkWrap: true,
                                  initialItemCount: contestProvider
                                      .soundListModel!.data!.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index, animation) {
                                    return buildSoundItem(
                                      contestProvider
                                          .soundListModel!.data![index],
                                      index,
                                      myLoading.isDark,
                                    ); // Build each list item
                                  },
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
    final response = await http.get(Uri.parse(url));
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temp_audio.mp3';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Widget soundItem(SoundList model, int index, bool isDarkMode, int index1) {
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
            File _localMusic = await _downloadAudio(model.sound ?? '');

            _openTrimBottomSheet(context, _localMusic.path,
                double.parse(widget.duration!).toInt(), model);
          } else {
            Navigator.pop(context, model);
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
                    SizedBox(
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
                SizedBox(
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

  Widget buildSoundItem(SoundListData model, int index, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              model.soundCategoryName ?? '',
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: model.soundList!.length,
              itemBuilder: (context, index1) {
                return soundItem(
                    model.soundList![index1], index1, isDarkMode, index);
                /* return SoundItemWidget(
                    model: model.soundList![index1],
                    index: index1,
                    isDarkMode: isDarkMode,
                    index1: index);*/
              })
        ],
      ),
    );
  }

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
              SlideRightRoute(page: LocalVideoSelectedScreen(duration: widget.duration,)),
            );
          },
        ),
      ],
    );
  }

  void _openTrimBottomSheet(BuildContext context, String audioFilePath,
      int trimSecs, SoundList model) {
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
        }
        Navigator.pop(context, model);
      }
    });
  }
}
