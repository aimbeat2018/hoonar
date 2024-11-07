import 'dart:convert';

import 'package:hoonar/model/request_model/add_post_request_model.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_search_data_request_model.dart';
import 'package:hoonar/model/success_models/category_list_success_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/hash_tag_list_model.dart';
import 'package:hoonar/model/success_models/hash_tag_list_model.dart';
import 'package:hoonar/model/success_models/hash_tag_list_model.dart';
import 'package:hoonar/model/success_models/home_page_other_data_model.dart';
import 'package:hoonar/model/success_models/home_page_other_data_model.dart';
import 'package:hoonar/model/success_models/home_page_other_data_model.dart';
import 'package:hoonar/model/success_models/home_page_other_view_all_model.dart';
import 'package:hoonar/model/success_models/home_page_other_view_all_model.dart';
import 'package:hoonar/model/success_models/home_page_other_view_all_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/post_list_success_model.dart';
import 'package:hoonar/model/success_models/search_list_model.dart';
import 'package:hoonar/model/success_models/search_list_model.dart';
import 'package:hoonar/model/success_models/search_list_model.dart';
import 'package:hoonar/model/success_models/user_search_history_model.dart';
import 'package:hoonar/model/success_models/user_search_history_model.dart';
import 'package:hoonar/model/success_models/user_search_history_model.dart';
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

  Future<HomePageOtherDataModel> getHomePageOtherData(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<HomePageOtherDataModel>(
      '$baseUrl$getHomePagePostList',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => HomePageOtherDataModel.fromJson(data),
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

  Future<FollowUnfollowSuccessModel> addPost(
      AddPostRequestModel requestModel, String accessToken) async {
    return apiMethods.sendMultipartRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$addPostUrl',
      method: 'POST',
      data: requestModel.toFormData(),
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<HashTagListModel> getHashTagList(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<HashTagListModel>(
      '$baseUrl$getHashTagListUrl',
      data: requestModel.toJson(),
      fromJson: (data) => HashTagListModel.fromJson(data),
    );
  }

  Future<HomePageOtherViewAllModel> getOtherViewAllList(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<HomePageOtherViewAllModel>(
      '$baseUrl$getHomePageViewAllPostUrl',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => HomePageOtherViewAllModel.fromJson(data),
    );
  }

  Future<SearchListModel> searchUser(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<SearchListModel>(
      '$baseUrl$searchUserUrl',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => SearchListModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> storeSearchData(
      StoreSearchDataRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$storeSearchHistoryUrl',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<UserSearchHistoryModel> userSearchHistory(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<UserSearchHistoryModel>(
      '$baseUrl$userSearchHistoryUrl',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => UserSearchHistoryModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> deleteSearchData(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$removeUserSearchHistoryUrl',
      method: 'POST',
      data: requestModel.toJson(),
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }
}
