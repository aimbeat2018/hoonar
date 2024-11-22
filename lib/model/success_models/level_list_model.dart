class LevelListModel {
  String? status;
  String? message;
  List<LevelListData>? data;

  LevelListModel({this.status, this.message, this.data});

  LevelListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LevelListData>[];
      json['data'].forEach((v) {
        data!.add(LevelListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LevelListData {
  int? levelId;
  String? levelName;
  String? description;
  int? fees;
  int? topRankCount;
  int? winnerCount;
  int? isUnlocked;
  int? hasUploaded;
  int? hasWon;

  LevelListData(
      {this.levelId,
      this.levelName,
      this.description,
      this.fees,
      this.topRankCount,
      this.winnerCount,
      this.isUnlocked,
      this.hasUploaded,
      this.hasWon});

  LevelListData.fromJson(Map<String, dynamic> json) {
    levelId = json['level_id'];
    levelName = json['level_name'];
    description = json['description'];
    fees = json['fees'];
    topRankCount = json['top_rank_count'];
    winnerCount = json['winner_count'];
    isUnlocked = json['is_unlocked'];
    hasUploaded = json['has_uploaded'];
    hasWon = json['has_won'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level_id'] = this.levelId;
    data['level_name'] = this.levelName;
    data['description'] = this.description;
    data['fees'] = this.fees;
    data['top_rank_count'] = this.topRankCount;
    data['winner_count'] = this.winnerCount;
    data['is_unlocked'] = this.isUnlocked;
    data['has_uploaded'] = this.hasUploaded;
    data['has_won'] = this.hasWon;
    return data;
  }
}
