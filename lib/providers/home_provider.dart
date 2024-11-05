import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/post_list_success_model.dart';
import 'package:hoonar/model/success_models/video_comment_list_model.dart';
import 'package:hoonar/services/home_page_service.dart';

import '../model/success_models/category_list_success_model.dart';

class HomeProvider extends ChangeNotifier {
  final HomePageService _homePageService = GetIt.I<HomePageService>();

  bool _isCategoryLoading = false;
  bool _isPostLoading = false;
  bool _isHomeLoading = false;
  bool _isCommentLoading = false;
  String? _errorMessage;
  CategoryListSuccessModel? _categoryListSuccessModel;
  PostListSuccessModel? _postListSuccessModel;
  HomePostSuccessModel? _homePostSuccessModel;
  FollowUnfollowSuccessModel? _likeUnlikeModel;
  VideoCommentListModel? _videoCommentListModel;

  bool get isCategoryLoading => _isCategoryLoading;

  bool get isPostLoading => _isPostLoading;

  bool get isHomeLoading => _isHomeLoading;

  bool get isCommentLoading => _isCommentLoading;

  String? get errorMessage => _errorMessage;

  CategoryListSuccessModel? get categoryListSuccessModel =>
      _categoryListSuccessModel;

  PostListSuccessModel? get postListSuccessModel => _postListSuccessModel;

  HomePostSuccessModel? get homePostSuccessModel => _homePostSuccessModel;

  FollowUnfollowSuccessModel? get likeUnlikeVideoModel => _likeUnlikeModel;

  VideoCommentListModel? get videoCommentLitModel => _videoCommentListModel;

  Future<void> getCategoryList() async {
    _isCategoryLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      CategoryListSuccessModel categoryListSuccessModel =
          await _homePageService.getCategoryList();
      _categoryListSuccessModel = categoryListSuccessModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isCategoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPostList(ListCommonRequestModel requestModel) async {
    _isPostLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      PostListSuccessModel postListSuccessModel =
          await _homePageService.getPostByCategory(requestModel);
      _postListSuccessModel = postListSuccessModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isPostLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHomePostList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isHomeLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      HomePostSuccessModel successModel =
          await _homePageService.getHomePost(requestModel, accessToken);
      _homePostSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isHomeLoading = false;
      notifyListeners();
    }
  }

  Future<void> likeUnlikeVideo(
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.likeUnlikeVideo(requestModel, accessToken);
      _likeUnlikeModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> getCommentList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isCommentLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      VideoCommentListModel successModel =
          await _homePageService.getCommentList(requestModel, accessToken);
      _videoCommentListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isCommentLoading = false;
      notifyListeners();
    }
  }
}
