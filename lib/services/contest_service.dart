import 'package:hoonar/model/success_models/level_list_model.dart';

import '../constants/utils.dart';
import 'common_api_methods.dart';

class ContestService {
  final CommonApiMethods apiMethods = CommonApiMethods();

  // Services
  Future<LevelListModel> getLevelList() async {
    return apiMethods.sendRequest<LevelListModel>(
      '$baseUrl$getLevelUrl',
      fromJson: (data) => LevelListModel.fromJson(data),
    );
  }
}
