import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/screens/protected/home_screen/controller/home_controller.dart';

class ReferralCodeSection extends StatelessWidget {
  final HomeController controller;

  const ReferralCodeSection({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8).copyWith(top: 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Referral Code',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Obx(() {
                  final referralCode = controller.profile.value.data == null
                      ? "N/A"
                      : controller.profile.value.data!.referralCode ?? "N/A";
                  return Text(
                    referralCode,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                final code = controller.profile.value.data == null
                    ? ""
                    : controller.profile.value.data!.referralCode ?? "";
                Clipboard.setData(ClipboardData(text: code));
                CustomSnackbar.show(context, message: "Code copied: $code");
              },
              child: SvgPicture.asset(
                'lib/assets/icons/copy.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFFD1B26F),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
