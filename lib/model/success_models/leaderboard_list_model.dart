class LeaderboardListModel {
  int? status;
  String? message;
  List<LeaderboardListData>? data;

  LeaderboardListModel({this.status, this.message, this.data});

  LeaderboardListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LeaderboardListData>[];
      json['data'].forEach((v) {
        data!.add(LeaderboardListData.fromJson(v));
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

class LeaderboardListData {
  int? userId;
  String? userName;
  String? fullName;
  int? totalVotes;
  int? categoryId;
  int? levelId;
  int? postId;
  int? rank;

  LeaderboardListData(
      {this.userId,
      this.userName,
      this.fullName,
      this.totalVotes,
      this.categoryId,
      this.levelId,
      this.postId,
      this.rank});

  LeaderboardListData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    fullName = json['full_name'];
    totalVotes = json['total_votes'];
    categoryId = json['category_id'];
    levelId = json['level_id'];
    postId = json['post_id'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['full_name'] = fullName;
    data['total_votes'] = totalVotes;
    data['category_id'] = categoryId;
    data['level_id'] = levelId;
    data['post_id'] = postId;
    data['rank'] = rank;
    return data;
  }
}
