class AvatarListModel {
  String? status;
  String? message;
  List<AvatarListData>? data;

  AvatarListModel({this.status, this.message, this.data});

  AvatarListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AvatarListData>[];
      json['data'].forEach((v) {
        data!.add(AvatarListData.fromJson(v));
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

class AvatarListData {
  int? avatarId;
  String? avatarUrl;
  String? description;
  int? isSelected;

  AvatarListData(
      {this.avatarId, this.avatarUrl, this.description, this.isSelected});

  AvatarListData.fromJson(Map<String, dynamic> json) {
    avatarId = json['avatar_id'];
    avatarUrl = json['avatar_url'];
    description = json['description'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar_id'] = avatarId;
    data['avatar_url'] = avatarUrl;
    data['description'] = description;
    data['is_selected'] = isSelected;
    return data;
  }
}
