class FollowUnfollowSuccessModel {
  String? status;
  String? message;
  int? followStatus;

  FollowUnfollowSuccessModel({this.status, this.message, this.followStatus});

  FollowUnfollowSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    followStatus = json['follow_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['follow_status'] = followStatus;
    return data;
  }
}
