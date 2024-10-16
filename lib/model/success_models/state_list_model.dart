class StateListModel {
  String? status;
  String? message;
  List<StateListData>? data;

  StateListModel({this.status, this.message, this.data});

  StateListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StateListData>[];
      json['data'].forEach((v) {
        data!.add(StateListData.fromJson(v));
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

class StateListData {
  int? id;
  String? name;
  int? countryId;

  StateListData({this.id, this.name, this.countryId});

  StateListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    return data;
  }
}
