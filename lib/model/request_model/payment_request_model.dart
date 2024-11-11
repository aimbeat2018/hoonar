class PaymentRequestModel {
  int? userId;
  int? levelId;
  int? categoryId;
  int? amount;
  String? transactionId;
  String? paymentStatus;

  PaymentRequestModel(
      {this.userId,
      this.levelId,
      this.categoryId,
      this.amount,
      this.transactionId,
      this.paymentStatus});

  PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    levelId = json['level_id'];
    categoryId = json['category_id'];
    amount = json['amount'];
    transactionId = json['transaction_id'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['level_id'] = levelId;
    data['category_id'] = categoryId;
    data['amount'] = amount;
    data['transaction_id'] = transactionId;
    data['payment_status'] = paymentStatus;
    return data;
  }
}
