class CityListModel {
  int? status;
  String? message;
  List<CityListData>? data;

  CityListModel({this.status, this.message, this.data});

  CityListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CityListData>[];
      json['data'].forEach((v) {
        data!.add(new CityListData.fromJson(v));
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

class CityListData {
  int? id;
  String? name;
  int? stateId;

  CityListData({this.id, this.name, this.stateId});

  CityListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state_id'] = stateId;
    return data;
  }
}
