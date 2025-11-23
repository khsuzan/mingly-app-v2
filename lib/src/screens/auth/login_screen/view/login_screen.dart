import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/screens/auth/login_screen/controller/login_controller.dart';

import '../../../../components/helpers.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Welcome Back!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Use credentials to access your account',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Username field
              SingleLineTextField(
                focusNode: controller.emailFocusNode,
                controller: controller.emailController,
                hintText: "Enter Email",
                prefixSvg: SvgPicture.asset(
                  'lib/assets/icons/people.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password field
              PasswordInputField(
                focusNode: controller.passwordFocusNode,
                controller: controller.passwordController,
                hintText: "Enter Password",

                prefixSvg: SvgPicture.asset(
                  'lib/assets/icons/lock.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Login button
              PrimaryButton(
                text: 'Login',
                onPressed: () {
                  if (controller.emailFocusNode.hasFocus ||
                      controller.passwordFocusNode.hasFocus) {
                    controller.emailFocusNode.unfocus();
                    controller.passwordFocusNode.unfocus();
                  }
                  controller.login(context);
                },
              ),
              const SizedBox(height: 32),
              // Forgot password section
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Forgot password?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        context.push("/email-verification");
                      },
                      child: Text(
                        'Reset',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
