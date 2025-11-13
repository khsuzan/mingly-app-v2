class ProfileModel {
  String? message;
  PersonalInformation? data;

  ProfileModel({this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new PersonalInformation.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
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
    membershipStatus = json['membership_status'];
    points = json['points'];
    currentPoints = json['current_points'];
    targetPoints = json['target_points'];
    progress = json['progress'];
    referralCode = json["referral_code"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['mobile'] = this.mobile;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    data['membership_status'] = this.membershipStatus;
    data['points'] = this.points;
    data['current_points'] = this.currentPoints;
    data['target_points'] = this.targetPoints;
    data['progress'] = this.progress;
    return data;
  }
}
