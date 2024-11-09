class PageContentModel {
  String? status;
  String? message;
  PageContentData? data;

  PageContentModel({this.status, this.message, this.data});

  PageContentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? PageContentData.fromJson(json['data']) : null;
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

class PageContentData {
  String? pageType;
  String? content;

  PageContentData({this.pageType, this.content});

  PageContentData.fromJson(Map<String, dynamic> json) {
    pageType = json['page_type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page_type'] = pageType;
    data['content'] = content;
    return data;
  }
}
