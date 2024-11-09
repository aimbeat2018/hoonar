class DevicesListModel {
  String? status;
  String? message;
  List<DevicesListData>? data;

  DevicesListModel({this.status, this.message, this.data});

  DevicesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DevicesListData>[];
      json['data'].forEach((v) {
        data!.add(DevicesListData.fromJson(v));
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

class DevicesListData {
  int? deviceId;
  int? userId;
  String? deviceName;
  String? deviceType;
  String? deviceOs;
  String? deviceToken;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;

  DevicesListData(
      {this.deviceId,
      this.userId,
      this.deviceName,
      this.deviceType,
      this.deviceOs,
      this.deviceToken,
      this.lastLogin,
      this.createdAt,
      this.updatedAt});

  DevicesListData.fromJson(Map<String, dynamic> json) {
    deviceId = json['device_id'];
    userId = json['user_id'];
    deviceName = json['device_name'];
    deviceType = json['device_type'];
    deviceOs = json['device_os'];
    deviceToken = json['device_token'];
    lastLogin = json['last_login'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device_id'] = deviceId;
    data['user_id'] = userId;
    data['device_name'] = deviceName;
    data['device_type'] = deviceType;
    data['device_os'] = deviceOs;
    data['device_token'] = deviceToken;
    data['last_login'] = lastLogin;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
