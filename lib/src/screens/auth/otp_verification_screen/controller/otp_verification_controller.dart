import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/authentication/authentiation_repo/authentication_repo.dart';

import '../../../../components/custom_loading_dialog.dart';
import '../../../../components/custom_snackbar.dart';

class OtpVerificationController extends GetxController {
  TextEditingController otpController = TextEditingController();

  final repo = AuthenticationRepo(ApiService());
  final String email;
  OtpVerificationController({this.email = ''});

  Future signUpVerifyUser(BuildContext context) async {
    LoadingDialog.show(context);
    try {
      final response = await repo.verifyOtp({
        "email": email,
        "otp": otpController.text,
      });
      debugPrint("OTP Verification Response: $response");
      if (response['message'].isNotEmpty) {
        if (context.mounted) {
          CustomSnackbar.show(
            context,
            message: response["message"],
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          context.push("/login");
        }
      } else if (response["error"].isNotEmpty) {
        if (context.mounted) {
          LoadingDialog.hide(context);
          CustomSnackbar.show(
            context,
            message: response["error"],
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    } catch (e, stack) {
      debugPrint("OTP Verification Error: $e");
      debugPrintStack(stackTrace: stack);
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }
}
