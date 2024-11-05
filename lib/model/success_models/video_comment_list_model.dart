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
  String? createdDate;
  int? userId;
  String? fullName;
  String? userName;
  String? userProfile;
  int? isVerify;

  VideoCommentListData(
      {this.commentsId,
      this.comment,
      this.createdDate,
      this.userId,
      this.fullName,
      this.userName,
      this.userProfile,
      this.isVerify});

  VideoCommentListData.fromJson(Map<String, dynamic> json) {
    commentsId = json['comments_id'];
    comment = json['comment'];
    createdDate = json['created_date'];
    userId = json['user_id'];
    fullName = json['full_name'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
    isVerify = json['is_verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comments_id'] = commentsId;
    data['comment'] = comment;
    data['created_date'] = createdDate;
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['user_name'] = userName;
    data['user_profile'] = userProfile;
    data['is_verify'] = isVerify;
    return data;
  }
}
