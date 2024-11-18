import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/camera/select_sound_list_screen.dart';
import 'package:hoonar/screens/hoonar_competition/create_upload_video/uploadVideo/upload_video_screen.dart';

// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;
import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';
import '../../model/success_models/sound_list_model.dart';
import '../hoonar_competition/join_competition/select_category_screen.dart';

/*class VideoPreviewScreen extends StatefulWidget {
  final File videoFile;

  const VideoPreviewScreen({Key? key, required this.videoFile})
      : super(key: key);

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoController;
  VideoPlayerController? _mergedVideoController;
  File? _mergedVideoFile;
  ColorFilter? _currentFilter;
  bool _isMerging = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController(widget.videoFile);
  }

  void _initializeVideoController(File videoFile) {
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _mergedVideoController?.dispose();
    super.dispose();
  }

  void _applyFilter(ColorFilter? filter) {
    setState(() {
      _currentFilter = filter;
    });
  }

  Future<void> _pickAudioAndMerge() async {
    // final status = await Permission.storage.request();
    // if (!status.isGranted) {
    //   return;
    // }

    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      final audioFile = File(result.files.single.path!);
      _mergeAudioWithVideo(audioFile);
    }
  }

  Future<void> _mergeAudioWithVideo(File audioFile) async {
    setState(() {
      _isMerging = true;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final outputFilePath = '${tempDir.path}/merged_video.mp4';

      final mergeCommand =
          '-y -i "${widget.videoFile.path}" -i "${audioFile.path}" -map 0:v -map 1:a -c:v copy -shortest "$outputFilePath"';

      await FFmpegKit.execute(mergeCommand);

      final mergedFile = File(outputFilePath);
      _mergedVideoFile = mergedFile;

      // Initialize the merged video controller
      _mergedVideoController = VideoPlayerController.file(mergedFile)
        ..initialize().then((_) {
          setState(() {});
          _mergedVideoController!.play();
        });
    } catch (e) {
      print('Error during merge: $e');
    } finally {
      setState(() {
        _isMerging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _mergedVideoController != null &&
                  _mergedVideoController!.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    // Set the desired width
                    height: MediaQuery.of(context).size.width /
                        _mergedVideoController!.value.aspectRatio,
                    // Calculate height based on aspect ratio
                    child: VideoPlayer(_mergedVideoController!),
                  ),
                ) */ /*,Center(
                  child: VideoPlayer(_mergedVideoController!),
                )*/ /*
              : _videoController.value.isInitialized
                  ? Center(
                      child: ColorFiltered(
                          colorFilter: _currentFilter ??
                              const ColorFilter.mode(
                                  Colors.transparent, BlendMode.dst),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              // Set the desired width
                              height: MediaQuery.of(context).size.width /
                                  _videoController.value.aspectRatio,
                              // Calculate height based on aspect ratio
                              child: VideoPlayer(_videoController),
                            ),
                          )

                          */ /* AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),*/ /*
                          ),
                    )
                  : const Center(child: CircularProgressIndicator()),
          */ /* const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _applyFilter(
                    const ColorFilter.mode(Colors.grey, BlendMode.saturation)),
                child: const Text('Grayscale'),
              ),
              ElevatedButton(
                onPressed: () => _applyFilter(const ColorFilter.matrix([
                  0.393,
                  0.769,
                  0.189,
                  0,
                  0,
                  0.349,
                  0.686,
                  0.168,
                  0,
                  0,
                  0.272,
                  0.534,
                  0.131,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ])),
                child: const Text('Sepia'),
              ),
              ElevatedButton(
                onPressed: () => _applyFilter(
                    const ColorFilter.mode(Colors.white, BlendMode.difference)),
                child: const Text('Invert'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _applyFilter(const ColorFilter.matrix([
                  1.2,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1.2,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1.2,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ])),
                child: const Text('Bright'),
              ),
              ElevatedButton(
                onPressed: () => _applyFilter(const ColorFilter.matrix([
                  1.5,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1.5,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1.5,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ])),
                child: const Text('Saturation'),
              ),
              ElevatedButton(
                onPressed: () => _applyFilter(const ColorFilter.matrix([
                  1.2,
                  0.1,
                  0.1,
                  0,
                  0,
                  0.1,
                  1.1,
                  0.1,
                  0,
                  0,
                  0.1,
                  0.1,
                  1.0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ])),
                child: const Text('Warm'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickAudioAndMerge,
            child: _isMerging
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Merge Audio & Preview'),
          ),*/ /*
        ],
      ),
    );
  }
}*/

