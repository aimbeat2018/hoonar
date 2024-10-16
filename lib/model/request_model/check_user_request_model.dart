class CheckUserRequestModel {
  String? userEmail;
  String? mobileNo;
  String? password;
  String? otp;

  CheckUserRequestModel(
      {this.userEmail, this.mobileNo, this.otp, this.password});

  CheckUserRequestModel.fromJson(Map<String, dynamic> json) {
    userEmail = json['user_email'];
    mobileNo = json['mobile_no'];
    otp = json['otp'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_email'] = userEmail;
    data['mobile_no'] = mobileNo;
    data['otp'] = otp;
    data['password'] = password;
    return data;
  }
}
