class CommonRequestModel {
  String? userId;
  String? myUserId;
  String? gender;
  String? avatarId;
  String? rewardId;
  String? levelId;
  String? soundId;
  String? categoryId;
  String? deviceToken;
  String? notificationStatus;
  String? amount;

  CommonRequestModel(
      {this.userId,
      this.myUserId,
      this.gender,
      this.avatarId,
      this.rewardId,
      this.soundId,
      this.categoryId,
      this.levelId,
      this.notificationStatus,
      this.amount,
      this.deviceToken});

  CommonRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    myUserId = json['my_user_id'];
    gender = json['gender'];
    avatarId = json['avatar_id'];
    rewardId = json['reward_id'];
    soundId = json['sound_id'];
    categoryId = json['category_id'];
    deviceToken = json['device_token'];
    notificationStatus = json['notification_status'];
    amount = json['amount'];
    levelId = json['level_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['my_user_id'] = myUserId;
    data['gender'] = gender;
    data['avatar_id'] = avatarId;
    data['reward_id'] = rewardId;
    data['sound_id'] = soundId;
    data['category_id'] = categoryId;
    data['device_token'] = deviceToken;
    data['notification_status'] = notificationStatus;
    data['amount'] = amount;
    data['level_id'] = levelId;
    return data;
  }
}
