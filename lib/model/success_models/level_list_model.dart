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
    data['status'] = status;
    data['message'] = message;
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
  int? isPreviousLevelWin;
  int? rank;
  int? voteScore;

  LevelListData({
    this.levelId,
    this.levelName,
    this.description,
    this.fees,
    this.topRankCount,
    this.winnerCount,
    this.isUnlocked,
    this.hasUploaded,
    this.hasWon,
    this.isPreviousLevelWin,
    this.rank,
    this.voteScore,
  });

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
    isPreviousLevelWin = json['is_previous_level_win'];
    rank = json['rank'];
    voteScore = json['vote_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level_id'] = levelId;
    data['level_name'] = levelName;
    data['description'] = description;
    data['fees'] = fees;
    data['top_rank_count'] = topRankCount;
    data['winner_count'] = winnerCount;
    data['is_unlocked'] = isUnlocked;
    data['has_uploaded'] = hasUploaded;
    data['has_won'] = hasWon;
    data['is_previous_level_win'] = isPreviousLevelWin;
    data['rank'] = rank;
    data['vote_score'] = voteScore;
    return data;
  }
}
