class SendOtpSuccessModel {
  String? status;
  int? otp;
  String? message;

  SendOtpSuccessModel({this.status, this.otp, this.message});

  SendOtpSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    otp = json['otp'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['otp'] = otp;
    data['message'] = message;
    return data;
  }
}
