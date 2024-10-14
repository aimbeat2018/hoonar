import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hoonar/dummy_screen.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/crop_image_screen.dart';
import 'package:hoonar/screens/profile/customCameraAndCrop/custom_camera_screen.dart';
import 'package:hoonar/screens/profile/menuOptionsScreens/edit_profile_screen.dart';
import 'package:hoonar/screens/splash_screen/splash_screens.dart';
import 'package:hoonar/services/service_locator.dart';
import 'package:hoonar/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants/const_res.dart';
import 'constants/key_res.dart';
import 'constants/my_loading/my_loading.dart';
import 'constants/session_manager.dart';

SessionManager sessionManager = SessionManager();
String selectedLanguage = byDefaultLanguage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator(); // Setup get_it
  // MobileAds.instance.initialize();
  // await Firebase.initializeApp();
  await FlutterDownloader.initialize(ignoreSsl: true);
  await sessionManager.initPref();
  // await FlutterBranchSdk.init(useTestKey: true, enableLogging: true, disableTracking: false);
  selectedLanguage =
      sessionManager.giveString(KeyRes.languageCode) ?? byDefaultLanguage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyLoading()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
            // builder: (context, child) {
            //   return ScrollConfiguration(
            //     behavior: MyBehavior(),
            //     child: child!,
            //   );
            // },
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate, // Your localization delegate
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
            // home: DummyScreen(),
          );
        },
      ),
    );

    /*  return MaterialApp(
      title: 'Hoonar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: bkgColor),
      home: const MainScreen(),
      // home: DummyScreen(),
    );*/
  }
}
