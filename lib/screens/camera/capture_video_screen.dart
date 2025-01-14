import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/model/success_models/sound_list_model.dart';
import 'package:hoonar/screens/camera/filters_screen.dart';
import 'package:hoonar/screens/camera/sounds/select_sound_list_screen.dart';
import 'package:hoonar/screens/camera/video_preview_screen.dart';
import 'package:hoonar/screens/camera/widget/confirmation_dialog.dart';

// import 'package:video_record_demo/musicLibrary/select_music_list_screen.dart';
// import 'package:video_record_demo/sound_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../constants/my_loading/my_loading.dart';

class CaptureVideoScreen extends StatefulWidget {
  final String from;

  const CaptureVideoScreen({super.key, required this.from});

  @override
  State<CaptureVideoScreen> createState() => _CaptureVideoScreenState();
}

class _CaptureVideoScreenState extends State<CaptureVideoScreen> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isFlashOn = false;
  int _cameraIndex = 0;
  bool _isPaused = false;
  bool isFront = false;
  bool isSelected15s = true;
  bool isSelected30s = false;
  bool isSelected60s = false;
  bool isMusicSelect = false;
  File? _videoFile;
  double totalSeconds = 60;
  Timer? timer;
  double currentSecond = 0;
  double currentPercentage = 0;
  bool _permissionNotGranted = true;
  List<String> _videoSegments = []; // Stores paths of video segments
  String? _mergedVideoPath;
  bool _isMerging = false;
  AudioPlayer? _audioPlayer;

  SoundList? _selectedMusic;
  File? _localMusic;
  Map<String, dynamic> selectedFilter = {
    "name": "Original",
    "filter": const ColorFilter.mode(
      Colors.transparent,
      BlendMode.srcOver,
    ),
    "filterStr": ''
  };

  @override
  void initState() {
    super.initState();
    _initializeCameras();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer?.release();
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _initializeCameras() async {
    try {
      // Get the available cameras
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Initialize the first camera by default
        await initCamera(cameras[_cameraIndex]);
      } else {
        print('No cameras available');
      }
    } catch (e) {
      print('Error retrieving cameras: $e');
    }
  }

  initCamera(CameraDescription cameraDescription) async {
    // Get the available cameras
    final cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      // Select the first camera
      final camera = cameras.first;

      _controller = CameraController(
        cameraDescription,
        ResolutionPreset.high,
        enableAudio: true,
      );

      try {
        await _controller.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      } catch (e) {
        print('Error initializing camera: $e');
      }
    } else {
      print('No cameras available');
    }
  }

  Future<void> _startRecording() async {
    if (_selectedMusic != null) {
      playAudio(_localMusic == null
          ? _selectedMusic!.sound ?? ''
          : _localMusic!.path);
    }

    final directory = await getTemporaryDirectory();
    final videoPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

    try {
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
        _isPaused = false;
      });
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _pauseRecording() async {
    // if (!_isRecording) return;

    try {
      final file = await _controller.pauseVideoRecording();
      // _videoSegments.add(file.path); // Save segment
      setState(() {
        _isPaused = true;
      });

      if (_selectedMusic != null) pauseAudio();
    } catch (e) {
      print('Error pausing recording: $e');
    }
  }

  Future<void> _resumeRecording() async {
    if (!_isPaused) return;

    try {
      await _startRecording(); // Start a new recording
      if (_selectedMusic != null) resumeAudio();
    } catch (e) {
      print('Error resuming recording: $e');
    }
  }

  Future<void> _stopRecording(bool isDone) async {
    // if (!_isRecording) return;

    try {
      final file = await _controller.stopVideoRecording();
      _videoSegments.add(file.path); // Save the final segment
      setState(() {
        _isRecording = false;
        _isPaused = false;
      });
      if (_selectedMusic != null) stopAudio();

      // Merge all video segments
      await _mergeVideoSegments(isDone);
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _mergeVideoSegments(bool isDone) async {
    if (_videoSegments.isEmpty) return;

    final directory = await getTemporaryDirectory();
    final outputFilePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_merged.mp4';

    // Build FFmpeg command to merge video segments
    final inputFileListPath = '${directory.path}/input.txt';
    final inputFile = File(inputFileListPath);

    // Create input file for FFmpeg
    final inputFileContent =
        _videoSegments.map((path) => "file '$path'").join('\n');
    await inputFile.writeAsString(inputFileContent);

    // Run FFmpeg command
    final command =
        '-f concat -safe 0 -i $inputFileListPath -c copy $outputFilePath';

    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print('Video merged successfully: $outputFilePath');
        setState(() {
          _mergedVideoPath = outputFilePath;
        });

        if (isDone) {
          _goToPreviewScreen(File(_mergedVideoPath!));
        }
      } else {
        if (_videoSegments.length == 1) {
          if (isDone) {
            _goToPreviewScreen(File(_videoSegments[0]));
          }
        }
        print('Error merging video segments');
      }
    });
  }

  Future<void> _mergeAudioWithVideo() async {
    setState(() {
      _isMerging = true;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final outputFilePath = '${tempDir.path}/merged_video_$timestamp.mp4';

      final mergeCommand =
          '-y -i "${_mergedVideoPath}" -i "${_localMusic!.path}" -map 0:v -map 1:a -c:v copy -shortest "$outputFilePath"';

      await FFmpegKit.execute(mergeCommand);

      final mergedFile = File(outputFilePath);
      _goToPreviewScreen(mergedFile);
    } catch (e) {
      print('Error during merge: $e');
    } finally {
      setState(() {
        _isMerging = false;
      });
    }
  }

  Future<void> _goToPreviewScreen(File mergedFile) async {
    /* if (selectedFilter['name'] != 'Original') {
      final tempDir = await getTemporaryDirectory();
      final outputFilePath = '${tempDir.path}/merged_filter_video.mp4';

      applyFilterToVideo(
          mergedFile.path, outputFilePath, selectedFilter['filterStr']);
    } else {*/
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          videoFile: mergedFile,
          selectedMusic: _selectedMusic,
          duration: totalSeconds.toString(),
          from: widget.from,
        ),
      ),
    );
    // }
  }

  Future<void> applyFilterToVideo(
      String inputPath, String outputPath, List<num> matrixValues) async {
    final matrix = matrixValues;
    final r1 = matrix[0];
    final g1 = matrix[1];
    final b1 = matrix[2];
    final r2 = matrix[5];
    final g2 = matrix[6];
    final b2 = matrix[7];
    final r3 = matrix[10];
    final g3 = matrix[11];
    final b3 = matrix[12];

    // Format the colorbalance filter string

    // final filter = 'colorbalance=r=$r1/$g1/$b1, g=$r2/$g2/$b2, b=$r3/$g3/$b3';
    final filter = 'colorbalance=r=$r1:$g1:$b1, g=$r2:$g2:$b2, b=$r3:$g3:$b3';

    // final command = '-i $inputPath -filter_complex "$filter" $outputPath';
    final command = '-i $inputPath -vf "hue=s=0" -report $outputPath';

    // FFmpeg command with a filter
    // final command = '-i $inputPath -vf $filter -preset ultrafast $outputPath';

    // final command = '-i $inputPath -vf "lut3d=size=33:r=\'0.393:0.769:0.189\':g=\'0.349:0.686:0.168\':b=\'0.272:0.534:0.131\'" -preset ultrafast $outputPath';
    // final command =
    //     '-i $inputPath -vf "colorbalance=r=0.393:0.769:0.189:0,0,0:0.349:0.686:0.168:0,0,0:0.272:0.534:0.131:0,0,0,1" -preset ultrafast $outputPath';

    // final command =
    //     '-i $inputPath -vf "colorbalance=r=0.393:g=0.769:b=0.189" -preset ultrafast $outputPath';
    print(command);

    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        print("Filter applied successfully!");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPreviewScreen(
              videoFile: File(outputPath),
              selectedMusic: _selectedMusic,
              duration: totalSeconds.toString(),
              from: widget.from,
            ),
          ),
        );
      } else {
        print("Failed to apply filter: ${await session.getLogsAsString()}");
      }
    });
  }

  Future<void> _toggleFlash() async {
    if (_controller.value.isInitialized) {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      await _controller.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  Future<void> _switchCamera() async {
    _cameraIndex = (_cameraIndex + 1) % cameras.length;
    await initCamera(cameras[_cameraIndex]);
  }

  Future<void> playAudio(String audioUrl) async {
    await _audioPlayer!.play(
      UrlSource(audioUrl),
      mode: PlayerMode.mediaPlayer,
    );
  }

  Future<void> stopAudio() async {
    await _audioPlayer!.stop();
  }

  Future<void> resumeAudio() async {
    await _audioPlayer!.resume();
  }

  Future<void> pauseAudio() async {
    await _audioPlayer!.pause();
  }

  //
  Future<void> _selectVideoFromGallery() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
      print('Selected video: ${_videoFile!.path}');

      if (_selectedMusic == null) {
        _goToPreviewScreen(_videoFile!);
      } else {
        setState(() {
          _mergedVideoPath = _videoFile!.path;
        });
        _mergeAudioWithVideo();
      }
    }
  }

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

  void requestPermissions() async {
    // Request camera and microphone permissions
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      // Both permissions granted, initialize the camera
      print('Permissions Granted');

      _initializeCameras();
    } else {}
    setState(() {});
  }

  // Recording
  void startProgress() async {
    if (timer == null) {
      initProgress(false);
    } else {
      if (_isRecording) {
        initProgress(false);
      } else {
        cancelTimer();
      }
    }

    if (_isRecording) {
      if (currentSecond == 0) {
        // if (soundId != null && soundId!.isNotEmpty) {
        //   try {
        //     _audioPlayer = AudioPlayer(playerId: '1');
        //     await _audioPlayer?.play(
        //       DeviceFileSource(_localMusic!),
        //       mode: PlayerMode.mediaPlayer,
        //       ctx: AudioContext(
        //         android: AudioContextAndroid(isSpeakerphoneOn: true),
        //         iOS: AudioContextIOS(
        //           category: AVAudioSessionCategory.playAndRecord,
        //           options: {
        //             AVAudioSessionOptions.allowAirPlay,
        //             AVAudioSessionOptions.allowBluetooth,
        //             AVAudioSessionOptions.allowBluetoothA2DP,
        //             AVAudioSessionOptions.defaultToSpeaker,
        //           },
        //         ),
        //       ),
        //     );
        //     var totalSecond = await Future.delayed(
        //       Duration(milliseconds: 300),
        //           () => _audioPlayer!.getDuration(),
        //     );
        //     totalSeconds = totalSecond!.inSeconds.toDouble();
        //     initProgress();
        //   } catch (e) {
        //     print('Error playing audio: $e');
        //   }
        // }

        try {
          _startRecording();
        } catch (e) {
          print('Error starting recording: $e');
        }
      } else {
        print('Audio Resume Recording');
        try {
          // await _audioPlayer?.resume();
          _resumeRecording();
        } catch (e) {
          print('Error resuming recording: $e');
        }
      }
    } else {
      print('Audio Pause Recording');
      try {
        // await _audioPlayer?.pause();
        // await HoonarCamera.pauseRecording();
        _pauseRecording();
      } catch (e) {
        print('Error pausing recording: $e');
      }
    }

    print('============ $currentSecond');
  }

  void initProgress(bool isDone) {
    timer?.cancel();
    timer = null;

    timer = Timer.periodic(const Duration(milliseconds: 10), (time) async {
      currentSecond += 0.01;
      currentPercentage = (100 * currentSecond) / totalSeconds;
      if (totalSeconds.toInt() <= currentSecond.toInt()) {
        timer?.cancel();
        timer = null;
        _isRecording = false;
        _stopRecording(isDone);
        // if (soundId != null && soundId!.isNotEmpty && Platform.isIOS) {
        //   _stopAndMergeVideoForIos(isAutoStop: true);
        // } else {
        //   await HoonarCamera.stopRecording;
        // }
      }
      if (mounted) {
        setState(() {});
      }
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

  Future<File> _downloadAudio(String url) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temp_audio.mp3';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  showConfirmationDialog(bool isDarkMode) {
    showDialog(
        context: context,
        builder: (mContext) {
          return ConfirmationDialog(
            aspectRatio: 2,
            title1: AppLocalizations.of(context)!.areYouSure,
            title2: AppLocalizations.of(context)!.doYouReallyWantToGoBack,
            positiveText: AppLocalizations.of(context)!.yes,
            isDarkMode: isDarkMode,
            onPositiveTap: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        });
  }

  Future<bool> _onWillPop(bool isDarkMode) async {
    showConfirmationDialog(isDarkMode);
    return false; // Allow back navigation
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      // return const Center(child: CircularProgressIndicator());
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.toAccessYourCameraAndMicrophone,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!
                    .ifAppearsThatCameraPermissionHasNotBeenGrantedEtc,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await openAppSettings().then((onValue) {
                    requestPermissions();
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.only(
                      top: 15, left: 60, right: 60, bottom: 5),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.openSettings,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    // final scale = 1 / (_controller.value.aspectRatio * size.aspectRatio);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return WillPopScope(
        onWillPop: () => _onWillPop(myLoading.isDark),
        child: Scaffold(
          body: Stack(
            children: [
              // Fullscreen camera preview
              Transform.scale(
                scale: 1 / (_controller.value.aspectRatio * size.aspectRatio),
                child: Center(
                  child: ColorFiltered(
                      colorFilter: selectedFilter['filter'],
                      child: CameraPreview(_controller)),
                ),
              ),

              if (!_isRecording)
                Positioned(
                  top: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isRecording)
                          InkWell(
                            onTap: () {
                              showConfirmationDialog(myLoading.isDark);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              stopAudio();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectSoundListScreen(
                                    duration: totalSeconds.toString(),
                                  ),
                                ),
                              ).then((result) async {
                                if (result != null) {
                                  setState(() {
                                    _selectedMusic = result;
                                  });
                                  if (_selectedMusic!.trimAudioPath == null) {
                                    _localMusic = await _downloadAudio(
                                        _selectedMusic!.sound!);
                                  } else {
                                    _localMusic =
                                        File(_selectedMusic!.trimAudioPath!);
                                  }
                                }
                              });
                            },
                            child: Container(
                              width: _selectedMusic == null
                                  ? null
                                  : MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _selectedMusic == null
                                  ? Center(
                                      child: Text(
                                        'Add Sound',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                _selectedMusic!.soundImage ??
                                                    '',
                                            width: 25,
                                            // Thumbnail width
                                            height: 25,
                                            // Thumbnail height
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(
                                                    strokeWidth: 2),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.music_note,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Space between thumbnail and text
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                _selectedMusic!.soundTitle ??
                                                    'Unknown Title',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                _selectedMusic!.singer ??
                                                    'Unknown Artist',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 10,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            )),
                      ],
                    ),
                  ),
                ),

              if (!_isRecording || !_isPaused)
                Positioned(
                  top: 55,
                  // left: 0,
                  right: 15,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isRecording = false;
                        cancelTimer();
                      });
                      if (_selectedMusic != null) {
                        if (_mergedVideoPath != null) {
                          _mergeAudioWithVideo();
                        } else {
                          /* if(_isPaused){
                            _mergeAudioWithVideo();
                          }else {*/
                          _stopRecording(true).then((onValue) {
                            _mergeAudioWithVideo();
                          });
                          // }
                        }
                      } else {
                        // if (_mergedVideoPath == null) {
                        _stopRecording(true).then((onValue) {
                          _mergeVideoSegments(true);
                        });

                        // }
                        // _goToPreviewScreen(File(_mergedVideoPath!));
                      }
                    },
                    child: Image.asset(
                      'assets/images/video_done.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              // Bottom Icons
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Gallery Icon
                          !_isRecording
                              ? InkWell(
                                  onTap: () {
                                    print('data');
                                    _selectVideoFromGallery();
                                  },
                                  child: Image.asset(
                                    'assets/images/reel_gallery.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                )
                              : const SizedBox(),
                          // Flash Icon
                          InkWell(
                            onTap: () {
                              _toggleFlash();
                            },
                            child: Image.asset(
                              !_isFlashOn
                                  ? 'assets/images/flash.png' //on
                                  : 'assets/images/flash_off.png', //off
                              height: 30,
                              width: 30,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 28.0),
                            child: InkWell(
                              onTap: () async {
                                _isRecording = !_isRecording;
                                // isRecordingStaring = true;
                                setState(() {});
                                startProgress();
                              },
                              child: Container(
                                height: 55,
                                width: 55,
                                decoration: const BoxDecoration(
                                    color: Colors.white60,
                                    shape: BoxShape.circle),
                                // padding: EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 55,
                                      width: 55,
                                      child: CircularProgressIndicator(
                                          backgroundColor: Colors.white60,
                                          strokeWidth: 20,
                                          value: currentPercentage / 100,
                                          color: Colors.orange),
                                    ),
                                    _isRecording
                                        ? Container(
                                            height: 55,
                                            width: 55,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.pause,
                                              color: Colors.blue,
                                              size: 40,
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: _isRecording
                                                  ? BoxShape.rectangle
                                                  : BoxShape.circle,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /* // Record Button
                            GestureDetector(
                              onTap: _isRecording ? _stopRecording : _startRecording,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isRecording ? Colors.red : Colors.white,
                                  border: Border.all(color: Colors.white, width: 4),
                                ),
                              ),
                            ),*/

                          !_isRecording
                              ? InkWell(
                                  onTap: () {
                                    _switchCamera();
                                  },
                                  child: Image.asset(
                                    'assets/images/change_camera.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                )
                              : const SizedBox(),
                          /*
                          !_isRecording
                              ? InkWell(
                                  onTap: () {
                                    _openFilterOptionsSheet(
                                        context, myLoading.isDark);
                                  },
                                  child: Image.asset(
                                    'assets/images/filter.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                )
                              :*/
                          const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (!_isRecording)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: timerTabs(
                                  onTap: () {
                                    isSelected15s = true;
                                    isSelected30s = false;
                                    isSelected60s = false;
                                    totalSeconds = 60;
                                    setState(() {});
                                  },
                                  isSelected: isSelected15s,
                                  title: '60 Sec',
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: timerTabs(
                                  onTap: () {
                                    isSelected30s = true;
                                    isSelected15s = false;
                                    isSelected60s = false;
                                    totalSeconds = 90;
                                    setState(() {});
                                  },
                                  isSelected: isSelected30s,
                                  title: '90 Sec',
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: timerTabs(
                                  onTap: () {
                                    isSelected30s = false;
                                    isSelected15s = false;
                                    isSelected60s = true;
                                    totalSeconds = 120;
                                    setState(() {});
                                  },
                                  isSelected: isSelected60s,
                                  title: '120 Sec',
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _openFilterOptionsSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const FiltersScreen();
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedFilter = value;
        });
      }
    });
  }

  Widget timerTabs({VoidCallback? onTap, bool? isSelected, String? title}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isSelected! ? Colors.black : Colors.black26,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Text(
            title!,
            style: const TextStyle(
              color: /*isSelected ? Colors.white : Colors.black*/ Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
