import 'package:dio/dio.dart';

class AddPostRequestModel {
  int? userId;
  int? postId;
  String? postDescription;
  String? postHashTag;
  String? categoryId;
  String? levelId;
  String? saveAsDraft;
  String?
      isOrignalSound; //0-sound selected from list no trim pass sound id , 1 - sound trimmed,
  String? soundTitle;
  String? duration;
  String? singer;
  String? soundId;
  String? postVideoPath; // File path for video
  String? postImagePath; // File path for image
  String? postSound; // File path for image
  String? soundImage; // File path for image

  AddPostRequestModel({
    this.userId,
    this.postId,
    this.postDescription,
    this.postHashTag,
    this.postVideoPath,
    this.saveAsDraft,
    this.isOrignalSound,
    this.postImagePath,
    this.postSound,
    this.categoryId,
    this.soundTitle,
    this.duration,
    this.singer,
    this.soundId,
    this.soundImage,
    this.levelId,
  });

  AddPostRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    postId = json['post_id'];
    postDescription = json['post_description'];
    postHashTag = json['post_hash_tag'];
    categoryId = json['category_id'];
    levelId = json['level_id'];
    postVideoPath = json['post_video'];
    postImagePath = json['post_image'];
    postSound = json['post_sound'];
    saveAsDraft = json['save_as_draft'];
    isOrignalSound = json['is_orignal_sound'];
    soundTitle = json['sound_title'];
    duration = json['duration'];
    singer = json['singer'];
    soundId = json['sound_id'];
    soundImage = json['sound_image'];
  }

  Future<FormData> toFormData() async {
    Map<String, dynamic> data = {
      'user_id': userId,
      'post_id': postId,
      'post_description': postDescription,
      'post_hash_tag': postHashTag,
      'category_id': categoryId,
      'level_id': levelId,
      'save_as_draft': saveAsDraft,
      'is_orignal_sound': isOrignalSound,
      'sound_title': soundTitle,
      'duration': duration,
      'singer': singer,
      'sound_id': soundId,
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
    } // If there is an image file path, add it to FormData as MultipartFile
    if (postSound != null) {
      data['post_sound'] = await MultipartFile.fromFile(
        postSound!,
        filename: postSound!.split('/').last,
      );
    }
    if (soundImage != null) {
      data['sound_image'] = await MultipartFile.fromFile(
        soundImage!,
        filename: soundImage!.split('/').last,
      );
    }

    return FormData.fromMap(data);
  }
}
