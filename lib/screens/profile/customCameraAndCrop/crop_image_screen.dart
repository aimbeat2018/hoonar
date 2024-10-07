import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image_picker/image_picker.dart';

class CropImageScreen extends StatefulWidget {
  final XFile? selectedImageFile;

  const CropImageScreen({super.key, this.selectedImageFile});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final _cropController = CropController();
  Uint8List? fileBytes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      covertFileToBytes();
      setState(() {});
    });
  }

  Future<Uint8List> getFileAsBytes(File file) async {
    return await file.readAsBytes();
  }

  covertFileToBytes() async {
    if (widget.selectedImageFile != null) {
      fileBytes = await getFileAsBytes(File(widget.selectedImageFile!.path));
      // Use fileBytes as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Crop(
        image: fileBytes!,
        controller: _cropController,
        fixCropRect: true,
        withCircleUi: true,
        initialSize: 0.8,
        cornerDotBuilder: (size, edgeAlignment) => const SizedBox.shrink(),
        interactive: true,
        // initialRectBuilder: (viewportRect, imageRect) {
        //   return Rect.fromLTRB(
        //     viewportRect.left + 24,
        //     viewportRect.top + 24,
        //     viewportRect.right - 24,
        //     viewportRect.bottom - 24,
        //   );
        // },
        onCropped: (image) {
          // do something with cropped image data
        });
  }
}
