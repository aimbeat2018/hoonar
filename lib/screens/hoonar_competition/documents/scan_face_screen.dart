import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hoonar/constants/common_widgets.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/custom/snackbar_util.dart';
import 'package:hoonar/model/request_model/upload_kyc_document_request_model.dart';
import 'package:hoonar/providers/contest_provider.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../constants/internet_connectivity.dart';
import '../../../constants/key_res.dart';
import '../../../constants/no_internet_screen.dart';
import '../../../constants/slide_right_route.dart';
import '../../auth_screen/login_screen.dart';

class ScanFaceScreen extends StatefulWidget {
  const ScanFaceScreen({super.key});

  @override
  _ScanFaceScreenState createState() => _ScanFaceScreenState();
}

class _ScanFaceScreenState extends State<ScanFaceScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;
  late FaceDetector _faceDetector;
  bool isLoading = false;
  SessionManager sessionManager = SessionManager();
  bool _isCameraInitialized = false;
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _permissionNotGranted = false;

  @override
  void initState() {
    super.initState();
    CheckInternet.initConnectivity().then((value) => setState(() {
          _connectionStatus = value;
        }));

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      CheckInternet.updateConnectionStatus(result).then((value) => setState(() {
            _connectionStatus = value;
          }));
    });

    // _initializeCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPermission();
    });

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
      ),
    );
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
      if (mounted) {
        setState(() {
          _permissionNotGranted = true;
        });
      }

      _initializeCamera();
    } else {
      if (mounted) {
        setState(() {
          _permissionNotGranted = false;
        });
      }

      print('Not Granted');
    }
    setState(() {});
  }

  /*Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.last;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }
*/
  // Initialize camera asynchronously
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    // Find the back camera
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () =>
          cameras.first, // Fallback in case no back camera is available
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
    );

    // Initialize the camera and assign the future
    try {
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
        _initializeControllerFuture = Future.value();
      });
    } catch (e) {
      // Handle the error during camera initialization
      print("Error initializing camera: $e");
      setState(() {
        _isCameraInitialized = false;
      });
    }
  }

  void requestPermissions() async {
    // Request camera and microphone permissions
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      // Both permissions granted, initialize the camera
      print('Permissions Granted');
      setState(() {
        _permissionNotGranted = true;
      });
      _initializeCamera();
    } else {
      setState(() {
        _permissionNotGranted = false;
      });
    }
    setState(() {});
  }

  Future<void> _captureAndProcessFace() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      if (Platform.isAndroid) {
        final faceImagePath = await _detectAndCropFace(image.path);
        if (faceImagePath != null) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Face saved at $faceImagePath")),
          // );
          UploadKycDocumentRequestModel requestModel =
              UploadKycDocumentRequestModel(
                  document: File(faceImagePath), documentName: 'Face');
          uploadFace(context, requestModel);
        }
      } else {
        UploadKycDocumentRequestModel requestModel =
            UploadKycDocumentRequestModel(
                document: File(image.path), documentName: 'Face');
        uploadFace(context, requestModel);
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      _isProcessing = false;
    });
  }

  Future<String?> _detectAndCropFace(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) {
      SnackbarUtil.showSnackBar(
          context, AppLocalizations.of(context)!.faceNotRecognized);
      return null;
    }

    final face = faces.first;
    final boundingBox = face.boundingBox;

    final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());
    if (originalImage == null) return null;

    final faceImage = img.copyCrop(
      originalImage,
      x: boundingBox.left.toInt(),
      y: boundingBox.top.toInt(),
      width: boundingBox.width.toInt(),
      height: boundingBox.height.toInt(),
    );

    final directory = await getApplicationDocumentsDirectory();
    final faceImagePath = '${directory.path}/face_capture.png';
    File(faceImagePath).writeAsBytesSync(img.encodePng(faceImage));

    return faceImagePath;
  }

  Future<void> uploadFace(
      BuildContext context, UploadKycDocumentRequestModel requestModel) async {
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    try {
      sessionManager.initPref().then((onValue) async {
        await contestProvider.uploadKycDocuments(requestModel,
            sessionManager.getString(SessionManager.accessToken) ?? '');

        if (contestProvider.errorMessage != null) {
          SnackbarUtil.showSnackBar(
              context, contestProvider.errorMessage ?? '');
        } else if (contestProvider.uploadDocumentSuccessModel?.status ==
            '200') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.uploadDocumentSuccessModel?.message! ?? '');
          Navigator.pop(context);
        } else if (contestProvider.uploadDocumentSuccessModel?.status ==
            '401') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.uploadDocumentSuccessModel?.message! ?? '');
        } else if (contestProvider.uploadDocumentSuccessModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(context,
              contestProvider.uploadDocumentSuccessModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      });
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Widget permissionNotGranted() {
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
            const SizedBox(
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
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                /* await openAppSettings().then((onValue) {
                  requestPermissions();
                });*/
                bool opened = await openAppSettings();
                if (opened) {
                  Future.delayed(const Duration(seconds: 2), () {
                    requestPermissions();
                  });
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.only(
                    top: 15, left: 60, right: 60, bottom: 5),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
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

  Widget cameraNotInitialize() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget cameraInitializeAndPemissionGranted() {
    return _connectionStatus == KeyRes.connectivityCheck
        ? const NoInternetScreen()
        : Scaffold(
            backgroundColor: Colors.black,
            body: FutureBuilder<void>(
              future: _isCameraInitialized
                  ? _initializeControllerFuture
                  : Future.value(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SafeArea(
                    child: Stack(
                      children: [
                        if (isLoading) ...[
                          const Opacity(
                            opacity: 0.5,
                            child: ModalBarrier(
                                dismissible: false, color: Colors.black),
                          ),
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ],
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CameraPreview(_cameraController),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: _captureAndProcessFace,
                                  child: _isProcessing
                                      ? const CircularProgressIndicator(
                                          color: Colors.black,
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!.capture,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                )
                                /* InkWell(
                          onTap: _captureAndProcessFace,
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: _isProcessing || isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.capture,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),*/
                                ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: buildAppbar(context, true),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return !_permissionNotGranted
        ? permissionNotGranted()
        : !_isCameraInitialized
            ? cameraNotInitialize()
            : cameraInitializeAndPemissionGranted();
  }
}
