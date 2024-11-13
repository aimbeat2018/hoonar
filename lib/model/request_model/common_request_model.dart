class CommonRequestModel {
  String? userId;
  String? gender;
  String? avatarId;

  CommonRequestModel({this.userId, this.gender, this.avatarId});

  CommonRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    gender = json['gender'];
    avatarId = json['avatar_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['gender'] = gender;
    data['avatar_id'] = avatarId;
    return data;
  }
}
