import 'package:hoonar/model/success_models/home_post_success_model.dart';

class HomePageOtherDataModel {
  int? status;
  String? message;
  HomeOtherData? data;

  HomePageOtherDataModel({this.status, this.message, this.data});

  HomePageOtherDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? HomeOtherData.fromJson(json['data']) : null;
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

class HomeOtherData {
  List<PostsListData>? myFavPostList;
  List<PostsListData>? judgesChoicePostList;
  List<PostsListData>? forYouPostList;

  HomeOtherData({this.myFavPostList, this.judgesChoicePostList, this.forYouPostList});

  HomeOtherData.fromJson(Map<String, dynamic> json) {
    if (json['my_fav_post_list'] != null) {
      myFavPostList = <PostsListData>[];
      json['my_fav_post_list'].forEach((v) {
        myFavPostList!.add(PostsListData.fromJson(v));
      });
    }
    if (json['judges_choice_post_list'] != null) {
      judgesChoicePostList = <PostsListData>[];
      json['judges_choice_post_list'].forEach((v) {
        judgesChoicePostList!.add(PostsListData.fromJson(v));
      });
    }
    if (json['for_you_post_list'] != null) {
      forYouPostList = <PostsListData>[];
      json['for_you_post_list'].forEach((v) {
        forYouPostList!.add(PostsListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (myFavPostList != null) {
      data['my_fav_post_list'] = myFavPostList!.map((v) => v.toJson()).toList();
    }
    if (judgesChoicePostList != null) {
      data['judges_choice_post_list'] =
          judgesChoicePostList!.map((v) => v.toJson()).toList();
    }
    if (forYouPostList != null) {
      data['for_you_post_list'] =
          forYouPostList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
