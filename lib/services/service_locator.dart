import 'package:get_it/get_it.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'user_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register services
  getIt.registerLazySingleton<UserService>(() => UserService());

  // Register providers
  getIt.registerFactory<AuthProvider>(() => AuthProvider());
}
