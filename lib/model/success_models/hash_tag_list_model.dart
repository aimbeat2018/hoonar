class HashTagListModel {
  String? status;
  String? message;
  List<HashTagData>? data;

  HashTagListModel({this.status, this.message, this.data});

  HashTagListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HashTagData>[];
      json['data'].forEach((v) {
        data!.add(new HashTagData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HashTagData {
  int? hashTagId;
  String? hashTagName;

  HashTagData({this.hashTagId, this.hashTagName});

  HashTagData.fromJson(Map<String, dynamic> json) {
    hashTagId = json['hash_tag_id'];
    hashTagName = json['hash_tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash_tag_id'] = this.hashTagId;
    data['hash_tag_name'] = this.hashTagName;
    return data;
  }
}
