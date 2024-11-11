import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/custom/snackbar_util.dart';

class ScanFaceScreen extends StatefulWidget {
  const ScanFaceScreen({super.key});

  @override
  State<ScanFaceScreen> createState() => _ScanFaceScreenState();
}

class _ScanFaceScreenState extends State<ScanFaceScreen> {
  late FaceCameraController controller;
  File? _capturedImage;

  @override
  void initState() {
    controller = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        setState(() => _capturedImage = image);
      },
      onFaceDetected: (Face? face) {
        //Do something
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartFaceCamera(
          controller: controller,
          messageBuilder: (context, face) {
            if (face == null) {
              return Text('Place your face in the camera');
            }
            if (!face.wellPositioned) {
              return Text('Center your face in the square');
            }
            return const SizedBox.shrink();
          }),
    );
  }
}
