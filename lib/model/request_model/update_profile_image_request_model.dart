import 'dart:io';
import 'package:dio/dio.dart';

class UpdateProfileImageRequestModel {
  File? profileImage; // Assuming 'document' is a file to be uploaded

  UpdateProfileImageRequestModel({this.profileImage});

  UpdateProfileImageRequestModel.fromJson(Map<String, dynamic> json) {
    profileImage = File(json['profile_image']); // Convert path to File
  }

  Future<FormData> toFormData() async {
    Map<String, dynamic> fields = {};

    if (profileImage != null) {
      fields['profile_image'] = await MultipartFile.fromFile(
        profileImage!.path,
        filename: profileImage!.path.split('/').last, // Extract filename
      );
    }

    return FormData.fromMap(fields);
  }
}
