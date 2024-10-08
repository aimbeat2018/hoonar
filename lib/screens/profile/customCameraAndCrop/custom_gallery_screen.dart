import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../constants/my_loading/my_loading.dart';

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
  CropController _cropController = CropController();
  Uint8List? fileBytes;
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
          title: _buildFolderDropdown(),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (fileBytes != null)
                    Expanded(flex: 4, child: _buildCropImage(context)),
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: _recentImages.isNotEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: _buildImageGrid())
                          : SizedBox.shrink(),
                    ),
                  )
                ],
              ),
      );
    });
  }

  Widget _buildFolderDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<AssetPathEntity>(
        value: _selectedFolder,
        items: _folders.map((folder) {
          return DropdownMenuItem<AssetPathEntity>(
            value: folder,
            child: Text(folder.name), // Display folder name in the dropdown
          );
        }).toList(),
        onChanged: (AssetPathEntity? newFolder) {
          setState(() {
            _selectedFolder = newFolder;
            if (newFolder != null) {
              _fetchImagesFromFolder(
                  newFolder); // Fetch images from the selected folder
            }
          });
        },
      ),
    );
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
            if (index == 0) {
              fileBytes = bytes;
            }
            if (bytes == null) {
              return Container(color: Colors.grey[300]);
            }
            return InkWell(
                onTap: () {
                  setState(() {
                    fileBytes = bytes;
                  });
                },
                child: Image.memory(bytes, fit: BoxFit.cover));
          },
        );
      },
    );
  }

  // Future<Uint8List> getFileAsBytes(File file) async {
  //   return await file.readAsBytes();
  // }
  //
  // covertFileToBytes() async {
  //   if (selectedImageFile != null) {
  //     fileBytes = await getFileAsBytes(File(selectedImageFile!.path));
  //     setState(() {});
  //   }
  // }

  Widget _buildCropImage(BuildContext context) {
    // Get the screen size dynamically using MediaQuery
    final screenSize = MediaQuery.of(context).size;

    return Crop(
      image: fileBytes!,
      controller: _cropController,
      aspectRatio: 1, // Aspect ratio according to container size
      fixCropRect: true,
      initialSize: 1,
      withCircleUi: false,
      cornerDotBuilder: (size, edgeAlignment)
      => const SizedBox.shrink(),
      interactive: true,
      onCropped: (image) async {
        // Save or use the cropped image here
      },
    );
  }
}
