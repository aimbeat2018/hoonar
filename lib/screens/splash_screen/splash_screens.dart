import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/my_loading/my_loading.dart';
import '../../constants/session_manager.dart';
import '../../dummy_screen.dart';
import '../main_screen/main_screen.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  SessionManager sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.5).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });
    animation.forward();

    Future.delayed(const Duration(seconds: 6), () {
      animation.stop();
      initSession();
    });
  }

  initSession() async {
    await sessionManager.initPref().then((onValue) {
      String accessToken =
          sessionManager.getString(SessionManager.accessToken)!;
      if (sessionManager.getString(SessionManager.accessToken) == null ||
          accessToken == "") {
        Navigator.pushAndRemoveUntil(
          context,
          SlideRightRoute(page: LoginScreen()),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Colors.black
              // image: DecorationImage(
              //   image: AssetImage("assets/images/splash_back.jpg"),
              //   fit: BoxFit.cover,
              // ),
              ),
          child: Center(
            child: FadeTransition(
              opacity: _fadeInFadeOut,
              child: Image.asset(
                myLoading.isDark
                    ? 'assets/images/splash_logo.png'
                    : 'assets/images/splash_logo_black.png',
                height: 180,
                width: 180,
              ),
            ),
          ),
        ),
      );
    });
  }
}
