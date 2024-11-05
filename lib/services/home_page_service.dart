import 'dart:convert';

import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/category_list_success_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/post_list_success_model.dart';
import 'package:hoonar/model/success_models/video_comment_list_model.dart';
import 'package:hoonar/model/success_models/video_comment_list_model.dart';
import 'package:hoonar/model/success_models/video_comment_list_model.dart';

import '../constants/utils.dart';
import 'common_api_methods.dart';

class HomePageService {
  final CommonApiMethods apiMethods = CommonApiMethods();

  // Services
  Future<CategoryListSuccessModel> getCategoryList() async {
    return apiMethods.sendRequest<CategoryListSuccessModel>(
      '$baseUrl$getCategoryData',
      fromJson: (data) => CategoryListSuccessModel.fromJson(data),
    );
  }

  Future<PostListSuccessModel> getPostByCategory(
      ListCommonRequestModel requestModel) async {
    return apiMethods.sendRequest<PostListSuccessModel>(
      '$baseUrl$getPostList',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => PostListSuccessModel.fromJson(data),
    );
  }

  Future<HomePostSuccessModel> getHomePost(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<HomePostSuccessModel>(
      '$baseUrl$getHomePostList',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => HomePostSuccessModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> likeUnlikeVideo(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$likeUnlike',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> addVote(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$addVoteUrl',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<VideoCommentListModel> getCommentList(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<VideoCommentListModel>(
      '$baseUrl$getCommentUrl',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => VideoCommentListModel.fromJson(data),
    );
  }
}
