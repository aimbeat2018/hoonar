import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/success_models/city_list_model.dart';
import 'package:hoonar/services/user_service.dart';

import '../model/success_models/state_list_model.dart';

class AuthProvider extends ChangeNotifier {
  final UserService _userService = GetIt.I<UserService>();

  bool? _isLoading;
  String? _errorMessage;
  List<StateListData>? _stateList;
  List<CityListData>? _cityList;

  List<StateListData>? get stateList => _stateList;

  List<CityListData>? get cityList => _cityList;

  bool? get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> getStateList() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      StateListModel stateModel = await _userService.getStateList();
      _stateList = stateModel.data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // New method to filter states based on search query
  Future<List<StateListData>> getFilteredStates(String query) async {
    if (_stateList == null) {
      await getStateList(); // Fetch state list if not already fetched
    }
    return _stateList!
        .where((state) =>
            state.name != null &&
            state.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> getCityList(String stateId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      CityListModel cityListModel = await _userService.getCityList(stateId);
      _cityList = cityListModel.data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<CityListData>> getFilteredCities(
      String query, String stateId) async {
    if (_cityList == null) {
      await getCityList(stateId); // Fetch state list if not already fetched
    }
    return _cityList!
        .where((city) =>
            city.name != null &&
            city.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
