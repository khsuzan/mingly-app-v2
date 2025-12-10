import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/screens/auth/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../components/helpers.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Reset Password', style: TextStyle(fontSize: 20)),
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
              'Set New Password',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // New Password field
            Text(
              'New Password',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            PasswordInputField(
              controller: provider.passwordController,
              hintText: 'Enter new password',
            ),
            const SizedBox(height: 24),
            // Confirm Password field
            Text(
              'Confirm Password',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            PasswordInputField(
              controller: provider.retypePasswordController,
              hintText: 'Confirm new password',
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Reset Password',
              onPressed: () async {
                LoadingDialog.show(context);
                final status = await provider.resetPassword();
                if (context.mounted) {
                  if (status["message"] != null) {
                    LoadingDialog.hide(context);
                    CustomSnackbar.show(
                      context,
                      message: status["message"],
                      backgroundColor: Colors.green,
                    );
                    context.go("/login");
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
