import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/crop_image_screen.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/gallery_folder_lists.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../constants/my_loading/my_loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/slide_right_route.dart';

class CustomGalleryScreen extends StatefulWidget {
  const CustomGalleryScreen({super.key});

  @override
  State<CustomGalleryScreen> createState() => _CustomGalleryScreenState();
}

class _CustomGalleryScreenState extends State<CustomGalleryScreen> {
  List<AssetPathEntity> _folders = [];
  AssetPathEntity? _selectedFolder;
  List<AssetEntity> _recentImages = [];
  bool _loading = true;
  final CropController _cropController = CropController();
  Uint8List? fileBytes, croppedBytes;
  XFile? croppedXFile;
  XFile? selectedImageFile;

  @override
  void initState() {
    super.initState();
    _fetchFoldersAndImages();
  }

  Future<void> _fetchFoldersAndImages() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result != PermissionState.authorized) {
      setState(() {
        _loading = false;
      });
      return;
    }

    // Fetch image folders from the user's gallery
    final List<AssetPathEntity> folders = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (folders.isNotEmpty) {
      // Set default selected folder to "All Photos"
      setState(() {
        _folders = folders;
        _selectedFolder = folders[0];
      });
      _fetchImagesFromFolder(folders[0]);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _fetchImagesFromFolder(AssetPathEntity folder) async {
    final List<AssetEntity> images = await folder.getAssetListRange(
      start: 0,
      end: await folder.assetCountAsync, // Fetch all images
    );
    if (images.isNotEmpty) {
      Uint8List? file = await images[0].thumbnailData;
      setState(() {
        _recentImages = images;
        fileBytes = file;
      });
    }
  }

  void navigateToCrop(Uint8List croppedImage, BuildContext context) {
    Navigator.push(
      context,
      SlideRightRoute(
        page: CropImageScreen(
          fileBytes: croppedImage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: myLoading.isDark ? Colors.white : Colors.black,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: InkWell(
            onTap: () {
              _openFoldersBottomSheet(context, myLoading.isDark);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    _selectedFolder == null ? '' : _selectedFolder!.name ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: myLoading.isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: myLoading.isDark ? Colors.white : Colors.black,
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
              child: InkWell(
                onTap: () {
                  _cropController.crop();
                },
                child: Text(
                  AppLocalizations.of(context)!.next,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: myLoading.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (fileBytes != null)
                    Expanded(flex: 4, child: _buildCropImage(context)),
                  // _buildCropImage(context),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: _recentImages.isNotEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: _buildImageGrid())
                          : const SizedBox.shrink(),
                    ),
                  )
                ],
              ),
      );
    });
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 images per row
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _recentImages.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Uint8List?>(
          future: _recentImages[index].thumbnailData, // Get thumbnail
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            if (bytes == null) {
              return Container(color: Colors.grey[300]);
            }
            return InkWell(
              onTap: () {
                setState(() {
                  fileBytes = bytes;
                });
              },
              child: Image.memory(bytes, fit: BoxFit.cover),
            );
          },
        );
      },
    );
  }

  Widget _buildCropImage(BuildContext context) {
    // Ensure fileBytes is non-null before trying to build the Crop widget
    if (fileBytes == null) {
      return const Center(child: Text("No image selected for cropping"));
    }

    return Crop(
      image: fileBytes!,
      controller: _cropController,
      // aspectRatio: 1.0,
      withCircleUi: false,
      interactive: true,
      cornerDotBuilder: (size, edgeAlignment) => const SizedBox.shrink(),
      baseColor: Colors.black,
      maskColor: Colors.black.withAlpha(100),
      onCropped: (image) async {
        // Save or use the cropped image here
        setState(() {
          croppedBytes = image;
        });

        navigateToCrop(croppedBytes!, context);
      },
    );
  }

  void _openFoldersBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(top: 55),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: GalleryFolderLists(
              folders: _folders ?? [],
            ),
          ),
        );
      },
    ).then((data) async {
      if (data != null) {
        // Update selected folder
        _selectedFolder = data;

        // Get the asset count and assets asynchronously
        int count = await _selectedFolder!.assetCountAsync;
        List<AssetEntity> assets =
            await _selectedFolder!.getAssetListRange(start: 0, end: count);

        // Update the recent images state
        Uint8List? file = await assets[0].thumbnailData;
        setState(() {
          _recentImages = assets;
          fileBytes = file;
        });
      }
    });
  }
}
