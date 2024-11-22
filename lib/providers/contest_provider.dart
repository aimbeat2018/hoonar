import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/common_request_model.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/request_model/store_payment_request_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/guidelines_model.dart';
import 'package:hoonar/model/success_models/hoonar_star_success_model.dart';
import 'package:hoonar/model/success_models/leaderboard_list_model.dart';
import 'package:hoonar/model/success_models/level_list_model.dart';
import 'package:hoonar/model/success_models/news_event_success_model.dart';
import 'package:hoonar/model/success_models/reward_list_model.dart';
import 'package:hoonar/model/success_models/sound_list_model.dart';
import 'package:hoonar/model/success_models/store_payment_success_model.dart';
import 'package:hoonar/model/success_models/user_rank_success_model.dart';
import 'package:hoonar/model/success_models/wallet_transaction_list_model.dart';
import 'package:hoonar/services/contest_service.dart';

import '../model/request_model/upload_kyc_document_request_model.dart';
import '../model/success_models/DraftFeedListModel.dart';
import '../model/success_models/kyc_status_model.dart';

class ContestProvider extends ChangeNotifier {
  final ContestService _contestService = GetIt.I<ContestService>();

  ValueNotifier<int> userKycStatusNotifier = ValueNotifier(0);
  ValueNotifier<int> addressProofStatusNotifier = ValueNotifier(0);
  ValueNotifier<int> idProofStatusNotifier = ValueNotifier(0);
  ValueNotifier<int> faceStatusNotifier = ValueNotifier(0);

  bool _isLevelLoading = false;
  bool _isGuidelinesLoading = false;
  bool _isStorePaymentLoading = false;
  bool _isLeaderboardLoading = false;
  bool _isUserRankLoading = false;
  bool _isHoonarStarLoading = false;
  bool _isNewsLoading = false;
  bool _isDocumentLoading = false;
  bool _isKycStatusLoading = false;
  bool _isRewardsLoading = false;
  bool _isWalletTransactionLoading = false;
  bool _isClaimRewardsLoading = false;
  bool _isSoundLoading = false;
  bool _isSavedSoundListLoading = false;
  bool _isSavedSoundLoading = false;
  bool _isDraftFeedLoading = false;
  String? _errorMessage;

  LevelListModel? _levelListModel;
  GuidelinesModel? _guidelinesModel;
  StorePaymentSuccessModel? _storePaymentSuccessModel;
  LeaderboardListModel? _leaderboardListModel;
  UserRankSuccessModel? _userRankSuccessModel;
  HoonarStarSuccessModel? _hoonarStarSuccessModel;
  NewsEventSuccessModel? _newsEventSuccessModel;
  NewsEventSuccessModel? _upcomingNewsEventSuccessModel;
  FollowUnfollowSuccessModel? _uploadDocumentSuccessModel;
  FollowUnfollowSuccessModel? _claimRewardsModel;
  FollowUnfollowSuccessModel? _savedSoundModel;
  KycStatusModel? _kycStatusModel;
  RewardListModel? _rewardListModel;
  SoundListModel? _soundListModel;
  SoundListModel? _savedSoundListModel;
  DraftFeedListModel? _draftFeedListModel;
  WalletTransactionListModel? _walletTransactionListModel;
  List<LeaderboardListData> _leaderboardList = [];
  List<LeaderboardListData> _filteredLeaderboardList = [];

  bool get isLevelLoading => _isLevelLoading;

  bool get isGuidelinesLoading => _isGuidelinesLoading;

  bool get isStorePaymentLoading => _isStorePaymentLoading;

  bool get isLeaderboardLoading => _isLeaderboardLoading;

  bool get isUserRankLoading => _isUserRankLoading;

  bool get isHoonarStarLoading => _isHoonarStarLoading;

  bool get isSavedSoundLoading => _isSavedSoundLoading;

  bool get isDraftFeedLoading => _isDraftFeedLoading;

  bool get isSavedSoundListLoading => _isSavedSoundListLoading;

  bool get isWalletTransactionLoading => _isWalletTransactionLoading;

  bool get isNewsLoading => _isNewsLoading;

  bool get isRewardsLoading => _isRewardsLoading;

  bool get isClaimRewardsLoading => _isClaimRewardsLoading;

  bool get isDocumentLoading => _isDocumentLoading;

  bool get isKycStatusLoading => _isKycStatusLoading;

  bool get isSoundLoading => _isSoundLoading;

  String? get errorMessage => _errorMessage;

