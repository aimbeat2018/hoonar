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
  String? createdAt;
  String? updatedAt;

  LevelListData(
      {this.levelId,
      this.levelName,
      this.description,
      this.fees,
      this.createdAt,
      this.updatedAt});

  LevelListData.fromJson(Map<String, dynamic> json) {
    levelId = json['level_id'];
    levelName = json['level_name'];
    description = json['description'];
    fees = json['fees'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level_id'] = levelId;
    data['level_name'] = levelName;
    data['description'] = description;
    data['fees'] = fees;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
