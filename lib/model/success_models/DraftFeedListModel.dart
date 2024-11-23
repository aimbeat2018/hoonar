import 'package:hoonar/model/success_models/home_post_success_model.dart';

class DraftFeedListModel {
  String? status;
  String? message;
  Data? data;

  DraftFeedListModel({this.status, this.message, this.data});

  DraftFeedListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<PostsListData>? yourFeed;
  List<PostsListData>? drafts;
  List<PostsListData>? hoonarStar;

  Data({this.yourFeed, this.drafts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['your_feed'] != null) {
      yourFeed = <PostsListData>[];
      json['your_feed'].forEach((v) {
        yourFeed!.add(PostsListData.fromJson(v));
      });
    }
    if (json['drafts'] != null) {
      drafts = <PostsListData>[];
      json['drafts'].forEach((v) {
        drafts!.add(PostsListData.fromJson(v));
      });
    }
    if (json['hoonar_star'] != null) {
      hoonarStar = <PostsListData>[];
      json['hoonar_star'].forEach((v) {
        hoonarStar!.add(PostsListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (yourFeed != null) {
      data['your_feed'] = yourFeed!.map((v) => v.toJson()).toList();
    }
    if (drafts != null) {
      data['drafts'] = drafts!.map((v) => v.toJson()).toList();
    }
    if (hoonarStar != null) {
      data['hoonar_star'] = hoonarStar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
