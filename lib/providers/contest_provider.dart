import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_payment_request_model.dart';
import 'package:hoonar/model/success_models/guidelines_model.dart';
import 'package:hoonar/model/success_models/hoonar_star_success_model.dart';
import 'package:hoonar/model/success_models/leaderboard_list_model.dart';
import 'package:hoonar/model/success_models/level_list_model.dart';
import 'package:hoonar/model/success_models/store_payment_success_model.dart';
import 'package:hoonar/model/success_models/user_rank_success_model.dart';
import 'package:hoonar/services/contest_service.dart';

class ContestProvider extends ChangeNotifier {
  final ContestService _contestService = GetIt.I<ContestService>();

  ValueNotifier<int> isUserUnlockedNotifier = ValueNotifier(0);

  bool _isLevelLoading = false;
  bool _isGuidelinesLoading = false;
  bool _isStorePaymentLoading = false;
  bool _isLeaderboardLoading = false;
  bool _isUserRankLoading = false;
  bool _isHoonarStarLoading = false;
  String? _errorMessage;

  LevelListModel? _levelListModel;
  GuidelinesModel? _guidelinesModel;
  StorePaymentSuccessModel? _storePaymentSuccessModel;
  LeaderboardListModel? _leaderboardListModel;
  UserRankSuccessModel? _userRankSuccessModel;
  HoonarStarSuccessModel? _hoonarStarSuccessModel;
  List<LeaderboardListData> _leaderboardList = [];
  List<LeaderboardListData> _filteredLeaderboardList = [];

  bool get isLevelLoading => _isLevelLoading;

  bool get isGuidelinesLoading => _isGuidelinesLoading;

  bool get isStorePaymentLoading => _isStorePaymentLoading;

  bool get isLeaderboardLoading => _isLeaderboardLoading;

  bool get isUserRankLoading => _isUserRankLoading;

  bool get isHoonarStarLoading => _isHoonarStarLoading;

  String? get errorMessage => _errorMessage;

  LevelListModel? get levelListModel => _levelListModel;

  GuidelinesModel? get guidelinesModel => _guidelinesModel;

  LeaderboardListModel? get leaderboardListModel => _leaderboardListModel;

  UserRankSuccessModel? get userRankSuccessModel => _userRankSuccessModel;

  HoonarStarSuccessModel? get hoonarStarSuccessModel => _hoonarStarSuccessModel;

  StorePaymentSuccessModel? get storePaymentSuccessModel =>
      _storePaymentSuccessModel;

  List<LeaderboardListData> get leaderboardList => _leaderboardList;

  List<LeaderboardListData> get filteredLeaderboardList =>
      _filteredLeaderboardList;

  Future<void> getLevelList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isLevelLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      LevelListModel levelListModel =
          await _contestService.getLevelList(requestModel, accessToken);
      _levelListModel = levelListModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLevelLoading = false;
      notifyListeners();
    }
  }

  Future<void> getGuidelines(
      /*
      ListCommonRequestModel requestModel, String accessToken*/
      ) async {
    _isGuidelinesLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      GuidelinesModel successModel =
          await _contestService.getGuidelines(/*requestModel, accessToken*/);
      _guidelinesModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isGuidelinesLoading = false;
      notifyListeners();
    }
  }

  Future<void> storePayment(
      StorePaymentRequestModel requestModel, String accessToken) async {
    _isStorePaymentLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      StorePaymentSuccessModel successModel =
          await _contestService.storePayment(requestModel, accessToken);
      _storePaymentSuccessModel = successModel;
      if (successModel.status == '200') {
        getLevelList(
            ListCommonRequestModel(categoryId: requestModel.categoryId),
            accessToken);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isStorePaymentLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLeaderboardList(
      StorePaymentRequestModel requestModel, String accessToken) async {
    _isLeaderboardLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      LeaderboardListModel successModel =
          await _contestService.getLeaderBoard(requestModel, accessToken);
      _leaderboardListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLeaderboardLoading = false;
      notifyListeners();
    }
  }

  void setLeaderboardList(List<LeaderboardListData> list) {
    _leaderboardList = list;
    _filteredLeaderboardList = list;
    notifyListeners();
  }

  void filterLeaderboard(String searchTerm) {
    if (searchTerm.isEmpty) {
      _filteredLeaderboardList = _leaderboardList;
    } else {
      _filteredLeaderboardList = _leaderboardList.where((entry) {
        return entry.fullName!.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> getUserRankList(
      StorePaymentRequestModel requestModel, String accessToken) async {
    _isUserRankLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserRankSuccessModel successModel =
          await _contestService.getUserRank(requestModel, accessToken);
      _userRankSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isUserRankLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHoonarStarList(
      StorePaymentRequestModel requestModel, String accessToken) async {
    _isHoonarStarLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      HoonarStarSuccessModel successModel =
          await _contestService.getHoonarStar(requestModel, accessToken);
      _hoonarStarSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isHoonarStarLoading = false;
      notifyListeners();
    }
  }
}
