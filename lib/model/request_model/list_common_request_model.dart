class ListCommonRequestModel {
  int? userId;
  int? start;
  int? limit;
  int? page;
  int? categoryId;
  int? toUserId;
  int? postId;
  int? reasonId;
  String? search;
  String? type;
  String? searchTerm;
  String? searchId;
  String? comment;
  String? commentId;
  String? deviceId;
  String? date;
  String? description;
  String? pageType; // privacy,termsofuse,about_us,contact_us
  String? interestType; // 1: Interested, 2: Not Interested

  ListCommonRequestModel({
    this.userId,
    this.reasonId,
    this.start,
    this.limit,
    this.page,
    this.categoryId,
    this.toUserId,
    this.search,
    this.postId,
    this.type,
    this.searchTerm,
    this.searchId,
    this.comment,
    this.commentId,
    this.deviceId,
    this.date,
    this.pageType,
    this.interestType,
    this.description,
  });

  ListCommonRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    start = json['start'];
    limit = json['limit'];
    page = json['page'];
    categoryId = json['category_id'];
    toUserId = json['to_user_id'];
    postId = json['post_id'];
    search = json['search'];
    type = json['type'];
    searchTerm = json['search_term'];
    searchId = json['search_id'];
    comment = json['comment'];
    commentId = json['comments_id'];
    pageType = json['page_type'];
    interestType = json['interest_type'];
    deviceId = json['device_id'];
    date = json['date'];
    reasonId = json['reason_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['start'] = start;
    data['limit'] = limit;
    data['page'] = page;
    data['category_id'] = categoryId;
    data['to_user_id'] = toUserId;
    data['post_id'] = postId;
    data['search'] = search;
    data['type'] = type;
    data['search_term'] = searchTerm;
    data['search_id'] = searchId;
    data['comment'] = comment;
    data['comments_id'] = commentId;
    data['page_type'] = pageType;
    data['interest_type'] = interestType;
    data['device_id'] = deviceId;
    data['date'] = date;
    data['reason_id'] = reasonId;
    data['description'] = description;
    return data;
  }
}
