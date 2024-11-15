class RewardListModel {
  String? status;
  String? message;
  List<RewardList>? data;

  RewardListModel({this.status, this.message, this.data});

  RewardListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RewardList>[];
      json['data'].forEach((v) {
        data!.add(RewardList.fromJson(v));
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

class RewardList {
  int? userRewardId;
  int? rewardId;
  int? levelId;
  int? categoryId;
  String? rewardStatus;
  String? awardedDate;
  String? claimedDate;
  String? redeemedDate;
  String? redemptionStatus;
  String? redemptionDate;
  String? rewardName;
  String? description;
  String? rewardType;
  String? amount;
  String? brand;
  String? expirationDate;
  String? image;

  RewardList(
      {this.userRewardId,
      this.levelId,
      this.rewardId,
      this.categoryId,
      this.rewardStatus,
      this.awardedDate,
      this.claimedDate,
      this.redeemedDate,
      this.redemptionStatus,
      this.redemptionDate,
      this.rewardName,
      this.description,
      this.rewardType,
      this.amount,
      this.brand,
      this.image,
      this.expirationDate});

  RewardList.fromJson(Map<String, dynamic> json) {
    userRewardId = json['user_reward_id'];
    levelId = json['level_id'];
    rewardId = json['reward_id'];
    categoryId = json['category_id'];
    rewardStatus = json['reward_status'];
    awardedDate = json['awarded_date'];
    claimedDate = json['claimed_date'];
    redeemedDate = json['redeemed_date'];
    redemptionStatus = json['redemption_status'];
    redemptionDate = json['redemption_date'];
    rewardName = json['reward_name'];
    description = json['description'];
    rewardType = json['reward_type'];
    amount = json['amount'];
    brand = json['brand'];
    expirationDate = json['expiration_date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_reward_id'] = userRewardId;
    data['level_id'] = levelId;
    data['reward_id'] = rewardId;
    data['category_id'] = categoryId;
    data['reward_status'] = rewardStatus;
    data['awarded_date'] = awardedDate;
    data['claimed_date'] = claimedDate;
    data['redeemed_date'] = redeemedDate;
    data['redemption_status'] = redemptionStatus;
    data['redemption_date'] = redemptionDate;
    data['reward_name'] = rewardName;
    data['description'] = description;
    data['reward_type'] = rewardType;
    data['amount'] = amount;
    data['brand'] = brand;
    data['expiration_date'] = expirationDate;
    data['image'] = image;
    return data;
  }
}
