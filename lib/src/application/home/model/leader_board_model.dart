class LeaderBoardModel {
  int? id;
  String? email;
  bool? isActive;
  String? fullName;
  String? avatar;
  String? googleImage;
  String? membershipStatus;
  int? points;
  int? currentPoints;
  int? targetPoints;

  LeaderBoardModel(
      {this.id,
      this.email,
      this.isActive,
      this.fullName,
      this.avatar,
      this.googleImage,
      this.membershipStatus,
      this.points,
      this.currentPoints,
      this.targetPoints});

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    isActive = json['is_active'];
    fullName = json['full_name'];
    avatar = json['avatar'];
    googleImage = json['google_image'];
    membershipStatus = json['membership_status'];
    points = json['points'];
    currentPoints = json['current_points'];
    targetPoints = json['target_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['is_active'] = this.isActive;
    data['full_name'] = this.fullName;
    data['avatar'] = this.avatar;
    data['google_image'] = this.googleImage;
    data['membership_status'] = this.membershipStatus;
    data['points'] = this.points;
    data['current_points'] = this.currentPoints;
    data['target_points'] = this.targetPoints;
    return data;
  }

  @override
  String toString() {
    return 'LeaderBoardModel{id: $id, email: $email, isActive: $isActive, fullName: $fullName, avatar: $avatar, googleImage: $googleImage, membershipStatus: $membershipStatus, points: $points, currentPoints: $currentPoints, targetPoints: $targetPoints}';
  }
}
