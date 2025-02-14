class ContactDetailsModel {
  String? status;
  String? message;
  ContactDetailsData? data;

  ContactDetailsModel({this.status, this.data});

  ContactDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ContactDetailsData.fromJson(json['data'])
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

class ContactDetailsData {
  String? helpMail;
  String? helpContact;

  ContactDetailsData({this.helpMail, this.helpContact});

  ContactDetailsData.fromJson(Map<String, dynamic> json) {
    helpMail = json['help_mail'];
    helpContact = json['help_contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['help_mail'] = helpMail;
    data['help_contact'] = helpContact;
    return data;
  }
}
