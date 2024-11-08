class VideoCommentListModel {
  String? status;
  String? message;
  List<VideoCommentListData>? data;

  VideoCommentListModel({this.status, this.message, this.data});

  VideoCommentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VideoCommentListData>[];
      json['data'].forEach((v) {
        data!.add(VideoCommentListData.fromJson(v));
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

class VideoCommentListData {
  int? commentsId;
  String? comment;
  int? userId;
  String? fullName;
  String? userName;
  String? userProfile;
  int? isVerify;
  int? isLiked;
  int? likesCount;
  List<Replies>? replies;
  String? createdDate;

  VideoCommentListData(
      {this.commentsId,
      this.comment,
      this.userId,
      this.fullName,
      this.userName,
      this.userProfile,
      this.isVerify,
      this.isLiked,
      this.likesCount,
      this.replies,
      this.createdDate});

  VideoCommentListData.fromJson(Map<String, dynamic> json) {
    commentsId = json['comments_id'];
    comment = json['comment'];
    userId = json['user_id'];
    fullName = json['full_name'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
    isVerify = json['is_verify'];
    isLiked = json['is_liked'];
    likesCount = json['likes_count'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comments_id'] = commentsId;
    data['comment'] = comment;
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['user_profile'] = userProfile;
    data['is_verify'] = isVerify;
    data['is_liked'] = isLiked;
    data['likes_count'] = likesCount;
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    data['created_date'] = createdDate;
    return data;
  }
}

class Replies {
  int? replyId;
  String? reply;
  String? createdAt;
  int? userId;
  String? fullName;
  String? userName;
  String? userProfile;
  int? isVerify;

  Replies(
      {this.replyId,
      this.reply,
      this.createdAt,
      this.userId,
      this.fullName,
      this.userName,
      this.userProfile,
      this.isVerify});

  Replies.fromJson(Map<String, dynamic> json) {
    replyId = json['reply_id'];
    reply = json['reply'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    fullName = json['full_name'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
    isVerify = json['is_verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reply_id'] = replyId;
    data['reply'] = reply;
    data['created_at'] = createdAt;
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['user_profile'] = userProfile;
    data['is_verify'] = isVerify;
    return data;
  }
}
