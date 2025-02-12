class StorePaymentRequestModel {
  int? userId;
  int? levelId;
  int? categoryId;
  double? amount;
  String? couponCode;
  String? isCouponApply;
  String? actualAmount;
  String? transactionId;
  String? paymentStatus; //(e.g., 'completed', 'pending', 'failed')

  StorePaymentRequestModel(
      {this.userId,
      this.levelId,
      this.categoryId,
      this.amount,
      this.couponCode,
      this.isCouponApply,
      this.actualAmount,
      this.transactionId,
      this.paymentStatus});

  StorePaymentRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    levelId = json['level_id'];
    categoryId = json['category_id'];
    amount = json['amount'];
    transactionId = json['transaction_id'];
    paymentStatus = json['payment_status'];
    isCouponApply = json['coupon_code_applied'];
    actualAmount = json['mrp'];
    couponCode = json['coupon_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['level_id'] = levelId;
    data['category_id'] = categoryId;
    data['amount'] = amount;
    data['transaction_id'] = transactionId;
    data['payment_status'] = paymentStatus;
    data['coupon_code_applied'] = isCouponApply;
    data['mrp'] = actualAmount;
    data['coupon_code'] = couponCode;
    return data;
  }
}
