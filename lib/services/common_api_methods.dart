import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/session_manager.dart';
import '../constants/utils.dart';

class CommonApiMethods {
  final Dio dio = Dio();
  final SessionManager sessionManager = SessionManager();

  CommonApiMethods() {
    _initializeSessionManager();
  }

  Future<void> _initializeSessionManager() async {
    await sessionManager.initPref();
  }

  // Common options
  Options _dioOptions(String method,
      {String? bearerToken, String contentType = 'application/json'}) {
    return Options(
      method: method,
      headers: {
        'Content-Type': contentType,
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

  Future<T> sendRequest<T>(
    String url, {
    dynamic data,
    String method = 'GET',
    String? accessToken,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await dio.request(
        url,
        data: data,
        options: _dioOptions(
          method,
          bearerToken: sessionManager.getString(SessionManager.accessToken) ??
              accessToken,
          contentType: 'application/json',
        ),
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

  Future<T> sendMultipartRequest<T>(
    String url, {
    required Future<FormData> data, // Make sure this is a Future<FormData>
    String method = 'POST',
    String? accessToken,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final formData = await data; // Await here to get the FormData

      final response = await dio.request(
        url,
        data: formData, // Now passing actual FormData, not a Future<FormData>
        options: _dioOptions(
          method,
          bearerToken: sessionManager.getString(SessionManager.accessToken) ??
              accessToken,
          contentType: 'multipart/form-data',
        ),
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
}
