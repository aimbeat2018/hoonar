import 'package:hoonar/model/request_model/add_help_request_model.dart';
import 'package:hoonar/model/request_model/list_common_request_model.dart';
import 'package:hoonar/model/success_models/contact_details_model.dart';
import 'package:hoonar/model/success_models/contact_details_model.dart';
import 'package:hoonar/model/success_models/contact_details_model.dart';
import 'package:hoonar/model/success_models/devices_list_model.dart';
import 'package:hoonar/model/success_models/devices_list_model.dart';
import 'package:hoonar/model/success_models/devices_list_model.dart';
import 'package:hoonar/model/success_models/faq_list_model.dart';
import 'package:hoonar/model/success_models/faq_list_model.dart';
import 'package:hoonar/model/success_models/faq_list_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/follow_unfollow_success_model.dart';
import 'package:hoonar/model/success_models/help_issues_list_model.dart';
import 'package:hoonar/model/success_models/help_issues_list_model.dart';
import 'package:hoonar/model/success_models/help_issues_list_model.dart';
import 'package:hoonar/model/success_models/page_content_model.dart';

import '../constants/utils.dart';
import 'common_api_methods.dart';

class SettingService {
  final CommonApiMethods apiMethods = CommonApiMethods();

  // Services
  Future<PageContentModel> getPageContent(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<PageContentModel>(
      '$baseUrl$pageContentUrl',
      method: 'POST',
      accessToken: accessToken,
      data: requestModel.toJson(),
      fromJson: (data) => PageContentModel.fromJson(data),
    );
  }

  Future<ContactDetailsModel> getContactDetails(String accessToken) async {
    return apiMethods.sendRequest<ContactDetailsModel>(
      '$baseUrl$contactDetailsUrl',
      accessToken: accessToken,
      fromJson: (data) => ContactDetailsModel.fromJson(data),
    );
  }

  Future<DevicesListModel> getLoginDevices(String accessToken) async {
    return apiMethods.sendRequest<DevicesListModel>(
      '$baseUrl$userDevicesUrl',
      accessToken: accessToken,
      fromJson: (data) => DevicesListModel.fromJson(data),
    );
  }

  Future<FaqListModel> getFaqList(String accessToken) async {
    return apiMethods.sendRequest<FaqListModel>(
      '$baseUrl$getFaqUrl',
      accessToken: accessToken,
      fromJson: (data) => FaqListModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> removeDevices(
      ListCommonRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$removeDeviceUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }

  Future<HelpIssuesListModel> getHelpIssueList(String accessToken) async {
    return apiMethods.sendRequest<HelpIssuesListModel>(
      '$baseUrl$helpIssuesUrl',
      accessToken: accessToken,
      fromJson: (data) => HelpIssuesListModel.fromJson(data),
    );
  }

  Future<FollowUnfollowSuccessModel> addHelpRequest(
      AddHelpRequestModel requestModel, String accessToken) async {
    return apiMethods.sendRequest<FollowUnfollowSuccessModel>(
      '$baseUrl$storeHelpRequestUrl',
      method: 'POST',
      data: requestModel.toJson(),
      accessToken: accessToken,
      fromJson: (data) => FollowUnfollowSuccessModel.fromJson(data),
    );
  }
}