  LevelListModel? get levelListModel => _levelListModel;

  SoundListModel? get savedSoundListModel => _savedSoundListModel;

  WalletTransactionListModel? get walletTransactionListModel =>
      _walletTransactionListModel;

  GuidelinesModel? get guidelinesModel => _guidelinesModel;

  LeaderboardListModel? get leaderboardListModel => _leaderboardListModel;

  UserRankSuccessModel? get userRankSuccessModel => _userRankSuccessModel;

  HoonarStarSuccessModel? get hoonarStarSuccessModel => _hoonarStarSuccessModel;

  DraftFeedListModel? get draftFeedListModel => _draftFeedListModel;

  NewsEventSuccessModel? get newsEventSuccessModel => _newsEventSuccessModel;

  KycStatusModel? get kycStatusModel => _kycStatusModel;

  RewardListModel? get rewardListModel => _rewardListModel;

  SoundListModel? get soundListModel => _soundListModel;

  NewsEventSuccessModel? get upcomingNewsEventSuccessModel =>
      _upcomingNewsEventSuccessModel;

  FollowUnfollowSuccessModel? get uploadDocumentSuccessModel =>
      _uploadDocumentSuccessModel;

  FollowUnfollowSuccessModel? get claimRewardsModel => _claimRewardsModel;

  FollowUnfollowSuccessModel? get savedSoundModel => _savedSoundModel;

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

  Future<void> getNewsEventList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isNewsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      NewsEventSuccessModel successModel =
          await _contestService.getNewsEvent(requestModel, accessToken);
      _newsEventSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isNewsLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUpcomingNewsEventList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isNewsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      NewsEventSuccessModel successModel =
          await _contestService.getUpcomingNewsEvent(requestModel, accessToken);
      _upcomingNewsEventSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isNewsLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadKycDocuments(
      UploadKycDocumentRequestModel requestModel, String accessToken) async {
    _isDocumentLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _contestService.uploadKycDocuments(requestModel, accessToken);
      _uploadDocumentSuccessModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDocumentLoading = false;
      notifyListeners();
    }
  }

  Future<void> getKycStatus(
      CommonRequestModel requestModel, String accessToken) async {
    _isKycStatusLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      KycStatusModel successModel =
          await _contestService.getKycStatus(requestModel, accessToken);
      _kycStatusModel = successModel;
      if (successModel.status == "200" && successModel.data != null) {
        userKycStatusNotifier.value = successModel.data!.isVerified ?? 0;
        addressProofStatusNotifier.value =
            successModel.data!.addressProof! ?? 0;
        idProofStatusNotifier.value = successModel.data!.iDProof ?? 0;
        faceStatusNotifier.value = successModel.data!.face ?? 0;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isKycStatusLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRewardsList(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isRewardsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      RewardListModel successModel =
          await _contestService.getRewardsList(requestModel, accessToken);
      _rewardListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isRewardsLoading = false;
      notifyListeners();
    }
  }

  Future<void> claimRewards(
      CommonRequestModel requestModel, String accessToken) async {
    _isClaimRewardsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _contestService.claimRewards(requestModel, accessToken);
      _claimRewardsModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isClaimRewardsLoading = false;
      notifyListeners();
    }
  }

  Future<void> getWalletTransaction(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isWalletTransactionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      WalletTransactionListModel successModel =
          await _contestService.getWalletTransaction(requestModel, accessToken);
      _walletTransactionListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isWalletTransactionLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSoundList(
      CommonRequestModel requestModel, String accessToken) async {
    _isSoundLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SoundListModel successModel =
          await _contestService.getSoundList(requestModel, accessToken);
      _soundListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSoundLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSavedSoundList(
      CommonRequestModel requestModel, String accessToken) async {
    _isSavedSoundListLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SoundListModel successModel =
          await _contestService.getSavedSoundList(requestModel, accessToken);
      _savedSoundListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSavedSoundListLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSound(
      CommonRequestModel requestModel, String accessToken) async {
    _isSavedSoundLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _contestService.savedUnSavedMusic(requestModel, accessToken);
      _savedSoundModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSavedSoundLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserDraftFeedCategoryWise(
      CommonRequestModel requestModel, String accessToken) async {
    _isDraftFeedLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      DraftFeedListModel successModel = await _contestService
          .getUserDraftFeedCategoryWise(requestModel, accessToken);
      _draftFeedListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDraftFeedLoading = false;
      notifyListeners();
    }
  }
}
