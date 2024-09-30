import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hoonar/screens/main_screen/main_screen.dart';
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
    return ChangeNotifierProvider<MyLoading>(
      create: (context) => MyLoading(),
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
            home: MainScreen(),
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
