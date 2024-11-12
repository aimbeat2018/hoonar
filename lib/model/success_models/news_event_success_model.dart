class NewsEventSuccessModel {
  String? status;
  String? message;
  List<NewsEventData>? data;

  NewsEventSuccessModel({this.status, this.message, this.data});

  NewsEventSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NewsEventData>[];
      json['data'].forEach((v) {
        data!.add(NewsEventData.fromJson(v));
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

class NewsEventData {
  int? id;
  String? title;
  String? description;
  String? date;
  String? createdAt;
  String? type;
  String? location;

  NewsEventData(
      {this.id,
      this.title,
      this.description,
      this.date,
      this.createdAt,
      this.type,
      this.location});

  NewsEventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    createdAt = json['created_at'];
    type = json['type'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['created_at'] = createdAt;
    data['type'] = type;
    data['location'] = location;
    return data;
  }
}
