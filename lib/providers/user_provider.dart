import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/check_user_request_model.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/request_model/sign_in_request_model.dart';
import 'package:hoonar/model/request_model/signup_request_model.dart';
import 'package:hoonar/model/request_model/update_profile_request_model.dart';
import 'package:hoonar/model/success_models/check_user_success_model.dart';
import 'package:hoonar/model/success_models/city_list_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/logout_success_model.dart';
import 'package:hoonar/model/success_models/profile_success_model.dart';
import 'package:hoonar/model/success_models/signup_success_model.dart';
import 'package:hoonar/services/user_service.dart';
import '../model/request_model/list_common_request_model.dart';
import '../model/success_models/get_followers_list_model.dart';
import '../model/success_models/send_otp_success_model.dart';
import '../model/success_models/state_list_model.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = GetIt.I<UserService>();

  ValueNotifier<GetFollowersListModel?> followersNotifier = ValueNotifier(null);
  ValueNotifier<String?> followersCountNotifier = ValueNotifier("0");

  ValueNotifier<GetFollowersListModel?> followingNotifier = ValueNotifier(null);
  ValueNotifier<String?> followingCountNotifier = ValueNotifier("0");
  ValueNotifier<int?> followStatusNotifier = ValueNotifier(0);

  bool _isLoading = false;
  String? _errorMessage;
  List<FollowersData>? _followersList;
  GetFollowersListModel? _getFollowersListModel;

  List<FollowersData>? get followersList => _followersList;

  GetFollowersListModel? get getFollowersListModel => _getFollowersListModel;

  List<FollowersData>? _followingList;
  GetFollowersListModel? _getFollowingListModel;

  List<FollowersData>? get followingList => _followingList;

  GetFollowersListModel? get getFollowingListModel => _getFollowingListModel;

  bool get isLoading => _isLoading;

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
      _getFollowersListModel = followersListModel;
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
}
