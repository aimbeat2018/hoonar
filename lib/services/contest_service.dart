import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/level_list_model.dart';

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
}
