class LogoutSuccessModel {
  String? successCode;
  int? responseCode;
  String? responseMessage;

  LogoutSuccessModel(
      {this.successCode, this.responseCode, this.responseMessage});

  LogoutSuccessModel.fromJson(Map<String, dynamic> json) {
    successCode = json['success_code'];
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_code'] = successCode;
    data['response_code'] = responseCode;
    data['response_message'] = responseMessage;
    return data;
  }
}
