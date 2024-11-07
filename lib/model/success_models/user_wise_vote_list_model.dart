class UserWiseVoteListModel {
  String? status;
  String? message;
  List<UserWiseVoteList>? data;

  UserWiseVoteListModel({this.status, this.message, this.data});

  UserWiseVoteListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserWiseVoteList>[];
      json['data'].forEach((v) {
        data!.add(UserWiseVoteList.fromJson(v));
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

class UserWiseVoteList {
  int? levelId;
  String? levelName;
  String? categoryName;
  int? voteCount;

  UserWiseVoteList(
      {this.levelId, this.levelName, this.categoryName, this.voteCount});

  UserWiseVoteList.fromJson(Map<String, dynamic> json) {
    levelId = json['level_id'];
    levelName = json['level_name'];
    categoryName = json['category_name'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level_id'] = levelId;
    data['level_name'] = levelName;
    data['category_name'] = categoryName;
    data['vote_count'] = voteCount;
    return data;
  }
}
