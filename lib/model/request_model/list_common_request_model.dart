class ListCommonRequestModel {
  int? userId;
  int? start;
  int? limit;
  int? categoryId;
  int? toUserId;
  int? postId;

  ListCommonRequestModel(
      {this.userId,
      this.start,
      this.limit,
      this.categoryId,
      this.toUserId,
      this.postId});

  ListCommonRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    start = json['start'];
    limit = json['limit'];
    categoryId = json['category_id'];
    toUserId = json['to_user_id'];
    postId = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['start'] = start;
    data['limit'] = limit;
    data['category_id'] = categoryId;
    data['to_user_id'] = toUserId;
    data['post_id'] = postId;
    return data;
  }
}
