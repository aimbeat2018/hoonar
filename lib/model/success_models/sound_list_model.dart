class SoundListModel {
  String? status;
  String? message;
  List<SoundListData>? data;

  SoundListModel({this.status, this.message, this.data});

  SoundListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SoundListData>[];
      json['data'].forEach((v) {
        data!.add(SoundListData.fromJson(v));
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

class SoundListData {
  int? soundCategoryId;
  String? soundCategoryName;
  String? soundCategoryProfile;
  List<SoundList>? soundList;

  SoundListData(
      {this.soundCategoryId,
      this.soundCategoryName,
      this.soundCategoryProfile,
      this.soundList});

  SoundListData.fromJson(Map<String, dynamic> json) {
    soundCategoryId = json['sound_category_id'];
    soundCategoryName = json['sound_category_name'];
    soundCategoryProfile = json['sound_category_profile'];
    if (json['sound_list'] != null) {
      soundList = <SoundList>[];
      json['sound_list'].forEach((v) {
        soundList!.add(SoundList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sound_category_id'] = soundCategoryId;
    data['sound_category_name'] = soundCategoryName;
    data['sound_category_profile'] = soundCategoryProfile;
    if (soundList != null) {
      data['sound_list'] = soundList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SoundList {
  int? soundId;
  int? soundCategoryId;
  String? soundTitle;
  String? sound;
  String? duration;
  String? singer;
  String? soundImage;
  String? addedBy;
  int? isDeleted;
  int? isSaved;
  String? createdAt;
  String? updatedAt;
  String? trimAudioPath;
  String? isLocalSong;

  SoundList(
      {this.soundId,
      this.soundCategoryId,
      this.soundTitle,
      this.sound,
      this.duration,
      this.singer,
      this.soundImage,
      this.addedBy,
      this.isDeleted,
      this.createdAt,
      this.isSaved,
      this.trimAudioPath,
      this.isLocalSong = "1", // 1- song from api , 0- song from local
      this.updatedAt});

  SoundList.fromJson(Map<String, dynamic> json) {
    soundId = json['sound_id'];
    soundCategoryId = json['sound_category_id'];
    soundTitle = json['sound_title'];
    sound = json['sound'];
    duration = json['duration'];
    singer = json['singer'];
    soundImage = json['sound_image'];
    addedBy = json['added_by'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSaved = json['is_saved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sound_id'] = soundId;
    data['sound_category_id'] = soundCategoryId;
    data['sound_title'] = soundTitle;
    data['sound'] = sound;
    data['duration'] = duration;
    data['singer'] = singer;
    data['sound_image'] = soundImage;
    data['added_by'] = addedBy;
    data['is_deleted'] = isDeleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_saved'] = isSaved;
    return data;
  }
}
