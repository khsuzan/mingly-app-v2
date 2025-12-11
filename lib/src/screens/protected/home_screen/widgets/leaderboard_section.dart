import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mingly/src/screens/protected/home_screen/controller/home_controller.dart';
import 'leader_board.dart';
import 'leaderboard_placeholder.dart';

class LeaderboardSection extends StatelessWidget {
  final HomeController controller;
  final BuildContext context;

  const LeaderboardSection({
    required this.controller,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Leaderboard',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: 13.sp,
                ),
              ),
              Text(
                'Ultra VIP 10',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.topSpendersList.length >= 3) {
            return Leaderboard(
              data: controller.topSpendersList,
            );
          }
          return LeaderboardPlaceholder(
            count: controller.topSpendersList.length,
            onInvite: () {
              SharePlus.instance.share(
                ShareParams(
                  text:
                      'Discover great local events, venues and exclusive offers with Mingly!\n\nFind and book tables, earn rewards, and get personalised recommendations.\n\nDownload the app: https://mingly.org',
                ),
              );
            },
            onHowToEarn: () => context.push('/membership'),
          );
        }),
      ],
    );
  }
}
