import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hoonar/constants/utils.dart';
import 'package:hoonar/model/request_model/check_user_request_model.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/request_model/sign_in_request_model.dart';
import 'package:hoonar/model/request_model/signup_request_model.dart';
import 'package:hoonar/model/success_models/check_user_success_model.dart';
import 'package:hoonar/model/success_models/city_list_model.dart';
import 'package:hoonar/model/success_models/profile_success_model.dart';
import 'package:hoonar/model/success_models/send_otp_success_model.dart';
import 'package:hoonar/model/success_models/state_list_model.dart';

import '../constants/session_manager.dart';
import '../model/success_models/signup_success_model.dart';

class UserService {
  final Dio dio = Dio();
  final SessionManager sessionManager = SessionManager();

  // Common options
  Options _dioOptions(String method, {String? bearerToken}) {
    return Options(
      method: method,
      headers: {
        'Content-Type': 'application/json',
        'unique-key': headerUniqueKey,
        if (bearerToken != null) 'Authorization': bearerToken,
      },
    );
  }

  // Generic error handler
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again later.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}. ${e.response?.data['message'] ?? ''}';
      case DioExceptionType.connectionError:
        return 'Network error: ${e.message}. Please check your internet connection.';
      default:
        return 'An unexpected error occurred: ${e.message}';
    }
  }

  // Generic request handler
  Future<T> _sendRequest<T>(
    String url, {
    dynamic data,
    String method = 'GET',
    String? token,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await dio.request(
        url,
        data: data != null ? jsonEncode(data) : null,
        options: _dioOptions(method),
      );

      if (response.statusCode == 200) {
        return fromJson(response.data);
      } else {
        throw 'Unexpected error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // Services
  Future<StateListModel> getStateList() async {
    return _sendRequest<StateListModel>(
      '$baseUrl$getState',
      fromJson: (data) => StateListModel.fromJson(data),
    );
  }

  Future<CityListModel> getCityList(String stateId) async {
    return _sendRequest<CityListModel>(
      '$baseUrl$getCity$stateId',
      fromJson: (data) => CityListModel.fromJson(data),
    );
  }

  Future<CheckUserSuccessModel> checkUserEmailAndMobile({
    CheckUserRequestModel? requestModel,
  }) async {
    return _sendRequest<CheckUserSuccessModel>(
      '$baseUrl$checkUserMobileAndEmail',
      data: requestModel,
      method: 'POST',
      fromJson: (data) => CheckUserSuccessModel.fromJson(data),
    );
  }

  Future<SignupSuccessModel> signUpUser({
    SignupRequestModel? requestModel,
  }) async {
    final userModel = await _sendRequest<SignupSuccessModel>(
      '$baseUrl$register',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SignupSuccessModel.fromJson(data),
    );

    // Save user details if successful
    if (userModel.status == '200') {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      sessionManager.saveUser(jsonEncode(userModel));
    }

    return userModel;
  }

  Future<SignupSuccessModel> signInUser({
    SignInRequestModel? requestModel,
  }) async {
    final userModel = await _sendRequest<SignupSuccessModel>(
      '$baseUrl$login',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SignupSuccessModel.fromJson(data),
    );

    // Save user details if successful
    if (userModel.status == '200') {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      sessionManager.saveUser(jsonEncode(userModel));
    }

    return userModel;
  }

  Future<SendOtpSuccessModel> sendOtp({
    CheckUserRequestModel? requestModel,
  }) async {
    return _sendRequest<SendOtpSuccessModel>(
      '$baseUrl$sendForgetOtp',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SendOtpSuccessModel.fromJson(data),
    );
  }

  Future<SendOtpSuccessModel> verifyOtp({
    CheckUserRequestModel? requestModel,
  }) async {
    return _sendRequest<SendOtpSuccessModel>(
      '$baseUrl$verifyForgetOtp',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SendOtpSuccessModel.fromJson(data),
    );
  }

  Future<SendOtpSuccessModel> changeForgetOtp({
    CheckUserRequestModel? requestModel,
  }) async {
    return _sendRequest<SendOtpSuccessModel>(
      '$baseUrl$changeForgetPassword',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SendOtpSuccessModel.fromJson(data),
    );
  }

  Future<ProfileSuccessModel> getUserProfile({
    CommonRequestModel? requestModel,
  }) async {
    sessionManager.initPref();
    return _sendRequest<ProfileSuccessModel>(
      '$baseUrl$getProfile',
      data: requestModel?.toJson(),
      method: 'POST',
      token: sessionManager.getString(SessionManager.accessToken),
      fromJson: (data) => ProfileSuccessModel.fromJson(data),
    );
  }
}
