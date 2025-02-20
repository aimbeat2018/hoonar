import 'package:get_it/get_it.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/providers/contest_provider.dart';
import 'package:hoonar/providers/home_provider.dart';
import 'package:hoonar/providers/setting_provider.dart';
import 'package:hoonar/providers/user_provider.dart';
import 'package:hoonar/services/contest_service.dart';
import 'package:hoonar/services/home_page_service.dart';
import 'package:hoonar/services/setting_service.dart';

import 'user_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register services
  getIt.registerLazySingleton<UserService>(() => UserService());
  getIt.registerLazySingleton<HomePageService>(() => HomePageService());
  getIt.registerLazySingleton<ContestService>(() => ContestService());
  getIt.registerLazySingleton<SettingService>(() => SettingService());

  // Register providers
  getIt.registerFactory<AuthProvider>(() => AuthProvider());
  getIt.registerFactory<UserProvider>(() => UserProvider());
  getIt.registerFactory<HomeProvider>(() => HomeProvider());
  getIt.registerFactory<ContestProvider>(() => ContestProvider());
  getIt.registerFactory<SettingProvider>(() => SettingProvider());
}
