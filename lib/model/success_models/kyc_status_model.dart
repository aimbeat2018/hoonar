class KycStatusModel {
  String? status;
  String? message;
  KycStatusData? data;

  KycStatusModel({this.status, this.message, this.data});

  KycStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? KycStatusData.fromJson(json['data']) : null;
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

class KycStatusData {
  int? isVerified;
  int? iDProof;
  int? addressProof;
  int? face;

  KycStatusData({this.isVerified, this.iDProof, this.addressProof, this.face});

  KycStatusData.fromJson(Map<String, dynamic> json) {
    isVerified = json['is_verified'];
    iDProof = json['ID Proof'];
    addressProof = json['Address Proof'];
    face = json['Face'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_verified'] = isVerified;
    data['ID Proof'] = iDProof;
    data['Address Proof'] = addressProof;
    data['Face'] = face;
    return data;
  }
}
