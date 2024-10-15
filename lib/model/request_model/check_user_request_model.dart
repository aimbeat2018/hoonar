class CheckUserRequestModel {
  String? userEmail;
  String? mobileNo;

  CheckUserRequestModel({this.userEmail, this.mobileNo});

  CheckUserRequestModel.fromJson(Map<String, dynamic> json) {
    userEmail = json['user_email'];
    mobileNo = json['mobile_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_email'] = userEmail;
    data['mobile_no'] = mobileNo;
    return data;
  }
}
