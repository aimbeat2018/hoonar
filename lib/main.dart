// import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/providers/contest_provider.dart';
import 'package:hoonar/providers/home_provider.dart';
import 'package:hoonar/providers/setting_provider.dart';
import 'package:hoonar/providers/user_provider.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/crop_image_screen.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/custom_camera_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/edit_profile_screen.dart';
import 'package:hoonar/screens/splash_screen/splash_screens.dart';
import 'package:hoonar/services/service_locator.dart';
import 'package:hoonar/theme/style.dart';
import 'package:provider/provider.dart';

import 'constants/const_res.dart';
import 'constants/key_res.dart';
import 'constants/my_loading/my_loading.dart';
import 'constants/session_manager.dart';

SessionManager sessionManager = SessionManager();
String selectedLanguage = byDefaultLanguage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  // await FaceCamera.initialize(); //Add this
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyAJo-EkjSOgOgtwH4hkDmVlxrV6tQDrS9c',
    appId: '1:458800452771:android:a35d10f82ff6c25d279b16',
    messagingSenderId: '458800452771',
    projectId: 'hoonar-db73e',
    storageBucket: 'hoonar-db73e.appspot.com',
  ));

  await FlutterDownloader.initialize(ignoreSsl: true);
  await sessionManager.initPref();
  selectedLanguage =
      sessionManager.giveString(KeyRes.languageCode) ?? byDefaultLanguage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyLoading()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ContestProvider()),
        ChangeNotifierProvider(create: (_) => SettingProvider()),
      ],
      child: Consumer<MyLoading>(
        builder: (context, MyLoading myLoading, child) {
          SystemChrome.setSystemUIOverlayStyle(
            myLoading.isDark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
          );
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            supportedLocales: supportedLocales,
            locale: Locale(myLoading.languageCode),
            theme: myLoading.isDark
                ? ThemeUtils.darkTheme(context)
                : ThemeUtils.lightTheme(context),
            routes: {
              'CropImageScreen': (context) =>
                  CropImageScreen(selectedImageFile: null),
              'CameraScreen': (context) => CustomCameraScreen(),
              'EditProfileScreen': (context) => EditProfileScreen()
            },
            home: SplashScreens(),
            // home: MainScreen(),
          );
        },
      ),
    );
  }
}
