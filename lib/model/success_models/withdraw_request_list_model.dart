class WithdrawRequestListModel {
  String? status;
  String? message;
  List<WithdrawRequestList>? data;

  WithdrawRequestListModel({this.status, this.message, this.data});

  WithdrawRequestListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WithdrawRequestList>[];
      json['data'].forEach((v) {
        data!.add(new WithdrawRequestList.fromJson(v));
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

class WithdrawRequestList {
  int? transactionId;
  String? amount;
  String? currency;
  String? status;
  String? transactionDate;

  WithdrawRequestList(
      {this.transactionId,
      this.amount,
      this.currency,
      this.status,
      this.transactionDate});

  WithdrawRequestList.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
    transactionDate = json['transaction_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['amount'] = amount;
    data['currency'] = currency;
    data['status'] = status;
    data['transaction_date'] = transactionDate;
    return data;
  }
}
