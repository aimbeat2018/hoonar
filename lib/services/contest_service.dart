import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_payment_request_model.dart';
import 'package:hoonar/model/request_model/upload_kyc_document_request_model.dart';
import 'package:hoonar/model/success_models/DraftFeedListModel.dart';
import 'package:hoonar/model/success_models/guidelines_model.dart';
import 'package:hoonar/model/success_models/hoonar_star_success_model.dart';
import 'package:hoonar/model/success_models/kyc_status_model.dart';
import 'package:hoonar/model/success_models/kyc_status_model.dart';
import 'package:hoonar/model/success_models/kyc_status_model.dart';
import 'package:hoonar/model/success_models/leaderboard_list_model.dart';
import 'package:hoonar/model/success_models/level_list_model.dart';
import 'package:hoonar/model/success_models/news_event_success_model.dart';
import 'package:hoonar/model/success_models/news_event_success_model.dart';
import 'package:hoonar/model/success_models/news_event_success_model.dart';
import 'package:hoonar/model/success_models/reward_list_model.dart';
import 'package:hoonar/model/success_models/reward_list_model.dart';
import 'package:hoonar/model/success_models/reward_list_model.dart';
import 'package:hoonar/model/success_models/sound_list_model.dart';
import 'package:hoonar/model/success_models/sound_list_model.dart';
import 'package:hoonar/model/success_models/sound_list_model.dart';
import 'package:hoonar/model/success_models/store_payment_success_model.dart';
import 'package:hoonar/model/success_models/user_rank_success_model.dart';
import 'package:hoonar/model/success_models/wallet_transaction_list_model.dart';
import 'package:hoonar/model/success_models/wallet_transaction_list_model.dart';
import 'package:hoonar/model/success_models/wallet_transaction_list_model.dart';

import '../constants/utils.dart';
import '../model/success_models/follow_unfollow_success_model.dart';
import 'common_api_methods.dart';

class ContestService {
  final CommonApiMethods apiMethods = CommonApiMethods();

  // Services
  Future<LevelListModel> getLevelList(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<LevelListModel>(
      '$baseUrl$getLevelUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => LevelListModel.fromJson(data),
    );
  }

  Future<GuidelinesModel> getGuidelines() async {
    return apiMethods.sendRequest<GuidelinesModel>(
      '$baseUrl$getGuidelinesUrl',
      /*method: 'POST',
      accessToken: accessToken,
      data: requestModel.toJson(),*/
      fromJson: (data) => GuidelinesModel.fromJson(data),
    );
  }

  Future<StorePaymentSuccessModel> storePayment(
      StorePaymentRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<StorePaymentSuccessModel>(
      '$baseUrl$storePaymentUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => StorePaymentSuccessModel.fromJson(data),
    );
  }

  Future<LeaderboardListModel> getLeaderBoard(
      StorePaymentRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<LeaderboardListModel>(
      '$baseUrl$getHoonarLeaderboardUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => LeaderboardListModel.fromJson(data),
    );
  }

  Future<UserRankSuccessModel> getUserRank(
      StorePaymentRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<UserRankSuccessModel>(
      '$baseUrl$getUserRankUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => UserRankSuccessModel.fromJson(data),
    );
  }

  Future<HoonarStarSuccessModel> getHoonarStar(
      StorePaymentRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<HoonarStarSuccessModel>(
      '$baseUrl$getHoonarStarUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => HoonarStarSuccessModel.fromJson(data),
    );
  }

  Future<NewsEventSuccessModel> getNewsEvent(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<NewsEventSuccessModel>(
      '$baseUrl$getNewsEventsListUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => NewsEventSuccessModel.fromJson(data),
    );
  }

  Future<NewsEventSuccessModel> getUpcomingNewsEvent(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<NewsEventSuccessModel>(
      '$baseUrl$getUpcomingEventsUrl',
      /* method: 'POST',
      data: requestModel.toJson(),*/
      accessToken: accessToken,
      fromJson: (data) => NewsEventSuccessModel.fromJson(data),
    );
  }

  Future<RewardListModel> getRewardsList(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<RewardListModel>(
      '$baseUrl$getUserRewards',
      /* method: 'POST',
      data: requestModel.toJson(),*/
      accessToken: accessToken,
      fromJson: (data) => RewardListModel.fromJson(data),
    );
  }

  Future<WalletTransactionListModel> getWalletTransaction(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<WalletTransactionListModel>(
      '$baseUrl$getUserWalletTransactions',
      /* method: 'POST',
      data: requestModel.toJson(),*/
      accessToken: accessToken,
      fromJson: (data) => WalletTransactionListModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> claimRewards(
      CommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$claimRewardUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> uploadKycDocuments(
      UploadKycDocumentRequestModel requestModel, String accessToken) async {
    return apiMethods.sendMultipartRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$uploadKycDocumentUrl',
      method: 'POST',
      accessToken: accessToken,
      data: requestModel.toFormData(),
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<KycStatusModel> getKycStatus(
      UploadKycDocumentRequestModel requestModel, String accessToken) async {
    return apiMethods.sendMultipartRequest<KycStatusModel>(
      '$baseUrl$getKycStatusUrl',
      method: 'POST',
      accessToken: accessToken,
      data: requestModel.toFormData(),
      fromJson: (data) => KycStatusModel.fromJson(data),
    );
  }

  Future<SoundListModel> getSoundList(
      CommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<SoundListModel>(
      '$baseUrl$getSoundListUrl',
      // method: 'POST',
      accessToken: accessToken,
      data: requestModel.toJson(),
      fromJson: (data) => SoundListModel.fromJson(data),
    );
  }

  Future<SoundListModel> getSavedSoundList(
      CommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<SoundListModel>(
      '$baseUrl$getUserSavedSoundsUrl',
      // method: 'POST',
      accessToken: accessToken,
      data: requestModel.toJson(),
      fromJson: (data) => SoundListModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> savedUnSavedMusic(
      CommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$saveSoundUrl',
      method: 'POST',
      accessToken: accessToken,
      data: requestModel.toJson(),
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<DraftFeedListModel> getUserDraftFeedCategoryWise(
      CommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<DraftFeedListModel>(
      '$baseUrl$getUserDraftFeedCategoryWiseUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => DraftFeedListModel.fromJson(data),
    );
  }
}
