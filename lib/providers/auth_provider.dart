import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/check_user_request_model.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/request_model/sign_in_request_model.dart';
import 'package:hoonar/model/request_model/signup_request_model.dart';
import 'package:hoonar/model/request_model/update_profile_image_request_model.dart';
import 'package:hoonar/model/request_model/update_profile_request_model.dart';
import 'package:hoonar/model/success_models/check_user_success_model.dart';
import 'package:hoonar/model/success_models/city_list_model.dart';
import 'package:hoonar/model/success_models/logout_success_model.dart';
import 'package:hoonar/model/success_models/profile_success_model.dart';
import 'package:hoonar/model/success_models/signup_success_model.dart';
import 'package:hoonar/services/user_service.dart';
import '../model/success_models/follow_unfollow_success_model.dart';
import '../model/success_models/send_otp_success_model.dart';
import '../model/success_models/state_list_model.dart';

class AuthProvider extends ChangeNotifier {
  final UserService _userService = GetIt.I<UserService>();

  ValueNotifier<ProfileSuccessModel?> profileNotifier = ValueNotifier(null);

  bool _isStateLoading = false;
  bool _isCityLoading = false;
  bool _isSignUpLoading = false;
  bool _isCheckUserLoading = false;
  bool _isSendOtpLoading = false;
  bool _isProfileLoading = false;
  bool _isLogoutLoading = false;
  bool _isUpdateAvatarLoading = false;
  bool _isUpdateProfileImageLoading = false;
  bool _isChangePasswordLoading = false;
  bool _isDeleteAccountLoading = false;
  String? _errorMessage;
  List<StateListData>? _stateList;
  List<CityListData>? _cityList;
  List<StateListData>? _filteredStateList;
  List<CityListData>? _filteredCityList;
  SignupSuccessModel? _signupSuccessModel;
  CheckUserSuccessModel? _checkUserSuccessModel;
  SendOtpSuccessModel? _sendOtpSuccessModel;
  ProfileSuccessModel? _profileSuccessModel;
  LogoutSuccessModel? _logoutSuccessModel;
  FollowUnfollowSuccessModel? _updateAvatarModel;
  FollowUnfollowSuccessModel? _changePasswordModel;
  FollowUnfollowSuccessModel? _updateProfileImageModel;
  FollowUnfollowSuccessModel? _deleteAccountModel;
  FollowUnfollowSuccessModel? _unableDisableNotification;

  List<StateListData>? get stateList => _stateList;

  List<CityListData>? get cityList => _cityList;

  List<CityListData>? get filteredCityList => _filteredCityList;

  List<StateListData>? get filteredStateList => _filteredStateList;

  SignupSuccessModel? get signupSuccessModel => _signupSuccessModel;

  CheckUserSuccessModel? get checkUserSuccessModel => _checkUserSuccessModel;

  SendOtpSuccessModel? get sendOtpSuccessModel => _sendOtpSuccessModel;

  ProfileSuccessModel? get profileSuccessModel => _profileSuccessModel;

  LogoutSuccessModel? get logoutSuccessModel => _logoutSuccessModel;

  FollowUnfollowSuccessModel? get updateAvatarModel => _updateAvatarModel;

  FollowUnfollowSuccessModel? get changePasswordModel => _changePasswordModel;

  FollowUnfollowSuccessModel? get deleteAccountModel => _deleteAccountModel;

  FollowUnfollowSuccessModel? get unableDisableNotification =>
      _unableDisableNotification;

  FollowUnfollowSuccessModel? get updateProfileImageModel =>
      _updateProfileImageModel;

  bool get isStateLoading => _isStateLoading;

  bool get isCityLoading => _isCityLoading;

  bool get isDeleteAccountLoading => _isDeleteAccountLoading;

  bool get isChangePasswordLoading => _isChangePasswordLoading;

  bool get isSignUpLoading => _isSignUpLoading;

  bool get isCheckUserLoading => _isCheckUserLoading;

  bool get isSendOtpLoading => _isSendOtpLoading;

  bool get isProfileLoading => _isProfileLoading;

  bool get isLogoutLoading => _isLogoutLoading;

  bool get isUpdateAvatarLoading => _isUpdateAvatarLoading;

  bool get isUpdateProfileImageLoading => _isUpdateProfileImageLoading;

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
      _isCheckUserLoading = false;
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

  Future<void> signInUser(SignInRequestModel requestModel) async {
    _isSignUpLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SignupSuccessModel successModel =
          await _userService.signInUser(requestModel: requestModel);
      _signupSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSignUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendOtpForget(CheckUserRequestModel requestModel) async {
    _isSendOtpLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SendOtpSuccessModel successModel =
          await _userService.sendOtp(requestModel: requestModel);
      _sendOtpSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSendOtpLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtpForget(CheckUserRequestModel requestModel) async {
    _isSendOtpLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SendOtpSuccessModel successModel =
          await _userService.verifyOtp(requestModel: requestModel);
      _sendOtpSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSendOtpLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePasswordForget(CheckUserRequestModel requestModel) async {
    _isSignUpLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SendOtpSuccessModel successModel =
          await _userService.changeForgetOtp(requestModel: requestModel);
      _sendOtpSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSignUpLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword(
      CheckUserRequestModel requestModel, String accessToken) async {
    _isChangePasswordLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel = await _userService
          .updatePassword(requestModel: requestModel, accessToken: accessToken);
      _changePasswordModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isChangePasswordLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProfile(
      CommonRequestModel requestModel, String accessToken) async {
    _isProfileLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      ProfileSuccessModel successModel = await _userService.getUserProfile(
          requestModel: requestModel, accessToken: accessToken);
      _profileSuccessModel = successModel;
      profileNotifier.value = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UpdateProfileRequestModel requestModel) async {
    _isProfileLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      ProfileSuccessModel successModel =
          await _userService.updateUserProfile(requestModel: requestModel);
      _profileSuccessModel = successModel;
      profileNotifier.value = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfileWithAvatar(
      CommonRequestModel requestModel, String accessToken) async {
    _isUpdateAvatarLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _userService.updateProfileWithAvatar(
              requestModel: requestModel, accessToken: accessToken);
      _updateAvatarModel = successModel;
      if (successModel.status == '200') {
        getProfile(requestModel,accessToken);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isUpdateAvatarLoading = false;
      notifyListeners();
    }
  }

  Future<void> logoutUser() async {
    _isLogoutLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      LogoutSuccessModel successModel = await _userService.logoutUser();
      _logoutSuccessModel = successModel;
      profileNotifier.value = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLogoutLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfileImage(UpdateProfileImageRequestModel requestModel,
      String accessToken, CommonRequestModel profileRequest) async {
    _isUpdateProfileImageLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _userService.updateProfileImage(requestModel, accessToken);
      _updateProfileImageModel = successModel;
      if (successModel.status == '200') {
        getProfile(profileRequest,accessToken);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isUpdateProfileImageLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount(String accessToken) async {
    _isDeleteAccountLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _userService.deleteAccount(accessToken);
      _deleteAccountModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDeleteAccountLoading = false;
      notifyListeners();
    }
  }

  Future<void> enableDisableNotification(
      CommonRequestModel requestModel, String accessToken) async {
    _isDeleteAccountLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel = await _userService
          .enableDisableNotification(requestModel, accessToken);
      _unableDisableNotification = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDeleteAccountLoading = false;
      notifyListeners();
    }
  }
}
