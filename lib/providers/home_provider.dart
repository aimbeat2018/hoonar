import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/add_post_request_model.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_search_data_request_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/get_post_details_model.dart';
import 'package:hoonar/model/success_models/hash_tag_list_model.dart';
import 'package:hoonar/model/success_models/home_page_other_data_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/notification_list_model.dart';
import 'package:hoonar/model/success_models/post_list_success_model.dart';
import 'package:hoonar/model/success_models/report_reasons_model.dart';
import 'package:hoonar/model/success_models/search_list_model.dart';
import 'package:hoonar/model/success_models/user_search_history_model.dart';
import 'package:hoonar/model/success_models/video_comment_list_model.dart';
import 'package:hoonar/providers/user_provider.dart';
import 'package:hoonar/services/home_page_service.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../model/success_models/category_list_success_model.dart';
import '../model/success_models/home_page_other_view_all_model.dart';

class HomeProvider extends ChangeNotifier {
  final HomePageService _homePageService = GetIt.I<HomePageService>();

  ValueNotifier<VideoCommentListModel?> commentListNotifier =
      ValueNotifier(null);

  ValueNotifier<String> notificationCountNotifier = ValueNotifier('0');

  ValueNotifier<NotificationListModel?> notificationListNotifier =
      ValueNotifier(null);
  double _uploadProgress = 0.0;

  bool _isCategoryLoading = false;
  bool _isPostLoading = false;
  bool _isHomeLoading = false;
  bool _isOtherHomeLoading = false;
  bool _isCommentLoading = false;
  bool _isAddPostLoading = false;
  bool _isHashTagLoading = false;
  bool _isViewAllLoading = false;
  bool _isSearchLoading = false;
  bool _isNotificationLoading = false;
  bool _isReadNotificationLoading = false;
  bool _isReportReasonsLoading = false;
  bool _isReportPostLoading = false;
  bool _isDeletePostLoading = false;
  bool _isDeleteNotificationLoading = false;
  String? _errorMessage;
  CategoryListSuccessModel? _categoryListSuccessModel;
  PostListSuccessModel? _postListSuccessModel;
  HomePostSuccessModel? _homePostSuccessModel;
  FollowUnfollowSuccessModel? _likeUnlikeModel;
  FollowUnfollowSuccessModel? _deleteCommentModel;
  FollowUnfollowSuccessModel? _videoCountModel;
  FollowUnfollowSuccessModel? _postInterestModel;
  FollowUnfollowSuccessModel? _deletePostModel;
  FollowUnfollowSuccessModel? _deleteNotificationModel;
  FollowUnfollowSuccessModel? _reportPostModel;
  ReportReasonsModel? _reportReasonsModel;
  NotificationListModel? _notificationListModel;
  FollowUnfollowSuccessModel? _addPostModel;
  FollowUnfollowSuccessModel? _notificationReadModel;
  VideoCommentListModel? _videoCommentListModel;
  HashTagListModel? _hashTagListModel;
  HomePageOtherDataModel? _homePageOtherDataModel;
  HomePageOtherViewAllModel? _homePageOtherViewAllModel;
  SearchListModel? _searchListModel;
  UserSearchHistoryModel? _userSearchHistoryModel;
  GetPostDetailsModel? _getPostDetailsModel;

  double get uploadProgress => _uploadProgress;

  bool get isCategoryLoading => _isCategoryLoading;

  bool get isPostLoading => _isPostLoading;

  bool get isHomeLoading => _isHomeLoading;

  bool get isCommentLoading => _isCommentLoading;

  bool get isAddPostLoading => _isAddPostLoading;

  bool get isHashTagLoading => _isHashTagLoading;

  bool get isOtherHomeLoading => _isOtherHomeLoading;

  bool get isViewAllLoading => _isViewAllLoading;

  bool get isReportReasonsLoading => _isReportReasonsLoading;

  bool get isReportPostLoading => _isReportPostLoading;

  bool get isDeletePostLoading => _isDeletePostLoading;

  bool get isDeleteNotificationLoading => _isDeleteNotificationLoading;

  bool get isSearchLoading => _isSearchLoading;

  String? get errorMessage => _errorMessage;

  CategoryListSuccessModel? get categoryListSuccessModel =>
      _categoryListSuccessModel;

  HomePageOtherDataModel? get homePageOtherDataModel => _homePageOtherDataModel;

  PostListSuccessModel? get postListSuccessModel => _postListSuccessModel;

