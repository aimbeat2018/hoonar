class GetFollowersListModel {
  String? status;
  String? message;
  List<FollowersData>? data;

  GetFollowersListModel({this.status, this.message, this.data});

  GetFollowersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FollowersData>[];
      json['data'].forEach((v) {
        data!.add(FollowersData.fromJson(v));
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

class FollowersData {
  int? followerId;
  int? fromUserId;
  int? toUserId;
  String? fullName;
  String? userName;
  String? userProfile;
  int? isVerify;
  String? createdDate;
  int? followersCount;
  int? followingCount;
  int? myPostLikes;
  int? myPostCount;
  int? isFollow;

  FollowersData(
      {this.followerId,
      this.fromUserId,
      this.toUserId,
      this.fullName,
      this.userName,
      this.userProfile,
      this.isVerify,
      this.createdDate,
      this.followersCount,
      this.followingCount,
      this.myPostLikes,
      this.isFollow,
      this.myPostCount});

  FollowersData.fromJson(Map<String, dynamic> json) {
    followerId = json['follower_id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    fullName = json['full_name'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
    isVerify = json['is_verify'];
    createdDate = json['created_date'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    myPostLikes = json['my_post_likes'];
    myPostCount = json['my_post_count'];
    isFollow = json['is_follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['follower_id'] = followerId;
    data['from_user_id'] = fromUserId;
    data['to_user_id'] = toUserId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['user_profile'] = userProfile;
    data['is_verify'] = isVerify;
    data['created_date'] = createdDate;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['my_post_likes'] = myPostLikes;
    data['my_post_count'] = myPostCount;
    data['is_follow'] = isFollow;
    return data;
  }
}
