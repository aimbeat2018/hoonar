import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/post_list_success_model.dart';
import 'package:hoonar/services/home_page_service.dart';

import '../model/success_models/category_list_success_model.dart';

class HomeProvider extends ChangeNotifier {
  final HomePageService _homePageService = GetIt.I<HomePageService>();

  bool _isCategoryLoading = false;
  bool _isPostLoading = false;
  bool _isHomeLoading = false;
  String? _errorMessage;
  CategoryListSuccessModel? _categoryListSuccessModel;
  PostListSuccessModel? _postListSuccessModel;
  HomePostSuccessModel? _homePostSuccessModel;

  bool get isCategoryLoading => _isCategoryLoading;

  bool get isPostLoading => _isPostLoading;

  bool get isHomeLoading => _isHomeLoading;

  String? get errorMessage => _errorMessage;

  CategoryListSuccessModel? get categoryListSuccessModel =>
      _categoryListSuccessModel;

  PostListSuccessModel? get postListSuccessModel => _postListSuccessModel;

  HomePostSuccessModel? get homePostSuccessModel => _homePostSuccessModel;

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

  Future<void> getHomePostList(ListCommonRequestModel requestModel,String accessToken) async {
    _isHomeLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      HomePostSuccessModel successModel =
          await _homePageService.getHomePost(requestModel,accessToken);
      _homePostSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isHomeLoading = false;
      notifyListeners();
    }
  }
}
