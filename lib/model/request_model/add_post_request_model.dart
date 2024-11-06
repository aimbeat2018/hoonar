import 'package:dio/dio.dart';

class AddPostRequestModel {
  int? userId;
  String? postDescription;
  String? postHashTag;
  String? categoryId;
  String? levelId;
  String? saveAsDraft;
  String? postVideoPath; // File path for video
  String? postImagePath; // File path for image

  AddPostRequestModel({
    this.userId,
    this.postDescription,
    this.postHashTag,
    this.postVideoPath,
    this.saveAsDraft,
    this.postImagePath,
    this.categoryId,
    this.levelId,
  });

  AddPostRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    postDescription = json['post_description'];
    postHashTag = json['post_hash_tag'];
    categoryId = json['category_id'];
    levelId = json['level_id'];
    postVideoPath = json['post_video'];
    postImagePath = json['post_image'];
    saveAsDraft = json['save_as_draft'];
  }

  Future<FormData> toFormData() async {
    Map<String, dynamic> data = {
      'user_id': userId,
      'post_description': postDescription,
      'post_hash_tag': postHashTag,
      'category_id': categoryId,
      'level_id': levelId,
      'save_as_draft': saveAsDraft,
    };

    // If there is a video file path, add it to FormData as MultipartFile
    if (postVideoPath != null) {
      data['post_video'] = await MultipartFile.fromFile(
        postVideoPath!,
        filename: postVideoPath!.split('/').last,
      );
    }

    // If there is an image file path, add it to FormData as MultipartFile
    if (postImagePath != null) {
      data['post_image'] = await MultipartFile.fromFile(
        postImagePath!,
        filename: postImagePath!.split('/').last,
      );
    }

    return FormData.fromMap(data);
  }
}
