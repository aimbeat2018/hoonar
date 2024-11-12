import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_payment_request_model.dart';
import 'package:hoonar/model/success_models/guidelines_model.dart';
import 'package:hoonar/model/success_models/hoonar_star_success_model.dart';
import 'package:hoonar/model/success_models/hoonar_star_success_model.dart';
import 'package:hoonar/model/success_models/hoonar_star_success_model.dart';
import 'package:hoonar/model/success_models/leaderboard_list_model.dart';
import 'package:hoonar/model/success_models/leaderboard_list_model.dart';
import 'package:hoonar/model/success_models/leaderboard_list_model.dart';
import 'package:hoonar/model/success_models/level_list_model.dart';
import 'package:hoonar/model/success_models/store_payment_success_model.dart';
import 'package:hoonar/model/success_models/user_rank_success_model.dart';
import 'package:hoonar/model/success_models/user_rank_success_model.dart';
import 'package:hoonar/model/success_models/user_rank_success_model.dart';

import '../constants/utils.dart';
import 'common_api_methods.dart';

class ContestService {
  final CommonApiMethods apiMethods = CommonApiMethods();

  // Services
  Future<LevelListModel> getLevelList(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<LevelListModel>(
      '$baseUrl$getLevelUrl',
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
}
