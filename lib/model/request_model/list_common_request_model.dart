class ListCommonRequestModel {
  int? userId;
  int? start;
  int? limit;
  int? categoryId;
  int? toUserId;
  int? postId;
  String? search;
  String? type;
  String? searchTerm;
  String? searchId;
  String? comment;
  String? commentId;

  ListCommonRequestModel({
    this.userId,
    this.start,
    this.limit,
    this.categoryId,
    this.toUserId,
    this.search,
    this.postId,
    this.type,
    this.searchTerm,
    this.searchId,
    this.comment,
    this.commentId,
  });

  ListCommonRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    start = json['start'];
    limit = json['limit'];
    categoryId = json['category_id'];
    toUserId = json['to_user_id'];
    postId = json['post_id'];
    search = json['search'];
    type = json['type'];
    searchTerm = json['search_term'];
    searchId = json['search_id'];
    comment = json['comment'];
    commentId = json['comments_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['start'] = start;
    data['limit'] = limit;
    data['category_id'] = categoryId;
    data['to_user_id'] = toUserId;
    data['post_id'] = postId;
    data['search'] = search;
    data['type'] = type;
    data['search_term'] = searchTerm;
    data['search_id'] = searchId;
    data['comment'] = comment;
    data['comments_id'] = commentId;
    return data;
  }
}
