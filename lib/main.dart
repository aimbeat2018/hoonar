import 'package:flutter/material.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/screens/splash_screen/splash_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hoonar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: bkgColor),
      home: const SplashScreens(),
    );
  }
}
