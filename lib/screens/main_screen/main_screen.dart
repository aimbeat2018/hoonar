import 'package:flutter/material.dart';
import 'package:hoonar/constants/sizedbox_constants.dart';
import 'package:hoonar/screens/camera/camera_screen.dart';
import 'package:hoonar/screens/home/home_screen.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/select_category_screen.dart';
import 'package:hoonar/screens/profile/profile_screen.dart';
import 'package:hoonar/screens/search/search_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';

class MainScreen extends StatefulWidget {
  final int? fromIndex;

  const MainScreen({super.key, this.fromIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget? screen1, screen2, screen3, screen4;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedIndex = widget.fromIndex!;
        getBody();
      });
    });

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

  // Handle back button press to reset to index 0
  Future<bool> _onWillPop() async {
    if (selectedIndex != 0) {
      setState(() {
        selectedIndex = 0;
      });
      return false; // Prevent default back button action
    }
    return true; // Allow back button to work as expected
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: myLoading.isDark ? Colors.transparent : Colors.white,
          body: getBody(),
          floatingActionButton: SizedBox(
            height: 65, // Set custom height
            width: 65, // Set custom width
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  SlideRightRoute(page: SelectCategoryScreen()),
                );
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(30)),
            child: BottomAppBar(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              height: 60,
              color: myLoading.isDark ? Colors.white : Colors.black,
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
                          if (selectedIndex == 0) {
                            setState(() {
                              selectedIndex = 0;
                            });
                          } else {
                            onTapHandler(0);
                          }
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/home.png",
                              height: selectedIndex == 0 ? 25 : 23,
                              width: selectedIndex == 0 ? 25 : 23,
                              color: myLoading.isDark
                                  ? Colors.black
                                  : Colors.white,
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
                              color: myLoading.isDark
                                  ? Colors.black
                                  : Colors.white,
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
                              color: myLoading.isDark
                                  ? Colors.black
                                  : Colors.white,
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
                              color: myLoading.isDark
                                  ? Colors.black
                                  : Colors.white,
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
        ),
      );
    });
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void openCameraScreen() {
    Navigator.push(
      context,
      SlideRightRoute(
          page: CameraScreen(
        soundId: "1",
        soundTitle: "hgh",
        soundUrl: "ghs",
      )),
    );
  }
}
