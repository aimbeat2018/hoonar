class UserRankSuccessModel {
  int? status;
  String? message;
  UserRankData? data;

  UserRankSuccessModel({this.status, this.message, this.data});

  UserRankSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UserRankData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserRankData {
  int? rank;
  String? userName;
  String? fullName;
  int? totalVotes;
  String? categoryName;
  String? levelName;
  String? message;

  UserRankData(
      {this.rank,
      this.userName,
      this.fullName,
      this.totalVotes,
      this.categoryName,
      this.levelName,
      this.message});

  UserRankData.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    userName = json['user_name'];
    fullName = json['full_name'];
    totalVotes = json['total_votes'];
    categoryName = json['category_name'];
    levelName = json['level_name'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['user_name'] = userName;
    data['full_name'] = fullName;
    data['total_votes'] = totalVotes;
    data['category_name'] = categoryName;
    data['level_name'] = levelName;
    data['message'] = message;
    return data;
  }
}
