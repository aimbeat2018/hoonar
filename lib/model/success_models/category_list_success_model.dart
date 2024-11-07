class CategoryListSuccessModel {
  String? status;
  String? message;
  List<CategoryListData>? data;

  CategoryListSuccessModel({this.status, this.message, this.data});

  CategoryListSuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryListData>[];
      json['data'].forEach((v) {
        data!.add(CategoryListData.fromJson(v));
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

class CategoryListData {
  int? categoryId;
  String? categoryName;
  String? imageUrl;
  String? darkImageUrl;

  CategoryListData({this.categoryId, this.categoryName, this.imageUrl, this.darkImageUrl});

  CategoryListData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    imageUrl = json['image_url'];
    darkImageUrl = json['dark_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['image_url'] = imageUrl;
    data['dark_image_url'] = darkImageUrl;
    return data;
  }
}
