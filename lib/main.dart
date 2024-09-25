import 'package:flutter/material.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/dummy_screen.dart';
import 'package:hoonar/screens/auth_screen/signup_screen.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';
import 'package:hoonar/screens/splash_screen/splash_screens.dart';
import 'package:hoonar/screens/home/widgets/slider_page_view.dart';

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
      home: const MainScreen(),
      // home: DummyScreen(),
    );
  }
}
