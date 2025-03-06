import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:gif/gif.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:hoonar/screens/reels/single_post_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/global_key.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../main_screen/main_screen.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens>
    with TickerProviderStateMixin {
  SessionManager sessionManager = SessionManager();
  late GifController _controller;
  StreamSubscription<Map>? _branchSubscription;
  bool _sessionInitialized = false; // Prevent multiple init calls
  bool _isNavigating = false; // Prevent multiple navigation triggers

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_sessionInitialized) {
        _sessionInitialized = true;
        initSession();
      }
    });
  }



  void navigateToScreen(Widget screen) {
    if (!mounted) return;
    _isNavigating = true;
    GlobalVariable.navKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
          (route) => false,
    );
  }

  Future<void> initSession() async {
    if (!mounted) return; // Prevent execution if unmounted

    log('Initializing session...');

    await sessionManager.initPref().then((_) {
      String? accessToken =
      sessionManager.getString(SessionManager.accessToken);

      if (accessToken == null || accessToken.isEmpty) {
        if (mounted) {
          log('No access token found, navigating to LoginScreen');
          navigateToScreen(const LoginScreen());
        }
      } else {
        log('Access token found, listening for Branch deep links');
        // listenBranchLinks();

        navigateToScreen(const MainScreen());
      }
    });
  }

  @override
  void dispose() {
    // _branchSubscription?.cancel(); // Cancel stream to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Colors.black),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Gif(
                image:
                const AssetImage("assets/light_mode_icons/splash_dark.gif"),
                controller: _controller,
                duration: const Duration(seconds: 3),
                autostart: Autostart.no,
                onFetchCompleted: () {
                  log("GIF Loaded, starting animation");
                  if (mounted) _controller.forward();
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
