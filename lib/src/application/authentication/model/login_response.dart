// lib/src/application/authentication/model/login_response.dart
import 'dart:convert';

class LoginResponse {
  final String message;
  final String accessToken;
  final String refreshToken;
  final String? deviceToken;
  final UserData? data;

  LoginResponse({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    this.deviceToken,
    this.data,
  });

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json['message'] as String? ?? '',
        accessToken: json['access_token'] as String? ?? '',
        refreshToken: json['refresh_token'] as String? ?? '',
        deviceToken: json['device_token'] as String?,
        data: json['data'] != null
            ? UserData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'device_token': deviceToken,
        'data': data?.toJson(),
      };

  LoginResponse copyWith({
    String? message,
    String? accessToken,
    String? refreshToken,
    String? deviceToken,
    UserData? data,
  }) {
    return LoginResponse(
      message: message ?? this.message,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      deviceToken: deviceToken ?? this.deviceToken,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(message: $message, accessToken: $accessToken, refreshToken: $refreshToken, deviceToken: $deviceToken, data: $data)';
  }
}

class UserData {
  final int id;
  final String email;
  final bool isActive;
  final String fullName;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String? googleImage;
  final String membershipStatus;
  final int points;
  final int currentPoints;
  final int targetPoints;

  UserData({
    required this.id,
    required this.email,
    required this.isActive,
    required this.fullName,
    this.firstName,
    this.lastName,
    this.avatar,
    this.googleImage,
    required this.membershipStatus,
    required this.points,
    required this.currentPoints,
    required this.targetPoints,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
        email: json['email'] as String? ?? '',
        isActive: json['is_active'] as bool? ?? false,
        fullName: json['full_name'] as String? ?? '',
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        avatar: json['avatar'] as String?,
        googleImage: json['google_image'] as String?,
        membershipStatus: json['membership_status'] as String? ?? '',
        points: json['points'] is int ? json['points'] as int : int.parse('${json['points'] ?? 0}'),
        currentPoints: json['current_points'] is int ? json['current_points'] as int : int.parse('${json['current_points'] ?? 0}'),
        targetPoints: json['target_points'] is int ? json['target_points'] as int : int.parse('${json['target_points'] ?? 0}'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'is_active': isActive,
        'full_name': fullName,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
        'google_image': googleImage,
        'membership_status': membershipStatus,
        'points': points,
        'current_points': currentPoints,
        'target_points': targetPoints,
      };

  UserData copyWith({
    int? id,
    String? email,
    bool? isActive,
    String? fullName,
    String? firstName,
    String? lastName,
    String? avatar,
    String? googleImage,
    String? membershipStatus,
    int? points,
    int? currentPoints,
    int? targetPoints,
  }) {
    return UserData(
      id: id ?? this.id,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      fullName: fullName ?? this.fullName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      googleImage: googleImage ?? this.googleImage,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      points: points ?? this.points,
      currentPoints: currentPoints ?? this.currentPoints,
      targetPoints: targetPoints ?? this.targetPoints,
    );
  }

  @override
  String toString() {
    return 'UserData(id: $id, email: $email, isActive: $isActive, fullName: $fullName, membershipStatus: $membershipStatus, points: $points, currentPoints: $currentPoints, targetPoints: $targetPoints)';
  }
}