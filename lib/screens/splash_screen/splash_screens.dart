import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/screens/auth_screen/login_screen.dart';

class SplashScreens extends StatefulWidget  {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> with TickerProviderStateMixin{
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;

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
    
    Future.delayed(const Duration(seconds: 6),(){
      animation.stop();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.black
          // image: DecorationImage(
          //   image: AssetImage("assets/images/splash_back.jpg"),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeInFadeOut,
            child: Image.asset(
              'assets/images/splash_logo.png',
              height: 180,
              width: 180,
            ),
          ),
        ),
      ),

    );
  }
}
