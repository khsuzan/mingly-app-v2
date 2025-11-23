import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/authentication/authentiation_repo/authentication_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_service/firebae_google_signup.dart';
import '../../../../components/custom_snackbar.dart';

class WelcomeController extends GetxController {
  final FirebaseServices firebaseServices = FirebaseServices();
  final repo = AuthenticationRepo(ApiService());
  final isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      final status = await firebaseServices.signInWithGoogle();
      debugPrint("status $status");
      if (status != null) {
        final data = await _signWIthGoogle(status);
        if (!context.mounted) {
          debugPrint("Context not mounted");
          return;
        }
        if (data['message'] != null) {
          CustomSnackbar.show(
            context,
            message: data["message"],
            textColor: Colors.white,
            backgroundColor: Colors.green,
          );
          context.push("/home");
        } else if (data["error"] != null) {
          CustomSnackbar.show(
            context,
            message: data["error"],
            backgroundColor: Colors.red,
          );
        }
      } else {
        if (!context.mounted) {
          debugPrint("Context not mounted");
          return;
        }
        CustomSnackbar.show(context, message: "Somthing wrong, try again.");
      }
      debugPrint("done$status");
    } catch (e) {
      debugPrint("Error in Google Sign-In: $e");
    }
  }

  Future<Map<String, dynamic>> _signWIthGoogle(User status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoading.value = true;

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
    debugPrint(response.toString());
    if (response["message"] != null) {
      prefs.setString('authToken', response["access_token"]);
      prefs.setString('refreshToken', response["refresh_token"].toString());
      prefs.setBool("isGoogleLogin", true);
      emailController.clear();
      passwordController.clear();
    } else {
      debugPrint("Login failed: ${response["message"]}");
    }
    isLoading.value = false;
    return response;
  }
}
