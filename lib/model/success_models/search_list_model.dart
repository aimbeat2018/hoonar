class SearchListModel {
  String? status;
  String? message;
  List<SearchData>? data;

  SearchListModel({this.status, this.message, this.data});

  SearchListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SearchData>[];
      json['data'].forEach((v) {
        data!.add(SearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchData {
  int? userId;
  String? fullName;
  String? userName;
  String? userProfile;
  int? isVerify;

  SearchData(
      {this.userId,
      this.fullName,
      this.userName,
      this.userProfile,
      this.isVerify});

  SearchData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
    isVerify = json['is_verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['user_profile'] = userProfile;
    data['is_verify'] = isVerify;
    return data;
  }
}
