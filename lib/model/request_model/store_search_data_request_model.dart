class StoreSearchDataRequestModel {
  int? clickedUserId;
  String? clickedFullName;
  String? clickedUserName;

  StoreSearchDataRequestModel(
      {this.clickedUserId, this.clickedFullName, this.clickedUserName});

  StoreSearchDataRequestModel.fromJson(Map<String, dynamic> json) {
    clickedUserId = json['clicked_user_id'];
    clickedFullName = json['clicked_full_name'];
    clickedUserName = json['clicked_user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clicked_user_id'] = clickedUserId;
    data['clicked_full_name'] = clickedFullName;
    data['clicked_user_name'] = clickedUserName;
    return data;
  }
}
