import 'package:get_it/get_it.dart';
import 'user_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<UserService>(UserService());
}
