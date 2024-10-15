import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/check_user_request_model.dart';
import 'package:hoonar/model/request_model/signup_request_model.dart';
import 'package:hoonar/model/success_models/check_user_success_model.dart';
import 'package:hoonar/model/success_models/city_list_model.dart';
import 'package:hoonar/model/success_models/signup_success_model.dart';
import 'package:hoonar/services/user_service.dart';
import '../model/success_models/state_list_model.dart';

class AuthProvider extends ChangeNotifier {
  final UserService _userService = GetIt.I<UserService>();

  bool _isStateLoading = false;
  bool _isCityLoading = false;
  bool _isSignUpLoading = false;
  bool _isCheckUserLoading = false;
  String? _errorMessage;
  List<StateListData>? _stateList;
  List<CityListData>? _cityList;
  List<StateListData>? _filteredStateList;
  List<CityListData>? _filteredCityList;
  SignupSuccessModel? _signupSuccessModel;
  CheckUserSuccessModel? _checkUserSuccessModel;

  List<StateListData>? get stateList => _stateList;

  List<CityListData>? get cityList => _cityList;

  List<CityListData>? get filteredCityList => _filteredCityList;

  List<StateListData>? get filteredStateList => _filteredStateList;

  SignupSuccessModel? get signupSuccessModel => _signupSuccessModel;

  CheckUserSuccessModel? get checkUserSuccessModel => _checkUserSuccessModel;

  bool get isStateLoading => _isStateLoading;

  bool get isCityLoading => _isCityLoading;

  bool get isSignUpLoading => _isSignUpLoading;

  bool get isCheckUserLoading => _isCheckUserLoading;

  String? get errorMessage => _errorMessage;

  Future<void> getStateList() async {
    _isStateLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      StateListModel stateModel = await _userService.getStateList();
      _stateList = stateModel.data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isStateLoading = false;
      notifyListeners();
    }
  }

  // New method to filter states based on search query
  Future<void> getFilteredStates(String query) async {
    if (_stateList == null) {
      await getStateList(); // Fetch state list if not already fetched
    }

    if (query.isEmpty) {
      _filteredStateList = _stateList;
    } else {
      // Filter cities based on the search value
      _filteredStateList = _stateList!
          .where((state) =>
              state.name != null &&
              state.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> getCityList(String stateId) async {
    _isCityLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      CityListModel cityListModel = await _userService.getCityList(stateId);
      _cityList = cityListModel.data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isCityLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFilteredCities(String query, String stateId) async {
    if (_cityList == null) {
      await getCityList(stateId);
    }

    if (query.isEmpty) {
      _filteredCityList = _cityList;
    } else {
      _filteredCityList = _cityList!
          .where((state) =>
              state.name != null &&
              state.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> checkUser(CheckUserRequestModel requestModel) async {
    _isCheckUserLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      CheckUserSuccessModel successModel = await _userService
          .checkUserEmailAndMobile(requestModel: requestModel);
      _checkUserSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSignUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpUser(SignupRequestModel requestModel) async {
    _isSignUpLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SignupSuccessModel successModel =
          await _userService.signUpUser(requestModel: requestModel);
      _signupSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSignUpLoading = false;
      notifyListeners();
    }
  }
}
