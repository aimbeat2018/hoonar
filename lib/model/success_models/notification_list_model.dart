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
  /*int? senderUserId;
  String? receivedUserId;*/
  int? notificationType;
  String? message;
  String? createdAt;
  String? updatedAt;
  int? isRead;

  NotificationData(
      {this.notificationId,
     /* this.senderUserId,
      this.receivedUserId,*/
      this.notificationType,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.isRead});

  NotificationData.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
   /* senderUserId = json['sender_user_id'];
    receivedUserId = json['received_user_id'];*/
    notificationType = json['notification_type'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_id'] = notificationId;
/*    data['sender_user_id'] = senderUserId;
    data['received_user_id'] = receivedUserId;*/
    data['notification_type'] = notificationType;
    data['message'] = message;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_read'] = isRead;
    return data;
  }
}
