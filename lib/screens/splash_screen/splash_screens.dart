import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:provider/provider.dart';

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
  // late AnimationController animation;
  // late Animation<double> _fadeInFadeOut;
  SessionManager sessionManager = SessionManager();
  late GifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);

    // animation = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 3),
    // );
    // _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.5).animate(animation);
    //
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animation.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     animation.forward();
    //   }
    // });
    // animation.forward();

    Future.delayed(const Duration(seconds: 5), () {
      // _controller.reset();
      initSession();
    });
  }

  initSession() async {
    _controller.dispose();
    await sessionManager.initPref().then((onValue) {
      String accessToken =
          sessionManager.getString(SessionManager.accessToken)!;
      if (sessionManager.getString(SessionManager.accessToken) == null ||
          accessToken == "") {
        Navigator.pushAndRemoveUntil(
          context,
          SlideRightRoute(page: const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            SlideRightRoute(page: const MainScreen(fromIndex: 0)),
            (route) => false);
      }
    });
    /*Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: PictureSlideShow()), (route) => false);
      }
    });*/
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _controller.dispose();
  // }

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
                image: const AssetImage("assets/light_mode_icons/splash_dark.gif"),
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
