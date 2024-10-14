import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hoonar/constants/utils.dart';
import 'package:hoonar/model/request_model/signup_request_model.dart';
import 'package:hoonar/model/success_models/city_list_model.dart';
import 'package:hoonar/model/success_models/state_list_model.dart';

import '../constants/session_manager.dart';
import '../model/success_models/signup_success_model.dart';

class UserService {
  final Dio dio = Dio();

  Future<StateListModel> getStateList() async {
    try {
      final response = await dio.get(
        '$baseUrl$getState',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response data
        StateListModel stateList = StateListModel.fromJson(response.data);
        return stateList;
      } else {
        // Throw an error message for non-200 status codes
        throw 'Unexpected error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      // Handling Dio-related exceptions
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          throw 'Connection timed out. Please try again later.';
        case DioExceptionType.badResponse:
          // Handle cases where the server returns a non-2xx status code
          throw 'Server error: ${e.response?.statusCode}. ${e.response?.data['message'] ?? ''}';
        case DioExceptionType.connectionError:
          throw 'Network error: ${e.message}. Please check your internet connection.';
        default:
          throw 'An unexpected error occurred: ${e.message}';
      }
    } catch (e) {
      // Handling any other exceptions or errors
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<CityListModel> getCityList(String stateId) async {
    try {
      final response = await dio.get(
        '$baseUrl$getCity$stateId',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response data
        CityListModel cityList = CityListModel.fromJson(response.data);
        return cityList;
      } else {
        // Throw an error message for non-200 status codes
        throw 'Unexpected error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      // Handling Dio-related exceptions
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          throw 'Connection timed out. Please try again later.';
        case DioExceptionType.badResponse:
          // Handle cases where the server returns a non-2xx status code
          throw 'Server error: ${e.response?.statusCode}. ${e.response?.data['message'] ?? ''}';
        case DioExceptionType.connectionError:
          throw 'Network error: ${e.message}. Please check your internet connection.';
        default:
          throw 'An unexpected error occurred: ${e.message}';
      }
    } catch (e) {
      // Handling any other exceptions or errors
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<SignupSuccessModel> signUpUser(
      {SignupRequestModel? requestModel}) async {
    try {
      final response = await dio.post(
        '$baseUrl$register',
        data: jsonEncode(requestModel!.toJson()),
        options: Options(
          headers: {'Content-Type': 'application/json', 'unique-key': 'dev123'},
        ),
      );

      if (response.statusCode == 200) {
        SignupSuccessModel userModel =
            SignupSuccessModel.fromJson(response.data);

        /*save user details when get status 200 in response model*/
        if (userModel.status == 200) {
          SessionManager sessionManager = SessionManager();
          await sessionManager.initPref();
          sessionManager.saveUser(
            jsonEncode(SignupSuccessModel.fromJson(response.data)),
          );
        }

        return userModel;
      } else {
        // Throw an error message for non-200 status codes
        throw 'Unexpected error: ${response.statusCode}';
      }
    } on DioException catch (e) {
      // Handling Dio-related exceptions
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          throw 'Connection timed out. Please try again later.';
        case DioExceptionType.badResponse:
          // Handle cases where the server returns a non-2xx status code
          throw 'Server error: ${e.response?.statusCode}. ${e.response?.data['message'] ?? ''}';
        case DioExceptionType.connectionError:
          throw 'Network error: ${e.message}. Please check your internet connection.';
        default:
          throw 'An unexpected error occurred: ${e.message}';
      }
    } catch (e) {
      // Handling any other exceptions or errors
      throw 'Something went wrong. Please try again.';
    }
  }
}
