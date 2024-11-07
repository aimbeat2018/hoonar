import 'home_post_success_model.dart';

class HomePageOtherViewAllModel {
  int? status;
  String? message;
  List<PostsListData>? data;

  HomePageOtherViewAllModel({this.status, this.message, this.data});

  HomePageOtherViewAllModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PostsListData>[];
      json['data'].forEach((v) {
        data!.add(PostsListData.fromJson(v));
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
