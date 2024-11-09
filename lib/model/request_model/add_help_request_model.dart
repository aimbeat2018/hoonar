class AddHelpRequestModel {
  String? name;
  String? email;
  String? phone;
  String? message;
  int? issueId;

  AddHelpRequestModel(
      {this.name, this.email, this.phone, this.message, this.issueId});

  AddHelpRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    message = json['message'];
    issueId = json['issue_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['message'] = message;
    data['issue_id'] = issueId;
    return data;
  }
}
