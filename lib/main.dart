// import 'package:face_camera/face_camera.dart';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'constants/const_res.dart';
import 'constants/global_key.dart';
import 'constants/key_res.dart';
import 'constants/my_loading/my_loading.dart';
import 'constants/session_manager.dart';
import 'notification/NotificationHelper.dart';

SessionManager sessionManager = SessionManager();
String selectedLanguage = byDefaultLanguage;

final FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
    (Platform.isAndroid || Platform.isIOS)
        ? FlutterLocalNotificationsPlugin()
        : null;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*---- initialize branch io ------*/
  FlutterBranchSdk.init();
  // await FlutterBranchSdk.init(enableLogging: false, branchAttributionLevel: BranchAttributionLevel.FULL);
  // FlutterBranchSdk.validateSDKIntegration();

  setupServiceLocator();
  await Upgrader.clearSavedSettings();
  // await initializeFirebase();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAJo-EkjSOgOgtwH4hkDmVlxrV6tQDrS9c',
        appId: '1:458800452771:android:a35d10f82ff6c25d279b16',
        messagingSenderId: '458800452771',
        projectId: 'hoonar-db73e',
        storageBucket: 'hoonar-db73e.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp(
        // name: 'hoonarstar',
        name: 'default',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAJo-EkjSOgOgtwH4hkDmVlxrV6tQDrS9c',
          appId: '1:458800452771:ios:2f3016d02bbef45d279b16',
          messagingSenderId: '458800452771',
          projectId: 'hoonar-db73e',
          storageBucket: 'hoonar-db73e.appspot.com',
          iosBundleId: 'com.hoonar.hoonarstar',
        ));
  }
  await sessionManager.initPref();
  selectedLanguage =
      sessionManager.giveString(KeyRes.languageCode) ?? byDefaultLanguage;

  try {
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (remoteMessage != null) {}

    await NotificationHelper.initialize(flutterLocalNotificationsPlugin!);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {}

  runApp(const MyApp());
}

/*void requestNotificationPermission() async {
  PermissionStatus status =
      await NotificationPermissions.requestNotificationPermissions(
    iosSettings: const NotificationSettingsIos(
      sound: true,
      badge: true,
      alert: true,
    ),
  );
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationHelper.setContext(context);
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
            navigatorKey: GlobalVariable.navKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
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
                  const CropImageScreen(selectedImageFile: null),
              'CameraScreen': (context) => const CustomCameraScreen(),
              'EditProfileScreen': (context) => const EditProfileScreen()
            },
            home: const SplashScreens(),
            // home: ContestJoinSuccessScreen(),
          );
        },
      ),
    );
  }
}
