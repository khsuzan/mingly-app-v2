import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/screens/auth/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../components/helpers.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Email Verification',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
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
              'Verify your Account',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Enter your email to receive a verification code',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 14.sp,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 48),
            SingleLineTextField(
              controller: provider.emailController,
              hintText: "Enter Email",
              prefixSvg: SvgPicture.asset(
                'lib/assets/icons/profile.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            PrimaryButton(
              text: 'Send OTP',
              onPressed: () async {
                LoadingDialog.show(context);
                final status = await provider.sendOtp();
                if (context.mounted) {
                  if (status["message"] != null) {
                    LoadingDialog.hide(context);
                    CustomSnackbar.show(
                      context,
                      message: status["message"],
                      backgroundColor: Colors.green,
                    );
                    context.push("/otp-verification-forgot-password");
                  } else if (status["errors"] != null) {
                    LoadingDialog.hide(context);
                    CustomSnackbar.show(
                      context,
                      message: status["errors"],
                      backgroundColor: Colors.red,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
