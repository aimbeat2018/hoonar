class FaqListModel {
  String? status;
  String? message;
  List<FaqListData>? data;

  FaqListModel({this.status, this.message, this.data});

  FaqListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FaqListData>[];
      json['data'].forEach((v) {
        data!.add(FaqListData.fromJson(v));
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

class FaqListData {
  int? id;
  String? question;
  String? answer;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  bool isExpanded = false;

  FaqListData(
      {this.id,
      this.question,
      this.answer,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  FaqListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
