class UserSearchHistoryModel {
  String? status;
  String? message;
  List<UserSearchHistory>? userSearchHistory;

  UserSearchHistoryModel({this.status, this.message, this.userSearchHistory});

  UserSearchHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      userSearchHistory = <UserSearchHistory>[];
      json['data'].forEach((v) {
        userSearchHistory!.add(UserSearchHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (userSearchHistory != null) {
      data['data'] = userSearchHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserSearchHistory {
  int? searchHistoryId;
  int? userId;
  int? searchedUserId;
  String? searchedFullName;
  String? searchedUserName;
  String? searchedAt;

  UserSearchHistory(
      {this.searchHistoryId,
      this.userId,
      this.searchedUserId,
      this.searchedFullName,
      this.searchedUserName,
      this.searchedAt});

  UserSearchHistory.fromJson(Map<String, dynamic> json) {
    searchHistoryId = json['search_history_id'];
    userId = json['user_id'];
    searchedUserId = json['searched_user_id'];
    searchedFullName = json['searched_full_name'];
    searchedUserName = json['searched_user_name'];
    searchedAt = json['searched_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search_history_id'] = searchHistoryId;
    data['user_id'] = userId;
    data['searched_user_id'] = searchedUserId;
    data['searched_full_name'] = searchedFullName;
    data['searched_user_name'] = searchedUserName;
    data['searched_at'] = searchedAt;
    return data;
  }
}
