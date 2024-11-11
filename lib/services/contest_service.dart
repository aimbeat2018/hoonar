import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/guidelines_model.dart';
import 'package:hoonar/model/success_models/guidelines_model.dart';
import 'package:hoonar/model/success_models/guidelines_model.dart';
import 'package:hoonar/model/success_models/level_list_model.dart';

import '../constants/utils.dart';
import '../model/success_models/page_content_model.dart';
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
}
