import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/screens/auth/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../components/helpers.dart';

class OtpVerficationForgotPassword extends StatelessWidget {
  const OtpVerficationForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('OTP Verification', style: TextStyle(fontSize: 20)),
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
                controller: provider.otpController,
                hintText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 16.h),
            PrimaryButton(
              text: 'Submit',
              onPressed: () async {
                LoadingDialog.show(context);
                final status = await provider.signUpVerifyUserForgot();
                if (status['message'].isNotEmpty) {
                  LoadingDialog.hide(context);
                  CustomSnackbar.show(
                    context,
                    message: status["message"],
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  context.push("/password-reset");
                } else if (status["error"].isNotEmpty) {
                  LoadingDialog.hide(context);
                  CustomSnackbar.show(
                    context,
                    message: status["error"],
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
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
  }
}
