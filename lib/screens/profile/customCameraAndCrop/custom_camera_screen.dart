import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/crop_image_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';

class CustomCameraScreen extends StatefulWidget {
  const CustomCameraScreen({super.key});

  @override
  State<CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;
  int _selectedCameraIndex = 0; // Index to switch between front and rear camera
  XFile? _capturedImage; // Store the captured image here
  FlashMode _flashMode = FlashMode.off; // Default flash mode

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCamera(_selectedCameraIndex);
    });
  }

  // Initialize camera with the selected index
  initCamera(int cameraIndex) async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[cameraIndex], ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize();
    setState(() {});
  }

  // Function to switch between front and rear cameras
  void switchCamera() {
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    initCamera(_selectedCameraIndex);
  }

  // Capture the image and store it in an XFile
  Future<void> captureImage() async {
    try {
      await _initializeControllerFuture; // Ensure the controller is initialized
      final image = await controller.takePicture(); // Capture the image
      _capturedImage = image;
      Navigator.push(
        context,
        SlideRightRoute(page: CropImageScreen(selectedImageFile: _capturedImage,)),
      );
      print("Captured image: ${_capturedImage?.path}");
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  // Toggle the flash mode between off, auto, and on
  void toggleFlash() {
    FlashMode nextMode;
    if (_flashMode == FlashMode.off) {
      nextMode = FlashMode.auto;
    } else if (_flashMode == FlashMode.auto) {
      nextMode = FlashMode.always;
    } else {
      nextMode = FlashMode.off;
    }

    setState(() {
      _flashMode = nextMode;
    });

    // Set the selected flash mode
    controller.setFlashMode(_flashMode);
  }

  // Get the appropriate flash icon based on the flash mode
  IconData getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.off:
      default:
        return Icons.flash_off;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Camera is initialized, show camera preview
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        // fit: StackFit.expand,
                        children: [
                          CameraPreview(controller),
                          Positioned(
                            bottom: 10,
                            left: 15,
                            right: 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Capture button
                                InkWell(
                                    onTap: switchCamera,
                                    child: Image.asset(
                                      'assets/images/change_camera.png',
                                      height: 35,
                                      width: 35,
                                    )),

                                // Flash button
                                IconButton(
                                  icon: Icon(getFlashIcon(),
                                      size: 35, color: Colors.white),
                                  onPressed: toggleFlash,
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            bottom: 10,
                            right: 0,
                            left: 0,
                            child: IconButton(
                              icon: Icon(Icons.camera,
                                  size: 60,
                                  color: /*myLoading.isDark
                                  ? Colors.white
                                  : Colors.black*/Colors.white),
                              onPressed: captureImage,
                            ),
                          ),
                        ],
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: IconButton(
                          icon: Icon(Icons.camera,
                              size: 60,
                              color: *//*myLoading.isDark
                                  ? Colors.white
                                  : Colors.black*//*Colors.white),
                          onPressed: captureImage,
                        ),
                      ),*/
                    ],
                  ),
                );
              } else {
                // Camera is still initializing, show a loading spinner
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );
    });
  }
}
