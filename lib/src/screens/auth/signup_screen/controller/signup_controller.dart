import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/authentication/authentiation_repo/authentication_repo.dart';

import '../../../../components/custom_loading_dialog.dart';
import '../../../../components/custom_snackbar.dart';

class SignupController extends GetxController {
  final isLoading = false.obs;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final repo = AuthenticationRepo(ApiService());

  Future signUpUser(BuildContext context) async {
    try {
      LoadingDialog.show(context);
      isLoading.value = true;
      final email = emailController.text;
      final response = await repo.signUp({
        "email": email,
        "password": passwordController.text,
      });
      debugPrint("Signup Response: $response");
      if (response['message'] != null && context.mounted) {
        CustomSnackbar.show(
          context,
          message: response["message"],
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        context.push("/otp-verification", extra: emailController.text);
      }
      isLoading.value = false;
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint('Signup Error: $e');
      debugPrintStack(stackTrace: stack);
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
    // Handle sign-up logic here
  }
}
