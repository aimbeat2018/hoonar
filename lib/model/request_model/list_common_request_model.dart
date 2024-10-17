class ListCommonRequestModel {
  int? userId;
  int? start;
  int? limit;

  ListCommonRequestModel({this.userId, this.start, this.limit});

  ListCommonRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    start = json['start'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['start'] = start;
    data['limit'] = limit;
    return data;
  }
}
