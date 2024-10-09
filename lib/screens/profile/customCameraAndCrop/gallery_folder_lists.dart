import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/my_loading/my_loading.dart';

class GalleryFolderLists extends StatefulWidget {
  final List<AssetPathEntity> folders;

  const GalleryFolderLists({super.key, required this.folders});

  @override
  State<GalleryFolderLists> createState() => _GalleryFolderListsState();
}

class _GalleryFolderListsState extends State<GalleryFolderLists> {
  List<FolderData> _folderDataList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFolderData();
  }

  Future<void> _loadFolderData() async {
    List<FolderData> folderDataList = [];
    for (var folder in widget.folders) {
      int count = await folder.assetCountAsync;
      List<AssetEntity> assets =
          await folder.getAssetListRange(start: 0, end: 1);
      final firstAsset = assets.isNotEmpty ? assets.first.thumbnailData : null;

      folderDataList.add(FolderData(
          name: folder.name, count: count, thumbnail: await firstAsset));
    }

    setState(() {
      _folderDataList = folderDataList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.selectFolder,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 15.0,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _folderDataList.length,
                          itemBuilder: (context, index) {
                            return _buildAlbumCard(_folderDataList[index],
                                myLoading.isDark, index);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAlbumCard(FolderData folderData, bool isDarkMode, int index) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, widget.folders[index]);
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: folderData.thumbnail != null
                    ? DecorationImage(
                        image: MemoryImage(folderData.thumbnail!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: folderData.thumbnail == null
                  ? const Center(
                      child: Text(
                        "No Images",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            folderData.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            folderData.count.toString(), // Display the count of assets
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class to hold folder data
class FolderData {
  final String name;
  final int count;
  final Uint8List? thumbnail;

  FolderData({required this.name, required this.count, this.thumbnail});
}
