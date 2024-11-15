class WalletTransactionListModel {
  String? status;
  String? message;
  int? walletBalance;
  List<WalletTransactionData>? data;

  WalletTransactionListModel(
      {this.status, this.message, this.walletBalance, this.data});

  WalletTransactionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    walletBalance = json['wallet_balance'];
    if (json['data'] != null) {
      data = <WalletTransactionData>[];
      json['data'].forEach((v) {
        data!.add(WalletTransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['wallet_balance'] = walletBalance;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletTransactionData {
  int? transactionId;
  String? amount;
  String? currency;
  String? transactionType;
  int? rewardId;
  String? transactionDate;
  String? status;

  WalletTransactionData(
      {this.transactionId,
      this.amount,
      this.currency,
      this.transactionType,
      this.rewardId,
      this.transactionDate,
      this.status});

  WalletTransactionData.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    amount = json['amount'];
    currency = json['currency'];
    transactionType = json['transaction_type'];
    rewardId = json['reward_id'];
    transactionDate = json['transaction_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['amount'] = amount;
    data['currency'] = currency;
    data['transaction_type'] = transactionType;
    data['reward_id'] = rewardId;
    data['transaction_date'] = transactionDate;
    data['status'] = status;
    return data;
  }
}
