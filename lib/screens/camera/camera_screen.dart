import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/screens/camera/preview_screen.dart';
import 'package:hoonar/screens/camera/widget/confirmation_dialog.dart';
import 'package:hoonar/screens/camera/widget/seconds_tab.dart';
import 'package:hoonar_camera/hoonar_camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/const_res.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../model/sound.dart';

class CameraScreen extends StatefulWidget {
  final String? soundUrl;
  final String? soundTitle;
  final String? soundId;

  CameraScreen({this.soundUrl, this.soundTitle, this.soundId});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isFlashOn = false;
  bool isFront = false;
  bool isSelected15s = true;
  bool isMusicSelect = true;
  bool isStartRecording = false;
  bool isRecordingStaring = false;
  bool isShowPlayer = false;
  String? soundId = '';

  Timer? timer;
  double currentSecond = 0;
  double currentPercentage = 0;

  double totalSeconds = 15;

  AudioPlayer? _audioPlayer;

  SoundList? _selectedMusic;
  String? _localMusic;

  Map<String, dynamic> creationParams = <String, dynamic>{};
  FlutterVideoInfo _flutterVideoInfo = FlutterVideoInfo();
  ReceivePort _port = ReceivePort();
  ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initPermission();
    if (widget.soundUrl != null) {
      soundId = widget.soundId;
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback);
      downloadMusic();
    }
    MethodChannel(ConstRes.hoonarCamera).setMethodCallHandler((payload) async {
      gotoPreviewScreen(payload.arguments.toString());
      return;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer?.release();
    _audioPlayer?.dispose();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Platform.isAndroid
                ? AndroidView(
                    viewType: 'camera',
                    layoutDirection: TextDirection.ltr,
                    creationParams: creationParams,
                    creationParamsCodec: StandardMessageCodec(),
                  )
                : UiKitView(
                    viewType: 'camera',
                    layoutDirection: TextDirection.ltr,
                    creationParams: creationParams,
                    creationParamsCodec: StandardMessageCodec(),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                /*top options*/
                SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      isRecordingStaring
                          ? SizedBox()
                          : Visibility(
                              visible: soundId == null || soundId!.isEmpty,
                              child: InkWell(
                                onTap: () {
                                  /*showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(15))),
                                        backgroundColor: blueButtonColor,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return MusicScreen(
                                            (data, localMusic) async {
                                              isMusicSelect = true;
                                              _selectedMusic = data;
                                              _localMusic = localMusic;
                                              soundId = data?.soundId.toString();
                                              setState(() {});
                                            },
                                          );
                                        },
                                      ).then((value) {
                                        Provider.of<MyLoading>(context,
                                                listen: false)
                                            .setLastSelectSoundId('');
                                      });*/
                                },
                                child: Image.asset(
                                  'assets/images/music.png',
                                  height: 33,
                                  width: 33,
                                ),
                              ),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/timer.png',
                        height: 33,
                        width: 33,
                      ),
                      Spacer(),
                      if (!isStartRecording)
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (mContext) {
                                  return ConfirmationDialog(
                                    aspectRatio: 2,
                                    title1: AppLocalizations.of(context)!
                                        .areYouSure,
                                    title2: AppLocalizations.of(context)!
                                        .doYouReallyWantToGoBack,
                                    positiveText:
                                        AppLocalizations.of(context)!.yes,
                                    isDarkMode: myLoading.isDark,
                                    onPositiveTap: () async {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                          },
                          child: Image.asset(
                            'assets/images/close.png',
                            height: 33,
                            width: 33,
                          ),
                        ),
                    ],
                  ),
                )),
                Visibility(
                  visible: isMusicSelect,
                  replacement: SizedBox(height: 10),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: myLoading.isDark
                            ? Colors.white.withOpacity(0.3)
                            : Colors.black.withOpacity(0.3)),
                    child: Text(
                      widget.soundTitle != null
                          ? widget.soundTitle ?? ''
                          : _selectedMusic != null
                              ? _selectedMusic?.soundTitle ?? ''
                              : '',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color:
                              myLoading.isDark ? Colors.white : Colors.black),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Spacer(),
                isRecordingStaring
                    ? SizedBox()
                    : Visibility(
                        visible: !isMusicSelect,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SecondsTab(
                              onTap: () {
                                isSelected15s = true;
                                totalSeconds = 15;
                                setState(() {});
                              },
                              isSelected: isSelected15s,
                              title: '15',
                            ),
                            SizedBox(width: 15),
                            SecondsTab(
                              onTap: () {
                                isSelected15s = false;
                                totalSeconds = 30;
                                setState(() {});
                              },
                              isSelected: !isSelected15s,
                              title: '30',
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 5),
                SafeArea(
                  top: false,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isRecordingStaring
                              ? SizedBox(
                                  width: 40,
                                  height: isMusicSelect ? 0 : 40,
                                )
                              : Container(
                                  width: 40,
                                  height: isMusicSelect ? 0 : 40,
                                  child: IconWithRoundGradient(
                                    iconData: Icons.image,
                                    size: isMusicSelect ? 0 : 20,
                                    onTap: () => _showFilePicker(),
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: IconWithRoundGradient(
                              size: 20,
                              iconData: !isFlashOn
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_off_rounded,
                              onTap: () async {
                                isFlashOn = !isFlashOn;
                                setState(() {});
                                await HoonarCamera.flashOnOff;
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              isStartRecording = !isStartRecording;
                              isRecordingStaring = true;
                              setState(() {});
                              startProgress();
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white60,
                                  shape: BoxShape.circle),
                              // padding: EdgeInsets.all(10.0),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: CircularProgressIndicator(
                                        backgroundColor: Colors.white60,
                                        strokeWidth: 20,
                                        value: currentPercentage / 100,
                                        color: orangeColor),
                                  ),
                                  isStartRecording
                                      ? Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.pause,
                                            color: buttonBlueColor,
                                            size: 50,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: isStartRecording
                                                ? BoxShape.rectangle
                                                : BoxShape.circle,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          isStartRecording
                              ? SizedBox()
                              : IconWithRoundGradient(
                                  iconData: Icons.flip_camera_android_rounded,
                                  size: 20,
                                  onTap: () async {
                                    isFront = !isFront;
                                    await HoonarCamera.toggleCamera;
                                    setState(() {});
                                  },
                                ),
                          Visibility(
                            visible: !isStartRecording,
                            replacement: SizedBox(height: 38, width: 38),
                            child: IconWithRoundGradient(
                              iconData: Icons.check_circle_rounded,
                              size: 20,
                              onTap: () async {
                                if (!isRecordingStaring) {
                                  // CommonUI.showToast(msg: LKey.videoIsToShort.tr);
                                } else {
                                  if (soundId != null &&
                                      soundId!.isNotEmpty &&
                                      Platform.isIOS) {
                                    await _stopAndMergeVideoForIos();
                                  } else {
                                    await HoonarCamera.stopRecording;
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (!_permissionNotGranted)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: buttonBlueColor,
                child: SafeArea(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            // Get.back();
                          },
                          child: Container(
                              height: 35,
                              width: 35,
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white.withOpacity(0.1)),
                              alignment: Alignment.center,
                              child: const Icon(Icons.close_rounded,
                                  color: Colors.white, size: 25)),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Allow',
                            children: [
                              TextSpan(
                                  text: appName,
                                  style: TextStyle(
                                      color: Colors.pink, fontSize: 17)),
                              TextSpan(text: ' Access permission')
                            ],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          ifAppearsThatCameraPermissionHasNotBeenGrantedEtc,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          openAppSettings();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            openSettings,
                            style: TextStyle(color: Colors.pink, fontSize: 15),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 33),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 40,
                            height: isMusicSelect ? 0 : 40,
                            child: IconWithRoundGradient(
                              iconData: Icons.image,
                              size: isMusicSelect ? 0 : 20,
                              onTap: () => _showFilePicker(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15)
                    ],
                  ),
                ),
              )
          ],
        ),
      );
    });
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      int status = data[1];

      if (status == 3) {
        Navigator.pop(context);
        _audioPlayer = AudioPlayer();
        isMusicSelect = true;
        _localMusic = _localMusic! + '/' + widget.soundUrl!;
        setState(() {});
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  void downloadMusic() async {
    _localMusic =
        (await _findLocalPath()) + Platform.pathSeparator + ConstRes.camera;
    final savedDir = Directory(_localMusic!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    if (File(_localMusic! + widget.soundUrl!).existsSync()) {
      File(_localMusic! + widget.soundUrl!).deleteSync();
    }
    /*await FlutterDownloader.enqueue(
      url: ConstRes.itemBaseUrl + widget.soundUrl!,
      savedDir: _localMusic!,
      showNotification: false,
      openFileFromNotification: false,
    );
    CommonUI.showLoader(context);*/
  }

  // Recording
  void startProgress() async {
    if (timer == null) {
      initProgress();
    } else {
      if (isStartRecording) {
        initProgress();
      } else {
        cancelTimer();
      }
    }

    if (isStartRecording) {
      if (currentSecond == 0) {
        if (soundId != null && soundId!.isNotEmpty) {
          try {
            _audioPlayer = AudioPlayer(playerId: '1');
            await _audioPlayer?.play(
              DeviceFileSource(_localMusic!),
              mode: PlayerMode.mediaPlayer,
              ctx: AudioContext(
                android: AudioContextAndroid(isSpeakerphoneOn: true),
                iOS: AudioContextIOS(
                  category: AVAudioSessionCategory.playAndRecord,
                  options: {
                    AVAudioSessionOptions.allowAirPlay,
                    AVAudioSessionOptions.allowBluetooth,
                    AVAudioSessionOptions.allowBluetoothA2DP,
                    AVAudioSessionOptions.defaultToSpeaker,
                  },
                ),
              ),
            );
            var totalSecond = await Future.delayed(
              Duration(milliseconds: 300),
              () => _audioPlayer!.getDuration(),
            );
            totalSeconds = totalSecond!.inSeconds.toDouble();
            initProgress();
          } catch (e) {
            print('Error playing audio: $e');
          }
        }

        try {
          await HoonarCamera.startRecording();
        } catch (e) {
          print('Error starting recording: $e');
        }
      } else {
        print('Audio Resume Recording');
        try {
          await _audioPlayer?.resume();
          await HoonarCamera.resumeRecording();
        } catch (e) {
          print('Error resuming recording: $e');
        }
      }
    } else {
      print('Audio Pause Recording');
      try {
        await _audioPlayer?.pause();
        await HoonarCamera.pauseRecording();
      } catch (e) {
        print('Error pausing recording: $e');
      }
    }

    print('============ $currentSecond');
  }

  // Stop Merge For iOS
  Future<void> _stopAndMergeVideoForIos({bool isAutoStop = false}) async {
    print('_stopAndMergeVideoForIos');
    // CommonUI.showLoader(context);
    if (isAutoStop) {
      await HoonarCamera.pauseRecording;
    }
    await Future.delayed(Duration(milliseconds: 500));
    await HoonarCamera.mergeAudioVideo(_localMusic ?? '');
  }

  void gotoPreviewScreen(String pathOfVideo) async {
    if (soundId != null && soundId!.isNotEmpty) {
      // CommonUI.showLoader(context);
      try {
        String localPath = await _findLocalPath();
        if (!Platform.isAndroid) {
          await FFmpegKit.execute(
              '-i $pathOfVideo -y -ss 00:00:01.000 -vframes 1 "$localPath${Platform.pathSeparator}thumbNail.png"');
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewScreen(
                postVideo: pathOfVideo,
                thumbNail: "$localPath${Platform.pathSeparator}thumbNail.png",
                soundId: soundId,
                duration: currentSecond.toInt(),
              ),
            ),
          );
        } else {
          if (isFront) {
            await FFmpegKit.execute(
                '-i "$pathOfVideo" -y -vf hflip "$localPath${Platform.pathSeparator}out1.mp4"');
            await FFmpegKit.execute(
                '-i "$localPath${Platform.pathSeparator}out1.mp4" -i $_localMusic -y -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $localPath${Platform.pathSeparator}out.mp4');
            await FFmpegKit.execute(
                '-i $localPath${Platform.pathSeparator}out.mp4 -y -ss 00:00:01.000 -vframes 1 "$localPath${Platform.pathSeparator}thumbNail.png"');
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(
                  postVideo: '$localPath${Platform.pathSeparator}out.mp4',
                  thumbNail: "$localPath${Platform.pathSeparator}thumbNail.png",
                  soundId: soundId,
                  duration: currentSecond.toInt(),
                ),
              ),
            );
          } else {
            await FFmpegKit.execute(
                '-i $pathOfVideo -i $_localMusic -y -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $localPath${Platform.pathSeparator}out.mp4');
            await FFmpegKit.execute(
                '-i $localPath${Platform.pathSeparator}out.mp4 -y -ss 00:00:01.000 -vframes 1 "$localPath${Platform.pathSeparator}thumbNail.png"');
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(
                  postVideo: '$localPath${Platform.pathSeparator}out.mp4',
                  thumbNail: "$localPath${Platform.pathSeparator}thumbNail.png",
                  soundId: soundId,
                  duration: currentSecond.toInt(),
                ),
              ),
            );
          }
        }
      } catch (e) {
        Navigator.pop(context);
      }
      return;
    }

    // CommonUI.showLoader(context);
    try {
      String localPath = await _findLocalPath();
      String soundPath =
          '$localPath${Platform.pathSeparator}${DateTime.now().millisecondsSinceEpoch.toString()}sound.wav';
      await FFmpegKit.execute('-i "$pathOfVideo" -y $soundPath');
      if (Platform.isAndroid && isFront) {
        await FFmpegKit.execute(
            '-i "$pathOfVideo" -y -vf hflip "$localPath${Platform.pathSeparator}out1.mp4"');
        await FFmpegKit.execute(
            '-i "$localPath${Platform.pathSeparator}out1.mp4" -y -ss 00:00:01.000 -vframes 1 "$localPath${Platform.pathSeparator}thumbNail.png"');
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(
              postVideo: '$localPath${Platform.pathSeparator}out1.mp4',
              thumbNail: '$localPath${Platform.pathSeparator}thumbNail.png',
              sound: soundPath,
              duration: currentSecond.toInt(),
            ),
          ),
        );
      } else {
        await FFmpegKit.execute(
            '-i "$pathOfVideo" -y -ss 00:00:01.000 -vframes 1 "$localPath${Platform.pathSeparator}thumbNail.png"');
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(
              postVideo: pathOfVideo,
              thumbNail: "$localPath${Platform.pathSeparator}thumbNail.png",
              sound: soundPath,
              duration: currentSecond.toInt(),
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      // CommonUI.showToast(msg: LKey.anErrorOccurredWhileProcessingTheEtc.tr);
    }
  }

  void _showFilePicker() async {
    HapticFeedback.mediumImpact();
    // CommonUI.getLoader();
    try {
      final videoFile = await _picker.pickVideo(
          source: ImageSource.gallery, maxDuration: Duration(minutes: 1));
      // Get.back();
      Navigator.pop(context);
      if (videoFile != null && videoFile.path.isNotEmpty) {
        double fileSize = await getFileSizeInMB(File(videoFile.path));
        try {
          VideoData? videoInfo =
              await _flutterVideoInfo.getVideoInfo(videoFile.path);
          if (fileSize > maxUploadMB) {
            // Get.dialog(ConfirmationDialog(
            //   aspectRatio: 1.8,
            //   title1: LKey.tooLargeVideo,
            //   title2: LKey.thisVideoIsGreaterThan50MbNPleaseSelectAnother.tr,
            //   positiveText: LKey.selectAnother.tr,
            //   onPositiveTap: () {
            //     Get.back();
            //     _showFilePicker();
            //   },
            // ));

            return;
          }

          if (((videoInfo?.duration ?? 0) / 1000) > maxUploadSecond) {
            // Get.dialog(ConfirmationDialog(
            //   aspectRatio: 1.8,
            //   title1: LKey.tooLongVideo.tr,
            //   title2: LKey.thisVideoIsGreaterThan1MinNPleaseSelectAnother.tr,
            //   positiveText: LKey.selectAnother.tr,
            //   onPositiveTap: () {
            //     Get.back();
            //     _showFilePicker();
            //   },
            // ));
            // return;
          }

          // CommonUI.getLoader();

          try {
            String localPath = await _findLocalPath();
            await FFmpegKit.execute(
                '-i "${videoFile.path}" -y $localPath${Platform.pathSeparator}sound.wav');
            await FFmpegKit.execute(
                '-i "${videoFile.path}" -y -ss 00:00:01.000 -vframes 1 "$localPath${Platform.pathSeparator}thumbNail.png"');

            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PreviewScreen(
                          postVideo: videoFile.path,
                          thumbNail:
                              "$localPath${Platform.pathSeparator}thumbNail.png",
                          sound: "$localPath${Platform.pathSeparator}sound.wav",
                          duration: (videoInfo?.duration ?? 0) ~/ 1000,
                        )));
            // Get.back(); // Close the loader
            // Get.to(() => PreviewScreen(
            //       postVideo: videoFile.path,
            //       thumbNail: "$localPath${Platform.pathSeparator}thumbNail.png",
            //       sound: "$localPath${Platform.pathSeparator}sound.wav",
            //       duration: (videoInfo?.duration ?? 0) ~/ 1000,
            //     ));
          } catch (e) {
            // Get.back(); // Close the loader if FF mpeg fails
            Navigator.pop(context);
            print(anErrorOccurredWhileProcessingTheEtc);
            // CommonUI.showToast(
            //     msg: LKey.anErrorOccurredWhileProcessingTheEtc.tr);
          }
        } catch (e) {
          Navigator.pop(context);
          print(pleaseAcceptLibraryPermissionToPickAVideo);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      print(pleaseAcceptLibraryPermissionToPickAVideo);
    }
  }

  void initProgress() {
    timer?.cancel();
    timer = null;

    timer = Timer.periodic(Duration(milliseconds: 10), (time) async {
      currentSecond += 0.01;
      currentPercentage = (100 * currentSecond) / totalSeconds;
      if (totalSeconds.toInt() <= currentSecond.toInt()) {
        timer?.cancel();
        timer = null;
        if (soundId != null && soundId!.isNotEmpty && Platform.isIOS) {
          _stopAndMergeVideoForIos(isAutoStop: true);
        } else {
          await HoonarCamera.stopRecording;
        }
      }
      setState(() {});
    });
  }

  void cancelTimer() {
    timer?.cancel();
    timer = null;
  }

  Future<double> getFileSizeInMB(File file) async {
    try {
      int fileSizeInBytes = await file.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      return fileSizeInMB;
    } catch (e) {
      print('Error getting file size: $e');
      return -1;
    }
  }

  bool _permissionNotGranted = true;

  void initPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    print(statuses[Permission.camera]!.isGranted);
    print(statuses[Permission.microphone]!.isGranted);
    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted) {
      print('Granted');
      _permissionNotGranted = true;
    } else {
      _permissionNotGranted = false;
      print('Not Granted');
    }
    setState(() {});
  }
}

class IconWithRoundGradient extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Function? onTap;

  IconWithRoundGradient(
      {required this.iconData, required this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.pink])),
          child: Icon(iconData, color: Colors.white, size: size),
        ),
      ),
    );
  }
}

class ImageWithRoundGradient extends StatelessWidget {
  final String imageData;
  final double padding;

  ImageWithRoundGradient(this.imageData, this.padding);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pink],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Image(
            image: AssetImage(imageData),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
