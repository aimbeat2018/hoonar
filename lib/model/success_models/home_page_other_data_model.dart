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
  List<PostsListData>? trendingNowPostList;
  List<PostsListData>? hoonarHighlightsPostList;
  List<PostsListData>? featuredTalentPostList;
  List<PostsListData>? hoonarStarsPostList;
  List<PostsListData>? hoonarStarOfMonths;
  List<PostsListData>? dailyFeedPostList;

  HomeOtherData(
      {this.myFavPostList, this.judgesChoicePostList, this.forYouPostList});

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
    if (json['daily_feed_post_list'] != null) {
      dailyFeedPostList = <PostsListData>[];
      json['daily_feed_post_list'].forEach((v) {
        dailyFeedPostList!.add(PostsListData.fromJson(v));
      });
    }
    if (json['for_you_post_list'] != null) {
      forYouPostList = <PostsListData>[];
      json['for_you_post_list'].forEach((v) {
        forYouPostList!.add(PostsListData.fromJson(v));
      });
    }
    if (json['trending_now_post_list'] != null) {
      trendingNowPostList = <PostsListData>[];
      json['trending_now_post_list'].forEach((v) {
        trendingNowPostList!.add(PostsListData.fromJson(v));
      });
    }
    if (json['hoonar_highlights_post_list'] != null) {
      hoonarHighlightsPostList = <PostsListData>[];
      json['hoonar_highlights_post_list'].forEach((v) {
        hoonarHighlightsPostList!.add(PostsListData.fromJson(v));
      });
    }
    if (json['featured_talent_post_list'] != null) {
      featuredTalentPostList = <PostsListData>[];
      json['featured_talent_post_list'].forEach((v) {
        featuredTalentPostList!.add(PostsListData.fromJson(v));
      });
    }
    if (json['hoonar_stars_post_list'] != null) {
      hoonarStarsPostList = <PostsListData>[];
      json['hoonar_stars_post_list'].forEach((v) {
        hoonarStarsPostList!.add(PostsListData.fromJson(v));
      });
    }
    if (json['hoonar_star_of_months'] != null) {
      hoonarStarOfMonths = <PostsListData>[];
      json['hoonar_star_of_months'].forEach((v) {
        hoonarStarOfMonths!.add(PostsListData.fromJson(v));
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
    if (dailyFeedPostList != null) {
      data['daily_feed_post_list'] =
          dailyFeedPostList!.map((v) => v.toJson()).toList();
    }
    if (forYouPostList != null) {
      data['for_you_post_list'] =
          forYouPostList!.map((v) => v.toJson()).toList();
    }
    if (trendingNowPostList != null) {
      data['trending_now_post_list'] =
          trendingNowPostList!.map((v) => v.toJson()).toList();
    }
    if (hoonarHighlightsPostList != null) {
      data['hoonar_highlights_post_list'] =
          hoonarHighlightsPostList!.map((v) => v.toJson()).toList();
    }
    if (featuredTalentPostList != null) {
      data['featured_talent_post_list'] =
          featuredTalentPostList!.map((v) => v.toJson()).toList();
    }
    if (hoonarStarsPostList != null) {
      data['hoonar_stars_post_list'] =
          hoonarStarsPostList!.map((v) => v.toJson()).toList();
    }
    if (hoonarStarOfMonths != null) {
      data['hoonar_star_of_months'] =
          hoonarStarOfMonths!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