class VideoPreviewScreen extends StatefulWidget {
  final File videoFile;
  final SoundList? selectedMusic;

  const VideoPreviewScreen(
      {Key? key, required this.videoFile, this.selectedMusic})
      : super(key: key);

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _videoController;
  ColorFilter? _currentFilter;
  bool _isMerging = false, isThumbnailLoading = false;
  String? _thumbnailPath;
  SoundList? _selectedMusic;
  File? _localMusic;
  File? _videoFile;

  @override
  void initState() {
    super.initState();
    setState(() {
      _videoFile = widget.videoFile;
    });
    _initializeVideoController(_videoFile!);
    if (widget.selectedMusic != null) {
      _selectedMusic = widget.selectedMusic;
    }

  }

  void _initializeVideoController(File videoFile) {
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _applyFilter(ColorFilter? filter) {
    setState(() {
      _currentFilter = filter;
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

  Future<void> _pickAudioAndMerge() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      final audioFile = File(result.files.single.path!);
      _mergeAudioWithVideo(audioFile);
    }
  }

  Future<void> _mergeAudioWithVideo(File audioFile) async {
    setState(() {
      _isMerging = true;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final outputFilePath = '${tempDir.path}/merged_video.mp4';

      final mergeCommand =
          '-y -i "${widget.videoFile.path}" -i "${audioFile.path}" -map 0:v -map 1:a -c:v copy -shortest "$outputFilePath"';

      await FFmpegKit.execute(mergeCommand);

      _videoFile = File(outputFilePath);

      // Reinitialize the video controller with the merged file
      await _videoController.pause();
      _videoController.dispose();

      _initializeVideoController(_videoFile!);
    } catch (e) {
      print('Error during merge: $e');
    } finally {
      setState(() {
        _isMerging = false;
      });
    }
  }

  Future<void> _generateThumbnail() async {
    setState(() {
      isThumbnailLoading = true;
    });
    final tempDir = await getTemporaryDirectory();

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.videoFile.path,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
    );

    setState(() {
      _thumbnailPath = thumbnailPath;
      isThumbnailLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            _videoController.value.isInitialized
                ? Center(
                    child: ColorFiltered(
                      colorFilter: _currentFilter ??
                          const ColorFilter.mode(
                              Colors.transparent, BlendMode.dst),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context)
                              .size
                              .height /* /
                                _videoController.value.aspectRatio*/
                          ,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            Positioned(
              top: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectSoundListScreen(),
                        ),
                      ).then((result) async {
                        if (result != null) {
                          setState(() {
                            _selectedMusic = result;
                          });
                          _localMusic =
                              await _downloadAudio(_selectedMusic!.sound!);
                        }
                      });
                    },
                    child: Container(
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
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: _selectedMusic!.soundImage ?? '',
                                    width: 25,
                                    // Thumbnail width
                                    height: 25,
                                    // Thumbnail height
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                            strokeWidth: 2),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.music_note,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Space between thumbnail and text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              ],
                            ),
                    )),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/filter.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (!_isMerging) {
                        _generateThumbnail().then((onValue) {
                          Navigator.push(
                            context,
                            SlideRightRoute(
                                page: UploadVideoScreen(
                              videoThumbnail: _thumbnailPath!,
                              videoUrl: _videoFile!.path,
                              from: "normal",
                            )),
                          );
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Text(
                        AppLocalizations.of(context)!.next,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: myLoading.isDark ? Colors.black : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
