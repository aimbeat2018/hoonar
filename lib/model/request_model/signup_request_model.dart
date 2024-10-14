class SignupRequestModel {
  String? fullName;
  String? userEmail;
  String? mobileNo;
  String? deviceToken;
  String? identity;
  String? loginType;
  String? platform;
  String? dob;
  String? cityId;
  String? stateId;
  String? pincode;
  String? college;
  String? password;

  SignupRequestModel(
      {this.fullName,
      this.userEmail,
      this.mobileNo,
      this.deviceToken,
      this.identity,
      this.loginType,
      this.platform,
      this.dob,
      this.cityId,
      this.stateId,
      this.pincode,
      this.college,
      this.password});

  SignupRequestModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    userEmail = json['user_email'];
    mobileNo = json['mobile_no'];
    deviceToken = json['device_token'];
    identity = json['identity'];
    loginType = json['login_type'];
    platform = json['platform'];
    dob = json['dob'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    pincode = json['pincode'];
    college = json['college'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['user_email'] = userEmail;
    data['mobile_no'] = mobileNo;
    data['device_token'] = deviceToken;
    data['identity'] = identity;
    data['login_type'] = loginType;
    data['platform'] = platform;
    data['dob'] = dob;
    data['city_id'] = cityId;
    data['state_id'] = stateId;
    data['pincode'] = pincode;
    data['college'] = college;
    data['password'] = password;
    return data;
  }
}
