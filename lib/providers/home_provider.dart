import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/services/home_page_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomePageService _homePageService = GetIt.I<HomePageService>();


}
