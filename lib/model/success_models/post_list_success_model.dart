import 'home_post_success_model.dart';

class PostListSuccessModel {
  String? status;
  String? message;
  List<PostsListData>? data;

  PostListSuccessModel({this.status, this.message, this.data});

  PostListSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PostsListData>[];
      json['data'].forEach((v) {
        data!.add(new PostsListData.fromJson(v));
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

/*class PostData {
  int? postId;
  int? userId;
  String? fullName;
  String? userName;
  String? userProfile;
  int? isVerify;
  int? isTrending;
  String? postDescription;
  String? postHashTag;
  String? postVideo;
  String? postImage;
  int? categoryId;
  String? categoryName;
  int? soundId;
  String? soundTitle;
  String? duration;
  String? singer;
  String? soundImage;
  String? sound;
  String? profileCategoryId;
  String? profileCategoryName;
  int? postLikesCount;
  int? postCommentsCount;
  int? postViewCount;
  String? createdDate;
  int? videoLikesOrNot;
  int? followOrNot;
  int? isBookmark;
  int? canComment;
  int? canDuet;
  int? canSave;

  PostData(
      {this.postId,
      this.userId,
      this.fullName,
      this.userName,
      this.userProfile,
      this.isVerify,
      this.isTrending,
      this.postDescription,
      this.postHashTag,
      this.postVideo,
      this.postImage,
      this.categoryId,
      this.categoryName,
      this.soundId,
      this.soundTitle,
      this.duration,
      this.singer,
      this.soundImage,
      this.sound,
      this.profileCategoryId,
      this.profileCategoryName,
      this.postLikesCount,
      this.postCommentsCount,
      this.postViewCount,
      this.createdDate,
      this.videoLikesOrNot,
      this.followOrNot,
      this.isBookmark,
      this.canComment,
      this.canDuet,
      this.canSave});

  PostData.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    fullName = json['full_name'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
    isVerify = json['is_verify'];
    isTrending = json['is_trending'];
    postDescription = json['post_description'];
    postHashTag = json['post_hash_tag'];
    postVideo = json['post_video'];
    postImage = json['post_image'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    soundId = json['sound_id'];
    soundTitle = json['sound_title'];
    duration = json['duration'];
    singer = json['singer'];
    soundImage = json['sound_image'];
    sound = json['sound'];
    profileCategoryId = json['profile_category_id'];
    profileCategoryName = json['profile_category_name'];
    postLikesCount = json['post_likes_count'];
    postCommentsCount = json['post_comments_count'];
    postViewCount = json['post_view_count'];
    createdDate = json['created_date'];
    videoLikesOrNot = json['video_likes_or_not'];
    followOrNot = json['follow_or_not'];
    isBookmark = json['is_bookmark'];
    canComment = json['can_comment'];
    canDuet = json['can_duet'];
    canSave = json['can_save'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['user_profile'] = userProfile;
    data['is_verify'] = isVerify;
    data['is_trending'] = isTrending;
    data['post_description'] = postDescription;
    data['post_hash_tag'] = postHashTag;
    data['post_video'] = postVideo;
    data['post_image'] = postImage;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['sound_id'] = soundId;
    data['sound_title'] = soundTitle;
    data['duration'] = duration;
    data['singer'] = singer;
    data['sound_image'] = soundImage;
    data['sound'] = sound;
    data['profile_category_id'] = profileCategoryId;
    data['profile_category_name'] = profileCategoryName;
    data['post_likes_count'] = postLikesCount;
    data['post_comments_count'] = postCommentsCount;
    data['post_view_count'] = postViewCount;
    data['created_date'] = createdDate;
    data['video_likes_or_not'] = videoLikesOrNot;
    data['follow_or_not'] = followOrNot;
    data['is_bookmark'] = isBookmark;
    data['can_comment'] = canComment;
    data['can_duet'] = canDuet;
    data['can_save'] = canSave;
    return data;
  }
}*/
