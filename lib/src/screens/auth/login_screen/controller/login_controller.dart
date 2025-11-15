import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/screens/auth/auth_provider.dart';

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

  final AuthProvider _authService = AuthProvider();

  final isLoading = false.obs;

  void login(BuildContext context) async {
    isLoading.value = true;
    try {
      LoadingDialog.show(context);
      await _authService.login(emailController.text, passwordController.text);
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
