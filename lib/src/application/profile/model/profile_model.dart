class ProfileModel {
  String? message;
  PersonalInformation? data;

  ProfileModel({this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? PersonalInformation.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PersonalInformation {
  String? fullName;
  String? mobile;
  String? firstName;
  String? lastName;
  String? address;
  String? avatar;
  String? gender;
  String? membershipStatus;
  int? points;
  int? currentPoints;
  int? targetPoints;
  double? progress;
  String  ? referralCode ;
  

  PersonalInformation(
      {this.fullName,
      this.mobile,
      this.firstName,
      this.lastName,
      this.address,
      this.avatar,
      this.gender,
      this.membershipStatus,
      this.points,
      this.currentPoints,
      this.targetPoints,
      this.progress});

  PersonalInformation.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    mobile = json['mobile'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    avatar = json['avatar'];
    gender = json['gender'];
    membershipStatus = json['membership_status'];
    points = json['points'];
    currentPoints = json['current_points'];
    targetPoints = json['target_points'];
    progress = json['progress'];
    referralCode = json["referral_code"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['mobile'] = mobile;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['avatar'] = avatar;
    data['gender'] = gender;
    data['membership_status'] = membershipStatus;
    data['points'] = points;
    data['current_points'] = currentPoints;
    data['target_points'] = targetPoints;
    data['progress'] = progress;
    return data;
  }
}