  ReportReasonsModel? get reportReasonsModel => _reportReasonsModel;

  GetPostDetailsModel? get getPostDetailsModel => _getPostDetailsModel;

  HomePostSuccessModel? get homePostSuccessModel => _homePostSuccessModel;

  FollowUnfollowSuccessModel? get likeUnlikeVideoModel => _likeUnlikeModel;

  FollowUnfollowSuccessModel? get deleteCommentModel => _deleteCommentModel;

  FollowUnfollowSuccessModel? get videoCountModel => _videoCountModel;

  FollowUnfollowSuccessModel? get postInterestModel => _postInterestModel;

  FollowUnfollowSuccessModel? get deletePostModel => _deletePostModel;

  FollowUnfollowSuccessModel? get deleteNotificationModel =>
      _deleteNotificationModel;

  FollowUnfollowSuccessModel? get reportPostModel => _reportPostModel;

  FollowUnfollowSuccessModel? get notificationReadModel =>
      _notificationReadModel;

  NotificationListModel? get notificationListModel => _notificationListModel;

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

  /*------ update follow status when fetches users list --------*/
  void updateUserFollowStatus(
      BuildContext context, int userId, int followStatus) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Map<int, int?> followStatuses = userProvider.followStatusNotifier.value;
    userProvider.updateFollowStatus(userId, followStatus);
    // Use followStatuses here...
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

  Future<void> getSinglePostDetails(
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    notifyListeners();

    try {
      GetPostDetailsModel successModel = await _homePageService
          .getSinglePostDetails(requestModel, accessToken);
      _getPostDetailsModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
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
    _uploadProgress = 0.0;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel = await _homePageService.addPost(
        requestModel,
        accessToken,
        onProgress: (sent, total) {
          _uploadProgress = sent / total; // Update progress
          log('progress $_uploadProgress');
          notifyListeners();
        },
      );
      _addPostModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isAddPostLoading = false;

      notifyListeners();
    }
  }

  Future<void> updatePost(
      AddPostRequestModel requestModel, String accessToken) async {
    _isAddPostLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.updatePost(requestModel, accessToken);
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

  Future<void> updatePostViewCount(
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.updatePostViewCount(requestModel, accessToken);
      _videoCountModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> postInterest(
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.postInterest(requestModel, accessToken);
      _postInterestModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> deletePost(BuildContext context,
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    _isDeletePostLoading = true;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.deletePost(requestModel, accessToken);
      _deletePostModel = successModel;
      // if(_deletePostModel!.status == "200"){
      //   await Provider.of<AuthProvider>(context, listen: false).getProfile(CommonRequestModel(),accessToken);
      //
      // }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDeletePostLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNotification(BuildContext context,
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    _isDeleteNotificationLoading = true;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.deleteNotification(requestModel, accessToken);
      _deleteNotificationModel = successModel;
      // if(_deletePostModel!.status == "200"){
      //   await Provider.of<AuthProvider>(context, listen: false).getProfile(CommonRequestModel(),accessToken);
      //
      // }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDeleteNotificationLoading = false;
      notifyListeners();
    }
  }

  Future<void> getNotificationList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isNotificationLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      NotificationListModel successModel =
          await _homePageService.getNotificationList(requestModel, accessToken);
      _notificationListModel = successModel;
      if (successModel.status == '200') {
        notificationCountNotifier.value =
            _notificationListModel!.unreadCount!.toString();
        notificationListNotifier.value = _notificationListModel;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isNotificationLoading = false;
      notifyListeners();
    }
  }

  Future<void> markNotificationAsRead(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isReadNotificationLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel = await _homePageService
          .markNotificationAsRead(requestModel, accessToken);
      _notificationReadModel = successModel;
      if (successModel.status == '200') {
        notificationCountNotifier.value = '0';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isReadNotificationLoading = false;
      notifyListeners();
    }
  }

  Future<void> getReportReasonsList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _errorMessage = null;
    _isReportReasonsLoading = true;
    notifyListeners();

    try {
      ReportReasonsModel successModel =
          await _homePageService.reportReasonsList(requestModel, accessToken);
      _reportReasonsModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isReportReasonsLoading = false;
      notifyListeners();
    }
  }

  Future<void> reportPost(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isReportPostLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _homePageService.reportPost(requestModel, accessToken);
      _reportPostModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isReportPostLoading = false;
      notifyListeners();
    }
  }
}
