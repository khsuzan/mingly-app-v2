import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/authentication/authentiation_repo/authentication_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  void manutalTop() {
    nameController.clear();
    passwordController.clear();
    retypePasswordController.clear();
    emailController.clear();
    phoneController.clear();
    otpController.clear();
  }

  bool isAgree = false;

  updateOtp(String value) {
    otpController.text = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> signUpUser() async {
    isLoading = true;
    notifyListeners();
    final response = await AuthenticationRepo(ApiService()).signUp({
      "email": emailController.text,
      "password": passwordController.text,
    });

    // passwordController.clear();
    // phoneController.clear();
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future<Map<String, dynamic>> signUpVerifyUser() async {
    isLoading = true;
    notifyListeners();
    final response = await AuthenticationRepo(
      ApiService(),
    ).verifyOtp({"email": emailController.text, "otp": otpController.text});
    isLoading = false;
    emailController.clear();
    passwordController.clear();
    notifyListeners();
    return response;
  }

  Future<Map<String, dynamic>> signUpVerifyUserForgot() async {
    isLoading = true;
    notifyListeners();
    final response = await AuthenticationRepo(
      ApiService(),
    ).verifyOtp({"email": emailController.text, "otp": otpController.text});
    isLoading = false;

    notifyListeners();
    return response;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading = true;
    notifyListeners();
    final response = await AuthenticationRepo(ApiService()).login({
      "email": email,
      "password": password,
      "device_token": "test-token-12345",
    });
    if (response["message"] != null) {
      prefs.setString('authToken', response["access_token"]);
      prefs.setString('refreshToken', response["refresh_token"].toString());
      prefs.setBool("isGoogleLogin", false);
      emailController.clear();
      passwordController.clear();
      notifyListeners();
    } else {
      debugPrint("Login failed: ${response["message"]}");
    }
    isLoading = false;
    notifyListeners();
    return response;
  }

  // //forgot password
  Future<Map<String, dynamic>> sendOtp() async {
    final response = await AuthenticationRepo(
      ApiService(),
    ).forgotPassword({"email": emailController.text});

    return response;
  }

  // Future<Map<String, dynamic>> verifyOtp(String email) async {
  //   isLoading = true;
  //   notifyListeners();
  //   final response = await AuthenticationRepo(
  //     ApiService(),
  //   ).verifyOtp({"email": emailController.text, "otp": otpController.text});
  //   isLoading = false;
  //   notifyListeners();
  //   return response;
  // }

  Future<Map<String, dynamic>> resetPassword() async {
    isLoading = true;
    notifyListeners();
    final response = await AuthenticationRepo(ApiService()).resetPassword({
      "email": emailController.text,
      "password": passwordController.text,
    });
    emailController.clear();
    passwordController.clear();
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future<Map<String, dynamic>> signUpGoogle(User status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading = true;

    notifyListeners();
    final response = await AuthenticationRepo(ApiService()).loginGoogle(
      status.phoneNumber == null
          ? {
              "email": status.email!,
              "full_name": status.displayName!,
              "avatar": status.photoURL!,
            }
          : {
              "email": status.email!,
              "mobile": status.phoneNumber!,
              "full_name": status.displayName!,
              "avatar": status.photoURL!,
            },
    );
    print(response);
    if (response["message"] != null) {
      prefs.setString('authToken', response["access_token"]);
      prefs.setString('refreshToken', response["refresh_token"].toString());
      prefs.setBool("isGoogleLogin", true);
      emailController.clear();
      passwordController.clear();
      notifyListeners();
    } else {
      debugPrint("Login failed: ${response["message"]}");
    }
    isLoading = false;
    notifyListeners();
    return response;
  }
}
