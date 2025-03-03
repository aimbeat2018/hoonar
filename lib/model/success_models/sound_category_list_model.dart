class SoundCategoryListModel {
  String? status;
  String? message;
  List<SoundCategoryData>? data;

  SoundCategoryListModel({this.status, this.message, this.data});

  SoundCategoryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SoundCategoryData>[];
      json['data'].forEach((v) {
        data!.add(new SoundCategoryData.fromJson(v));
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

class SoundCategoryData {
  int? soundCategoryId;
  String? soundCategoryName;

  SoundCategoryData({this.soundCategoryId, this.soundCategoryName});

  SoundCategoryData.fromJson(Map<String, dynamic> json) {
    soundCategoryId = json['sound_category_id'];
    soundCategoryName = json['sound_category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sound_category_id'] = soundCategoryId;
    data['sound_category_name'] = soundCategoryName;
    return data;
  }
}
