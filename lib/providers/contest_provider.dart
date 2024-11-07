import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/success_models/level_list_model.dart';
import 'package:hoonar/services/contest_service.dart';

class ContestProvider extends ChangeNotifier {
  final ContestService _contestService = GetIt.I<ContestService>();

  bool _isLevelLoading = false;
  String? _errorMessage;

  LevelListModel? _levelListModel;

  bool get isLevelLoading => _isLevelLoading;

  String? get errorMessage => _errorMessage;

  LevelListModel? get levelListModel => _levelListModel;

  Future<void> getLevelList() async {
    _isLevelLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      LevelListModel levelListModel = await _contestService.getLevelList();
      _levelListModel = levelListModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLevelLoading = false;
      notifyListeners();
    }
  }
}
