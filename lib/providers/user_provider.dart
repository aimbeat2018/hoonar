import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/success_models/avatar_list_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/user_wise_vote_list_model.dart';
import 'package:hoonar/services/user_service.dart';

import '../model/request_model/list_common_request_model.dart';
import '../model/success_models/get_followers_list_model.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = GetIt.I<UserService>();

  ValueNotifier<GetFollowersListModel?> followersNotifier = ValueNotifier(null);
  ValueNotifier<String?> followersCountNotifier = ValueNotifier("0");

  ValueNotifier<GetFollowersListModel?> followingNotifier = ValueNotifier(null);
  ValueNotifier<UserWiseVoteListModel?> userWiseVotesNotifier =
      ValueNotifier(null);
  ValueNotifier<String?> followingCountNotifier = ValueNotifier("0");
  ValueNotifier<int?> followStatusNotifier = ValueNotifier(0);

  bool _isLoading = false;
  bool _isAvatarLoading = false;

  String? _errorMessage;
  List<FollowersData>? _followersList;
  List<UserWiseVoteList>? _userWiseVoteList;
  GetFollowersListModel? _getFollowersListModel;
  UserWiseVoteListModel? _userWiseVoteListModel;
  AvatarListModel? _avatarListModel;

  List<FollowersData>? get followersList => _followersList;

  List<UserWiseVoteList>? get userWiseVoteList => _userWiseVoteList;

  GetFollowersListModel? get getFollowersListModel => _getFollowersListModel;

  List<FollowersData>? _followingList;
  GetFollowersListModel? _getFollowingListModel;

  List<FollowersData>? get followingList => _followingList;

  GetFollowersListModel? get getFollowingListModel => _getFollowingListModel;

  UserWiseVoteListModel? get userWiseVoteListModel => _userWiseVoteListModel;

  AvatarListModel? get avatarListModel => _avatarListModel;

  bool get isLoading => _isLoading;

  bool get isAvatarLoading => _isAvatarLoading;

  String? get errorMessage => _errorMessage;

  Future<void> getFollowers(ListCommonRequestModel requestModel) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      GetFollowersListModel followersListModel =
          await _userService.getFollowersList(requestModel: requestModel);
      _getFollowersListModel = followersListModel;
      _followersList = followersListModel.data;
      followersNotifier.value = followersListModel;
      if (_followersList!.isNotEmpty) {
        followersListModel.data != null
            ? followersCountNotifier.value =
                followersListModel.data!.length.toString()
            : "0";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFollowing(ListCommonRequestModel requestModel) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      GetFollowersListModel followersListModel =
          await _userService.getFollowingList(requestModel: requestModel);
      _getFollowingListModel = followersListModel;
      _followingList = followersListModel.data;
      followingNotifier.value = followersListModel;
      if (_followingList!.isNotEmpty) {
        followersListModel.data != null
            ? followingCountNotifier.value =
                followersListModel.data!.length.toString()
            : "0";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> followUnfollowUser(ListCommonRequestModel requestModel) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _userService.followUnfollowUser(requestModel: requestModel);
      followStatusNotifier.value = successModel.followStatus ?? 0;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<void> getVotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserWiseVoteListModel successModel = await _userService.getVotes();
      _userWiseVoteListModel = successModel;
      _userWiseVoteList = successModel.data;
      userWiseVotesNotifier.value = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAvatarList(
      CommonRequestModel requestModel, String accessToken) async {
    _isAvatarLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      AvatarListModel successModel = await _userService.getAvatarList(
          requestModel: requestModel, accessToken: accessToken);
      _avatarListModel = successModel;
      // _userWiseVoteList = successModel.data;
      // userWiseVotesNotifier.value = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isAvatarLoading = false;
      notifyListeners();
    }
  }
}
