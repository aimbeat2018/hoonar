import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/session_manager.dart';
import '../constants/utils.dart';

class CommonApiMethods {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(minutes: 10),
    receiveTimeout: const Duration(minutes: 10),
  ));
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
        // return 'Bad Internet connection';
        return 'Something went wrong. Please try again later.';
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
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final formData = await data; // Await here to get the FormData

      final response = await dio.request(
        url,
        data: formData,
        options: _dioOptions(
          method,
          bearerToken: sessionManager.getString(SessionManager.accessToken) ??
              accessToken,
          contentType: 'multipart/form-data',
        )..copyWith(
            sendTimeout: const Duration(minutes: 10),
            receiveTimeout: const Duration(minutes: 10),
          ),
        onSendProgress: onProgress,
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

  Future<void> uploadVideo({
    required File videoFile,
    required String url,
    required String accessToken,
    required Function(int progress) onProgress,
  }) async {
    const int chunkSize = 5 * 1024 * 1024; // 5MB per chunk
    int fileSize = videoFile.lengthSync();

    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    // ✅ Check if file size is less than 5MB
    if (fileSize <= chunkSize) {
      // ✅ Upload as a single file
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(videoFile.path,
            filename: videoFile.path.split('/').last),
      });

      try {
        Response response = await dio.post(
          url,
          data: formData,
          onSendProgress: (int sent, int total) {
            double percentage = ((sent / total) * 100);
            onProgress(percentage.toInt());
          },
        );

        if (response.statusCode == 200) {
          print('✅ Video uploaded successfully');
        } else {
          throw Exception('Failed to upload video');
        }
      } catch (e) {
        print('❌ Error uploading small video: $e');
        throw Exception('Failed to upload video');
      }
    } else {
      // ✅ Upload in chunks if file size > 5MB
      await uploadVideoInChunks(
        videoFile: videoFile,
        url: url,
        accessToken: accessToken,
        chunkSize: chunkSize,
        onProgress: onProgress,
      );
    }
  }

  /// ✅ Function to Upload Large Videos in Chunks
  Future<void> uploadVideoInChunks({
    required File videoFile,
    required String url,
    required String accessToken,
    required int chunkSize,
    required Function(int progress) onProgress,
  }) async {
    int fileSize = videoFile.lengthSync();
    int totalChunks = (fileSize / chunkSize).ceil();

    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    // ✅ Split and Upload Chunks
    for (int i = 0; i < totalChunks; i++) {
      int start = i * chunkSize;
      int end = (i + 1) * chunkSize;
      if (end > fileSize) end = fileSize;

      // ✅ Read the chunk from file
      List<int> chunkBytes = videoFile.readAsBytesSync().sublist(start, end);

      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(chunkBytes,
            filename: videoFile.path.split('/').last),
        'chunkIndex': i,
        'totalChunks': totalChunks,
      });

      try {
        Response response = await dio.post(
          url,
          data: formData,
          onSendProgress: (int sent, int total) {
            int totalSent = (i * chunkSize) + sent;
            double percentage = ((totalSent / fileSize) * 100);
            onProgress(percentage.toInt());
          },
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to upload chunk $i');
        }

        print('✅ Uploaded chunk $i of $totalChunks');
      } catch (e) {
        print('❌ Failed to upload chunk $i: $e');
        throw Exception('Failed to upload video');
      }
    }

    print('✅ Video uploaded successfully');
  }
}
