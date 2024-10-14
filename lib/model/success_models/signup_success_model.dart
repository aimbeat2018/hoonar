class SignupSuccessModel {
  int? status;
  String? message;
  Data? data;

  SignupSuccessModel({this.status, this.message, this.data});

  SignupSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  String? bio;
  String? profileCategory;
  String? fbUrl;
  String? instaUrl;
  String? youtubeUrl;
  int? status;
  int? freezOrNot;
  String? dob;
  int? cityId;
  int? stateId;
  String? pincode;
  String? college;
  String? cityName;
  String? stateName;
  String? token;
  int? followersCount;
  int? followingCount;
  int? myPostLikes;
  String? profileCategoryName;

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
      this.isNotification,
      this.myWallet,
      this.bio,
      this.profileCategory,
      this.fbUrl,
      this.instaUrl,
      this.youtubeUrl,
      this.status,
      this.freezOrNot,
      this.dob,
      this.cityId,
      this.stateId,
      this.pincode,
      this.college,
      this.cityName,
      this.stateName,
      this.token,
      this.followersCount,
      this.followingCount,
      this.myPostLikes,
      this.profileCategoryName});

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
    bio = json['bio'];
    profileCategory = json['profile_category'];
    fbUrl = json['fb_url'];
    instaUrl = json['insta_url'];
    youtubeUrl = json['youtube_url'];
    status = json['status'];
    freezOrNot = json['freez_or_not'];
    dob = json['dob'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    pincode = json['pincode'];
    college = json['college'];
    cityName = json['city_name'];
    stateName = json['state_name'];
    token = json['token'];
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    myPostLikes = json['my_post_likes'];
    profileCategoryName = json['profile_category_name'];
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
    data['bio'] = bio;
    data['profile_category'] = profileCategory;
    data['fb_url'] = fbUrl;
    data['insta_url'] = instaUrl;
    data['youtube_url'] = youtubeUrl;
    data['status'] = status;
    data['freez_or_not'] = freezOrNot;
    data['dob'] = dob;
    data['city_id'] = cityId;
    data['state_id'] = stateId;
    data['pincode'] = pincode;
    data['college'] = college;
    data['city_name'] = cityName;
    data['state_name'] = stateName;
    data['token'] = token;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    data['my_post_likes'] = myPostLikes;
    data['profile_category_name'] = profileCategoryName;
    return data;
  }
}
