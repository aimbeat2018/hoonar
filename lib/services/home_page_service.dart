import 'package:hoonar/model/success_models/category_list_success_model.dart';

import '../constants/utils.dart';
import 'common_api_methods.dart';

class HomePageService {
  final CommonApiMethods apiMethods = CommonApiMethods();

  // Services
  Future<CategoryListSuccessModel> getCategoryList() async {
    return apiMethods.sendRequest<CategoryListSuccessModel>(
      '$baseUrl$getCategoryData',
      fromJson: (data) => CategoryListSuccessModel.fromJson(data),
    );
  }
}
