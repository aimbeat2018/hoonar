class CommonRequestModel {
  String? userId;
  String? gender;
  String? avatarId;
  String? rewardId;
  String? soundId;

  CommonRequestModel(
      {this.userId, this.gender, this.avatarId, this.rewardId, this.soundId});

  CommonRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    gender = json['gender'];
    avatarId = json['avatar_id'];
    rewardId = json['reward_id'];
    soundId = json['sound_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['gender'] = gender;
    data['avatar_id'] = avatarId;
    data['reward_id'] = rewardId;
    data['sound_id'] = soundId;
    return data;
  }
}
