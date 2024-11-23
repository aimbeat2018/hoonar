class BankDetailsModel {
  int? status;
  String? message;
  BankDetails? data;

  BankDetailsModel({this.status, this.message, this.data});

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new BankDetails.fromJson(json['data']) : null;
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

class BankDetails {
  String? accHolderName;
  String? accNo;
  String? ifscCode;
  String? accType;
  String? bankName;
  String? branchName;

  BankDetails(
      {this.accHolderName,
      this.accNo,
      this.ifscCode,
      this.accType,
      this.bankName,
      this.branchName});

  BankDetails.fromJson(Map<String, dynamic> json) {
    accHolderName = json['acc_holder_name'];
    accNo = json['acc_no'];
    ifscCode = json['ifsc_code'];
    accType = json['acc_type'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['acc_holder_name'] = accHolderName;
    data['acc_no'] = accNo;
    data['ifsc_code'] = ifscCode;
    data['acc_type'] = accType;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    return data;
  }
}
