class ApplyCouponCodeModel {
  String? status;
  String? message;
  ApplyCouponCodeData? data;

  ApplyCouponCodeModel({this.status, this.message, this.data});

  ApplyCouponCodeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ApplyCouponCodeData.fromJson(json['data'])
        : null;
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

class ApplyCouponCodeData {
  int? couponId;
  String? couponCode;
  String? description;
  String? discountType;
  String? discountValue;
  String? startDate;
  String? endDate;
  int? status;
  String? createdAt;
  String? updatedAt;

  ApplyCouponCodeData(
      {this.couponId,
      this.couponCode,
      this.description,
      this.discountType,
      this.discountValue,
      this.startDate,
      this.endDate,
      this.status,
      this.createdAt,
      this.updatedAt});

  ApplyCouponCodeData.fromJson(Map<String, dynamic> json) {
    couponId = json['coupon_id'];
    couponCode = json['coupon_code'];
    description = json['description'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coupon_id'] = couponId;
    data['coupon_code'] = couponCode;
    data['description'] = description;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
