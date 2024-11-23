class BankDetailsRequestModel {
  String? accHolderName;
  String? accNo;
  String? ifscCode;
  String? accType;
  String? bankName;
  String? branchName;

  BankDetailsRequestModel(
      {this.accHolderName,
      this.accNo,
      this.ifscCode,
      this.accType,
      this.bankName,
      this.branchName});

  BankDetailsRequestModel.fromJson(Map<String, dynamic> json) {
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
