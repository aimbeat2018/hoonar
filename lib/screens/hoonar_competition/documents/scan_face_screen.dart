import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';

class ScanFaceScreen extends StatefulWidget {
  const ScanFaceScreen({super.key});

  @override
  State<ScanFaceScreen> createState() => _ScanFaceScreenState();
}

class _ScanFaceScreenState extends State<ScanFaceScreen> {
  late FaceCameraController controller;

  @override
  void initState() {
    controller = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartFaceCamera(
        controller: controller,
        showCameraLensControl: true,
        showCaptureControl: true,
        showControls: false,
        autoDisableCaptureControl: true,
        message: 'Center your face in the square',
      ),
    );
  }
}
