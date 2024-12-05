class UploadVideoStatusModel {
  String? status;
  String? message;
  UploadVideoStatusData? data;

  UploadVideoStatusModel({this.status, this.message, this.data});

  UploadVideoStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? UploadVideoStatusData.fromJson(json['data'])
        : null;
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

class UploadVideoStatusData {
  String? uploadStartDate;
  String? uploadEndDate;

  UploadVideoStatusData({this.uploadStartDate, this.uploadEndDate});

  UploadVideoStatusData.fromJson(Map<String, dynamic> json) {
    uploadStartDate = json['upload_start_date'];
    uploadEndDate = json['upload_end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['upload_start_date'] = uploadStartDate;
    data['upload_end_date'] = uploadEndDate;
    return data;
  }
}
