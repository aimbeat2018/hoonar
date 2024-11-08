import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/add_post_request_model.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_search_data_request_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/hash_tag_list_model.dart';
import 'package:hoonar/model/success_models/home_page_other_data_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/post_list_success_model.dart';
import 'package:hoonar/model/success_models/search_list_model.dart';
import 'package:hoonar/model/success_models/user_search_history_model.dart';
import 'package:hoonar/model/success_models/video_comment_list_model.dart';
import 'package:hoonar/services/home_page_service.dart';

import '../model/success_models/category_list_success_model.dart';
import '../model/success_models/home_page_other_view_all_model.dart';

class HomeProvider extends ChangeNotifier {
  final HomePageService _homePageService = GetIt.I<HomePageService>();

  ValueNotifier<VideoCommentListModel?> commentListNotifier =
      ValueNotifier(null);

  bool _isCategoryLoading = false;
  bool _isPostLoading = false;
  bool _isHomeLoading = false;
  bool _isOtherHomeLoading = false;
  bool _isCommentLoading = false;
  bool _isAddPostLoading = false;
  bool _isHashTagLoading = false;
  bool _isViewAllLoading = false;
  bool _isSearchLoading = false;
  String? _errorMessage;
  CategoryListSuccessModel? _categoryListSuccessModel;
  PostListSuccessModel? _postListSuccessModel;
  HomePostSuccessModel? _homePostSuccessModel;
  FollowUnfollowSuccessModel? _likeUnlikeModel;
  FollowUnfollowSuccessModel? _deleteCommentModel;
  FollowUnfollowSuccessModel? _addPostModel;
  VideoCommentListModel? _videoCommentListModel;
  HashTagListModel? _hashTagListModel;
  HomePageOtherDataModel? _homePageOtherDataModel;
  HomePageOtherViewAllModel? _homePageOtherViewAllModel;
  SearchListModel? _searchListModel;
  UserSearchHistoryModel? _userSearchHistoryModel;

  bool get isCategoryLoading => _isCategoryLoading;

  bool get isPostLoading => _isPostLoading;

  bool get isHomeLoading => _isHomeLoading;

  bool get isCommentLoading => _isCommentLoading;

  bool get isAddPostLoading => _isAddPostLoading;

  bool get isHashTagLoading => _isHashTagLoading;

  bool get isOtherHomeLoading => _isOtherHomeLoading;

  bool get isViewAllLoading => _isViewAllLoading;

  bool get isSearchLoading => _isSearchLoading;

  String? get errorMessage => _errorMessage;

  CategoryListSuccessModel? get categoryListSuccessModel =>
      _categoryListSuccessModel;

  HomePageOtherDataModel? get homePageOtherDataModel => _homePageOtherDataModel;

  PostListSuccessModel? get postListSuccessModel => _postListSuccessModel;

  HomePostSuccessModel? get homePostSuccessModel => _homePostSuccessModel;

  FollowUnfollowSuccessModel? get likeUnlikeVideoModel => _likeUnlikeModel;

  FollowUnfollowSuccessModel? get deleteCommentModel => _deleteCommentModel;

  FollowUnfollowSuccessModel? get addPostModel => _addPostModel;

  VideoCommentListModel? get videoCommentLitModel => _videoCommentListModel;

  HashTagListModel? get hashTagListModel => _hashTagListModel;

  SearchListModel? get searchListModel => _searchListModel;

  UserSearchHistoryModel? get userSearchHistoryModel => _userSearchHistoryModel;

  HomePageOtherViewAllModel? get homePageOtherViewAllModel =>
      _homePageOtherViewAllModel;

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

  Future<void> getHomeOtherPostList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isOtherHomeLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      HomePageOtherDataModel successModel = await _homePageService
          .getHomePageOtherData(requestModel, accessToken);
      _homePageOtherDataModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isOtherHomeLoading = false;
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

  Future<void> addVote(
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.addVote(requestModel, accessToken);
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
      commentListNotifier.value = _videoCommentListModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isCommentLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPost(
      AddPostRequestModel requestModel, String accessToken) async {
    _isAddPostLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.addPost(requestModel, accessToken);
      _addPostModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isAddPostLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHashTagList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isHashTagLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      HashTagListModel successModel =
          await _homePageService.getHashTagList(requestModel, accessToken);
      _hashTagListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isHashTagLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOtherViewAllList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isViewAllLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      HomePageOtherViewAllModel successModel =
          await _homePageService.getOtherViewAllList(requestModel, accessToken);
      _homePageOtherViewAllModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isViewAllLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchUser(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isSearchLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SearchListModel successModel =
          await _homePageService.searchUser(requestModel, accessToken);
      _searchListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  Future<void> userSearchHistory(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isSearchLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserSearchHistoryModel successModel =
          await _homePageService.userSearchHistory(requestModel, accessToken);
      _userSearchHistoryModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  Future<void> storeSearchData(
      StoreSearchDataRequestModel requestModel, String accessToken) async {
    _isSearchLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.storeSearchData(requestModel, accessToken);
      _addPostModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSearchData(
      ListCommonRequestModel requestModel, String accessToken) async {
    // _isSearchLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.deleteSearchData(requestModel, accessToken);
      _addPostModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      // _isSearchLoading = false;
      notifyListeners();
    }
  }

  Future<void> addComment(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isSearchLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.addComments(requestModel, accessToken);
      _addPostModel = successModel;
      if (successModel.status == '200') {
        getCommentList(requestModel, accessToken);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  Future<void> likeUnlikeComment(
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.likeUnlikeComment(requestModel, accessToken);
      _likeUnlikeModel = successModel;
      if (successModel.status == '200') {
        getCommentList(requestModel, accessToken);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteComment(
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.deleteComment(requestModel, accessToken);
      _deleteCommentModel = successModel;
      if (successModel.status == '200') {
        getCommentList(requestModel, accessToken);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
