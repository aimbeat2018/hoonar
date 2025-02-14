class ReportReasonsModel {
  int? status;
  List<ReportReasonsData>? data;

  ReportReasonsModel({this.status, this.data});

  ReportReasonsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ReportReasonsData>[];
      json['data'].forEach((v) {
        data!.add(ReportReasonsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportReasonsData {
  int? reasonId;
  String? reason;

  ReportReasonsData({this.reasonId, this.reason});

  ReportReasonsData.fromJson(Map<String, dynamic> json) {
    reasonId = json['reason_id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason_id'] = reasonId;
    data['reason'] = reason;
    return data;
  }
}
