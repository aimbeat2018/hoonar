import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/sizedbox_constants.dart';
import 'package:hoonar/screens/camera/camera_screen.dart';
import 'package:hoonar/screens/home/home_screen.dart';
import 'package:hoonar/screens/profile/profile_screen.dart';
import 'package:hoonar/screens/search/search_screen.dart';

import '../../constants/slide_right_route.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget? screen1, screen2, screen3, screen4;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    screen1 = const HomeScreen();
    screen2 = const SearchScreen();
    screen3 = const ProfileScreen(from: 'main');
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return screen1!;
    } else if (selectedIndex == 1) {
      return screen2!;
    } else {
      return screen3!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getBody(),
      floatingActionButton: SizedBox(
        height: 65, // Set custom height
        width: 65, // Set custom width
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: () {
            // Optional Floating Action Button logic
          },
          child: Stack(
            children: [
              Positioned.fill(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
                child: Image.asset(
                  'assets/images/star.png',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(30)),
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          height: 60,
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 7.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      onTapHandler(0);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/home.png",
                          height: selectedIndex == 0 ? 25 : 23,
                          width: selectedIndex == 0 ? 25 : 23,
                          color: Colors.black,
                        ),
                        sizedBoxH2,
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      openCameraScreen();
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/camera.png",
                          height: selectedIndex == 1 ? 25 : 23,
                          width: selectedIndex == 1 ? 25 : 23,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()), // Handle FAB spacing
                Expanded(
                  child: InkWell(
                    onTap: () {
                      onTapHandler(1);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/search.png",
                          height: selectedIndex == 2 ? 25 : 23,
                          width: selectedIndex == 2 ? 25 : 23,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      onTapHandler(2);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/profile.png",
                          height: selectedIndex == 3 ? 25 : 23,
                          width: selectedIndex == 3 ? 25 : 23,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void openCameraScreen() {
    Navigator.push(
      context,
      SlideRightRoute(page: CameraScreen()),
    );
  }
}
