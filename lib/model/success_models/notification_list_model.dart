import 'package:hoonar/model/success_models/home_post_success_model.dart';
import 'package:hoonar/model/success_models/post_list_success_model.dart';

class NotificationListModel {
  String? status;
  String? message;
  int? unreadCount;
  List<NotificationData>? data;

  NotificationListModel(
      {this.status, this.message, this.unreadCount, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    unreadCount = json['unread_count'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['unread_count'] = unreadCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  int? userId;
  int? notificationId;
  String? message;
  String? image;
  String? description;
  String? createdAt;
  int? isRead;
  String? type;
  int? itemId;
  String? userDetails;
  List<PostsListData>? postDetails;

  NotificationData(
      {this.userId,
      this.notificationId,
      this.message,
      this.image,
      this.description,
      this.createdAt,
      this.isRead,
      this.type,
      this.itemId,
      this.userDetails,
      this.postDetails});

  NotificationData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    notificationId = json['notification_id'];
    message = json['message'];
    image = json['image'];
    description = json['description'];
    createdAt = json['created_at'];
    isRead = json['is_read'];
    type = json['type'];
    itemId = json['item_id'];
    userDetails = json['user_details'];
    if (json['post_details'] != null) {
      postDetails = <PostsListData>[];
      json['post_details'].forEach((v) {
        postDetails!.add(PostsListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['notification_id'] = notificationId;
    data['message'] = message;
    data['image'] = image;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['is_read'] = isRead;
    data['type'] = type;
    data['item_id'] = itemId;
    data['user_details'] = userDetails;
    if (postDetails != null) {
      data['post_details'] = postDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
