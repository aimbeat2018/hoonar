import 'dart:convert';

import 'package:hoonar/constants/utils.dart';
import 'package:hoonar/model/request_model/check_user_request_model.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/sign_in_request_model.dart';
import 'package:hoonar/model/request_model/signup_request_model.dart';
import 'package:hoonar/model/request_model/update_profile_request_model.dart';
import 'package:hoonar/model/success_models/avatar_list_model.dart';
import 'package:hoonar/model/success_models/avatar_list_model.dart';
import 'package:hoonar/model/success_models/avatar_list_model.dart';
import 'package:hoonar/model/success_models/check_user_success_model.dart';
import 'package:hoonar/model/success_models/city_list_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/get_followers_list_model.dart';
import 'package:hoonar/model/success_models/logout_success_model.dart';
import 'package:hoonar/model/success_models/profile_success_model.dart';
import 'package:hoonar/model/success_models/send_otp_success_model.dart';
import 'package:hoonar/model/success_models/state_list_model.dart';
import 'package:hoonar/services/common_api_methods.dart';

import '../constants/session_manager.dart';
import '../model/success_models/signup_success_model.dart';
import '../model/success_models/user_wise_vote_list_model.dart';

class UserService {
  final CommonApiMethods apiMethods = CommonApiMethods();

  // Services
  Future<StateListModel> getStateList() async {
    return apiMethods.sendRequest<StateListModel>(
      '$baseUrl$getState',
      fromJson: (data) => StateListModel.fromJson(data),
    );
  }

  Future<CityListModel> getCityList(String stateId) async {
    return apiMethods.sendRequest<CityListModel>(
      '$baseUrl$getCity$stateId',
      fromJson: (data) => CityListModel.fromJson(data),
    );
  }

  Future<CheckUserSuccessModel> checkUserEmailAndMobile({
    CheckUserRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<CheckUserSuccessModel>(
      '$baseUrl$checkUserMobileAndEmail',
      data: requestModel,
      method: 'POST',
      fromJson: (data) => CheckUserSuccessModel.fromJson(data),
    );
  }

  Future<SignupSuccessModel> signUpUser({
    SignupRequestModel? requestModel,
  }) async {
    final userModel = await apiMethods.sendRequest<SignupSuccessModel>(
      '$baseUrl$register',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SignupSuccessModel.fromJson(data),
    );

    // Save user details if successful
    if (userModel.status == '200') {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      sessionManager.saveUser(jsonEncode(userModel));
    }

    return userModel;
  }

  Future<SignupSuccessModel> signInUser({
    SignInRequestModel? requestModel,
  }) async {
    final userModel = await apiMethods.sendRequest<SignupSuccessModel>(
      '$baseUrl$login',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SignupSuccessModel.fromJson(data),
    );

    // Save user details if successful
    if (userModel.status == '200') {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      sessionManager.saveUser(jsonEncode(userModel));
    }

    return userModel;
  }

  Future<SendOtpSuccessModel> sendOtp({
    CheckUserRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<SendOtpSuccessModel>(
      '$baseUrl$sendForgetOtp',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SendOtpSuccessModel.fromJson(data),
    );
  }

  Future<SendOtpSuccessModel> verifyOtp({
    CheckUserRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<SendOtpSuccessModel>(
      '$baseUrl$verifyForgetOtp',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SendOtpSuccessModel.fromJson(data),
    );
  }

  Future<SendOtpSuccessModel> changeForgetOtp({
    CheckUserRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<SendOtpSuccessModel>(
      '$baseUrl$changeForgetPassword',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => SendOtpSuccessModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> updatePassword(
      {CheckUserRequestModel? requestModel, String? accessToken}) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$updatePasswordUrl',
      data: requestModel?.toJson(),
      accessToken: accessToken,
      method: 'POST',
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<ProfileSuccessModel> getUserProfile({
    CommonRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<ProfileSuccessModel>(
      '$baseUrl$getProfile',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => ProfileSuccessModel.fromJson(data),
    );
  }

  Future<ProfileSuccessModel> updateUserProfile({
    UpdateProfileRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<ProfileSuccessModel>(
      '$baseUrl$updateProfile',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => ProfileSuccessModel.fromJson(data),
    );
  }

  Future<LogoutSuccessModel> logoutUser() async {
    return apiMethods.sendRequest<LogoutSuccessModel>(
      '$baseUrl$logout',
      method: 'POST',
      fromJson: (data) => LogoutSuccessModel.fromJson(data),
    );
  }

  Future<GetFollowersListModel> getFollowersList({
    ListCommonRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<GetFollowersListModel>(
      '$baseUrl$getFollowerListUrl',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => GetFollowersListModel.fromJson(data),
    );
  }

  Future<GetFollowersListModel> getFollowingList({
    ListCommonRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<GetFollowersListModel>(
      '$baseUrl$getFollowingListUrl',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => GetFollowersListModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> followUnfollowUser({
    ListCommonRequestModel? requestModel,
  }) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$followUnfollow',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<UserWiseVoteListModel> getVotes() async {
    return apiMethods.sendRequest<UserWiseVoteListModel>(
      '$baseUrl$getUsersVotes',
      fromJson: (data) => UserWiseVoteListModel.fromJson(data),
    );
  }

  Future<AvatarListModel> getAvatarList(
      {CommonRequestModel? requestModel, String? accessToken}) async {
    return apiMethods.sendRequest<AvatarListModel>(
      '$baseUrl$getAvatarsByGenderUrl',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => AvatarListModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> updateProfileWithAvatar(
      {CommonRequestModel? requestModel, String? accessToken}) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$updateProfileWithAvatarUrl',
      data: requestModel?.toJson(),
      method: 'POST',
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }
}
