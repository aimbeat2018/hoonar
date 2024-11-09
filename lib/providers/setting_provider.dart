import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hoonar/model/request_model/add_help_request_model.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/devices_list_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/help_issues_list_model.dart';
import 'package:hoonar/services/setting_service.dart';

import '../model/success_models/page_content_model.dart';

class SettingProvider extends ChangeNotifier {
  final SettingService _settingService = GetIt.I<SettingService>();
  ValueNotifier<DevicesListModel?> deviceListNotifier = ValueNotifier(null);

  bool _isPageLoading = false;
  bool _isDevicesLoading = false;
  bool _isRemoveDevicesLoading = false;
  bool _isAddHelpRequestLoading = false;
  String? _errorMessage;

  PageContentModel? _pageContentModel;
  DevicesListModel? _devicesListModel;
  FollowUnfollowSuccessModel? _removeDeviceModel;
  FollowUnfollowSuccessModel? _addHelpRequest;
  HelpIssuesListModel? _helpIssuesListModel;

  bool get isPageLoading => _isPageLoading;

  bool get isDevicesLoading => _isDevicesLoading;

  bool get isRemoveDevicesLoading => _isRemoveDevicesLoading;

  bool get isAddHelpRequestLoading => _isAddHelpRequestLoading;

  String? get errorMessage => _errorMessage;

  PageContentModel? get pageContentModel => _pageContentModel;

  DevicesListModel? get devicesListModel => _devicesListModel;

  FollowUnfollowSuccessModel? get removeDeviceModel => _removeDeviceModel;

  FollowUnfollowSuccessModel? get addHelpRequestModel => _addHelpRequest;

  HelpIssuesListModel? get helpIssuesListModel => _helpIssuesListModel;

  Future<void> getPageContent(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isPageLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      PageContentModel successModel =
          await _settingService.getPageContent(requestModel, accessToken);
      _pageContentModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isPageLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLoginDevices(String accessToken) async {
    _isDevicesLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      DevicesListModel successModel =
          await _settingService.getLoginDevices(accessToken);
      _devicesListModel = successModel;
      deviceListNotifier.value = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDevicesLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeDevice(
      ListCommonRequestModel requestModel, String accessToken) async {
    _isRemoveDevicesLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _settingService.removeDevices(requestModel, accessToken);
      _removeDeviceModel = successModel;
      if (successModel.status == '200') {
        getLoginDevices(accessToken);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isRemoveDevicesLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHelpIssueList(String accessToken) async {
    _isDevicesLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      HelpIssuesListModel successModel =
          await _settingService.getHelpIssueList(accessToken);
      _helpIssuesListModel = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isDevicesLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHelpRequest(
      AddHelpRequestModel requestModel, String accessToken) async {
    _isAddHelpRequestLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      FollowUnfollowSuccessModel successModel =
          await _settingService.addHelpRequest(requestModel, accessToken);
      _addHelpRequest = successModel;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isAddHelpRequestLoading = false;
      notifyListeners();
    }
  }
}
