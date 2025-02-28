import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:gif/gif.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:hoonar/screens/reels/single_post_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/global_key.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../main_screen/main_screen.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens>
    with TickerProviderStateMixin {
  // late AnimationController animation;
  // late Animation<double> _fadeInFadeOut;
  SessionManager sessionManager = SessionManager();
  late GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        initSession();
      }
    });
  }

  void listenBranchLinks() {
    FlutterBranchSdk.listSession().listen((data) {
      log('Deep Link Data: $data');

      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        if (data.containsKey('post_id')) {
          try {
            String encodedMetadata = data['post_id'];
            log('Navigating to Post ID: $encodedMetadata');

            // if (mounted) {
            /*GlobalVariable.navKey.currentState?.pushAndRemoveUntil(
                context,
                SlideRightRoute(
                  page: SinglePostScreen(postId: encodedMetadata),
                ),
                    (route) => false,
              );
*/
            GlobalVariable.navKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => SinglePostScreen(postId: encodedMetadata),
              ),
              (route) => false,
            );
            // }
          } catch (e) {
            log('Error decoding metadata: $e');
          }
        } else {
          log('No metadata found, redirecting to MainScreen');

          GlobalVariable.navKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainScreen(
                fromIndex: 0,
              ),
            ),
            (route) => false,
          );
        }
      } else {
        log('No deep link detected, redirecting to MainScreen');

        GlobalVariable.navKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(
              fromIndex: 0,
            ),
          ),
          (route) => false,
        );
      }
    }, onError: (error) {
      log('Branch Deep Link Error: $error');

      GlobalVariable.navKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainScreen(
            fromIndex: 0,
          ),
        ),
        (route) => false,
      );
    });
  }

  Future<void> initSession() async {
    if (!mounted) return; // Prevent context access if the widget is unmounted

    await sessionManager.initPref().then((onValue) {
      String? accessToken =
          sessionManager.getString(SessionManager.accessToken);

      if (accessToken == null || accessToken.isEmpty) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            SlideRightRoute(page: const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        listenBranchLinks();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: /*myLoading.isDark ? */
            Colors.black /* : Colors.white*/,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Colors.black
              // image: DecorationImage(
              //   image: AssetImage("assets/images/splash_back.jpg"),
              //   fit: BoxFit.cover,
              // ),
              ),
          child: Center(
            /* child: Image.asset(
              myLoading.isDark
                  ? 'assets/light_mode_icons/splash_dark.gif'
                  : 'assets/light_mode_icons/splash_dark.gif',
              //  height: 180,
              // width: 180,
            ),*/
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Gif(
                image:
                    const AssetImage("assets/light_mode_icons/splash_dark.gif"),
                controller: _controller,
                // if duration and fps is null, original gif fps will be used.
                // fps: 15,
                // Reduce FPS to speed up loading time
                duration: const Duration(seconds: 3),
                // Adjust the duration as needed
                autostart: Autostart.no,
                // placeholder: (context) => const Text('Loading...'),
                onFetchCompleted: () {
                  _controller.reset();
                  _controller.forward();
                  // initSession();
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
