import 'package:hoonar/model/success_models/home_post_success_model.dart';

class ProfileSuccessModel {
  String? status;
  String? message;
  Data? data;

  ProfileSuccessModel({this.status, this.message, this.data});

  ProfileSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? fullName;
  String? userName;
  String? userEmail;
  String? userMobileNo;
  String? password;
  String? userProfile;
  String? loginType;
  String? identity;
  int? platform;
  String? deviceToken;
  int? isVerify;
  int? isNotification;
  int? myWallet;
  int? isBlock;
  String? bio;
  String? profileCategory;
  String? fbUrl;
  String? instaUrl;
  String? youtubeUrl;
  String? dob;
  int? cityId;
  int? stateId;
  String? pincode;
  String? college;
  int? isFollowingEachOther;
  int? followersCount;
  int? totalVotes;
  int? followingCount;
  int? myPostLikes;
  String? profileCategoryName;
  int? isFollowing;
  int? blockOrNot;
  List<PostsListData>? posts;
  List<PostsListData>? drafts;
  List<PostsListData>? hoonarStar;

  Data(
      {this.userId,
      this.fullName,
      this.userName,
      this.userEmail,
      this.userMobileNo,
      this.password,
      this.userProfile,
      this.loginType,
      this.identity,
      this.platform,
      this.deviceToken,
      this.isVerify,
      this.isBlock,
      this.isNotification,
      this.myWallet,
      this.bio,
      this.profileCategory,
      this.fbUrl,
      this.instaUrl,
      this.youtubeUrl,
      this.dob,
      this.cityId,
      this.stateId,
      this.pincode,
      this.college,
      this.isFollowingEachOther,
      this.followersCount,
      this.followingCount,
      this.totalVotes,
      this.myPostLikes,
      this.profileCategoryName,
      this.isFollowing,
      this.blockOrNot,
      this.posts,
      this.hoonarStar,
      this.drafts});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userMobileNo = json['user_mobile_no'];
    password = json['password'];
    userProfile = json['user_profile'];
    loginType = json['login_type'];
    identity = json['identity'];
    platform = json['platform'];
    deviceToken = json['device_token'];
    isVerify = json['is_verify'];
    isNotification = json['is_notification'];
    myWallet = json['my_wallet'];
    isBlock = json['is_block'];
    bio = json['bio'];
    profileCategory = json['profile_category'];
    fbUrl = json['fb_url'];
    instaUrl = json['insta_url'];
    youtubeUrl = json['youtube_url'];
    dob = json['dob'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    pincode = json['pincode'];
    college = json['college'];
    isFollowingEachOther = json['is_following_eachOther'];
    followersCount = json['followers_count'];
    totalVotes = json['total_votes'];
    followingCount = json['following_count'];
    myPostLikes = json['my_post_likes'];
    profileCategoryName = json['profile_category_name'];
    isFollowing = json['is_following'];
    blockOrNot = json['block_or_not'];
    if (json['posts'] != null) {
      posts = <PostsListData>[];
      json['posts'].forEach((v) {
        posts!.add(PostsListData.fromJson(v));
      });
    }
    if (json['drafts'] != null) {
      drafts = <PostsListData>[];
      json['drafts'].forEach((v) {
        drafts!.add(PostsListData.fromJson(v));
      });
    }
    if (json['hoonar_star'] != null) {
      hoonarStar = <PostsListData>[];
      json['hoonar_star'].forEach((v) {
        hoonarStar!.add(PostsListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_mobile_no'] = userMobileNo;
    data['password'] = password;
    data['user_profile'] = userProfile;
    data['login_type'] = loginType;
    data['identity'] = identity;
    data['platform'] = platform;
    data['device_token'] = deviceToken;
    data['is_verify'] = isVerify;
    data['is_notification'] = isNotification;
    data['my_wallet'] = myWallet;
    data['is_block'] = isBlock;
    data['bio'] = bio;
    data['profile_category'] = profileCategory;
    data['fb_url'] = fbUrl;
    data['insta_url'] = instaUrl;
    data['youtube_url'] = youtubeUrl;
    data['dob'] = dob;
    data['city_id'] = cityId;
    data['state_id'] = stateId;
    data['pincode'] = pincode;
    data['college'] = college;
    data['is_following_eachOther'] = isFollowingEachOther;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['total_votes'] = totalVotes;
    data['my_post_likes'] = myPostLikes;
    data['profile_category_name'] = profileCategoryName;
    data['is_following'] = isFollowing;
    data['block_or_not'] = blockOrNot;
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    if (drafts != null) {
      data['drafts'] = drafts!.map((v) => v.toJson()).toList();
    }
    if (hoonarStar != null) {
      data['hoonar_star'] = hoonarStar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
