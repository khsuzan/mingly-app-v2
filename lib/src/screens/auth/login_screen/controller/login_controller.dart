import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_service/api_service.dart';
import '../../../../application/authentication/authentiation_repo/authentication_repo.dart';
import '../../../../components/custom_loading_dialog.dart';
import '../../../../components/custom_snackbar.dart';

class LoginController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final AuthenticationRepo repo = AuthenticationRepo(ApiService());

  final isLoading = false.obs;

  void login(BuildContext context) async {
    isLoading.value = true;
    try {
      if (context.mounted) {
        LoadingDialog.show(context);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await repo.login({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "device_token": "test-token-12345",
      });
      prefs.setString('authToken', response.accessToken);
      prefs.setString('refreshToken', response.refreshToken.toString());
      prefs.setBool("isGoogleLogin", false);
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        context.push('/home');
      }
    } catch (e) {
      if (context.mounted) {
        LoadingDialog.hide(context);
        CustomSnackbar.show(
          context,
          message: "Something went wrong. Please try again.",
          backgroundColor: Colors.red,
        );
      }
      debugPrint("Login error: $e");
    }
  }
}
