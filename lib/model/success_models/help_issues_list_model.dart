class HelpIssuesListModel {
  String? status;
  String? message;
  List<HelpIssuesListData>? data;

  HelpIssuesListModel({this.status, this.message, this.data});

  HelpIssuesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HelpIssuesListData>[];
      json['data'].forEach((v) {
        data!.add(HelpIssuesListData.fromJson(v));
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

class HelpIssuesListData {
  int? issueId;
  String? issueName;
  String? description;
  String? createdAt;
  String? updatedAt;

  HelpIssuesListData(
      {this.issueId,
      this.issueName,
      this.description,
      this.createdAt,
      this.updatedAt});

  HelpIssuesListData.fromJson(Map<String, dynamic> json) {
    issueId = json['issue_id'];
    issueName = json['issue_name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['issue_id'] = issueId;
    data['issue_name'] = issueName;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
