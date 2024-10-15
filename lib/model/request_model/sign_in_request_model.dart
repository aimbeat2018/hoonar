class SignInRequestModel {
  String? identity;
  String? password;
  String? deviceName;
  String? deviceType;
  String? deviceOs;

  SignInRequestModel(
      {this.identity,
      this.password,
      this.deviceName,
      this.deviceType,
      this.deviceOs});

  SignInRequestModel.fromJson(Map<String, dynamic> json) {
    identity = json['identity'];
    password = json['password'];
    deviceName = json['device_name'];
    deviceType = json['device_type'];
    deviceOs = json['device_os'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identity'] = identity;
    data['password'] = password;
    data['device_name'] = deviceName;
    data['device_type'] = deviceType;
    data['device_os'] = deviceOs;
    return data;
  }
}
