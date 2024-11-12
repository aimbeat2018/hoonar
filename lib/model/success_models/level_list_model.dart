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
  int? isUnlocked;
  int? uploadedCount;
  int? pendingCount;

  LevelListData(
      {this.levelId,
      this.levelName,
      this.description,
      this.fees,
      this.isUnlocked,
      this.uploadedCount,
      this.pendingCount});

  LevelListData.fromJson(Map<String, dynamic> json) {
    levelId = json['level_id'];
    levelName = json['level_name'];
    description = json['description'];
    fees = json['fees'];
    isUnlocked = json['is_unlocked'];
    uploadedCount = json['uploaded_count'];
    pendingCount = json['pending_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level_id'] = this.levelId;
    data['level_name'] = this.levelName;
    data['description'] = this.description;
    data['fees'] = this.fees;
    data['is_unlocked'] = this.isUnlocked;
    data['uploaded_count'] = this.uploadedCount;
    data['pending_count'] = this.pendingCount;
    return data;
  }
}
