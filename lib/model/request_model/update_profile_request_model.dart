class UpdateProfileRequestModel {
  String? fullName;
  String? userName;
  String? bio;
  String? dob;

  UpdateProfileRequestModel({this.fullName, this.userName, this.bio, this.dob});

  UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    userName = json['user_name'];
    bio = json['bio'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['bio'] = bio;
    data['dob'] = dob;
    return data;
  }
}
