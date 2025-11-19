import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/helpers.dart';
import 'controller/otp_verification_controller.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<OtpVerificationController>(
      init: OtpVerificationController(email: email),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 20),
            ),
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Verify OTP',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter OTP sent via Email. We have sent OTP to email@gmail.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 14.sp,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleLineTextField(
                    controller: controller.otpController,
                    hintText: 'Enter OTP',
                  ),
                ),
                SizedBox(height: 16.h),
                PrimaryButton(
                  text: 'Submit',
                  onPressed: () {
                    controller.signUpVerifyUser(context);
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Resend OTP',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
