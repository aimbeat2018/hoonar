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
        data!.add(new NotificationData.fromJson(v));
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
  int? notificationId;

  int? userId;
  String? image;
  int? notificationType;
  String? message;
  String? createdAt;
  String? updatedAt;
  String? description;
  int? isRead;

  NotificationData(
      {this.notificationId,
      this.userId,
      this.image,
      this.notificationType,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.isRead});

  NotificationData.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    userId = json['user_id'];
    image = json['image'];
    notificationType = json['notification_type'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isRead = json['is_read'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_id'] = notificationId;
    data['user_id'] = userId;
    data['image'] = image;
    data['notification_type'] = notificationType;
    data['message'] = message;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_read'] = isRead;
    data['description'] = description;
    return data;
  }
}
