class SignInRequestModel {
  String? identity;
  String? password;
  String? deviceName;
  String? deviceType;
  String? deviceToken;
  String? deviceOs;

  SignInRequestModel(
      {this.identity,
      this.password,
      this.deviceName,
      this.deviceType,
      this.deviceToken,
      this.deviceOs});

  SignInRequestModel.fromJson(Map<String, dynamic> json) {
    identity = json['identity'];
    password = json['password'];
    deviceName = json['device_name'];
    deviceType = json['device_type'];
    deviceToken = json['fcm_token'];
    deviceOs = json['device_os'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identity'] = identity;
    data['password'] = password;
    data['device_name'] = deviceName;
    data['device_type'] = deviceType;
    data['fcm_token'] = deviceToken;
    data['device_os'] = deviceOs;
    return data;
  }
}
