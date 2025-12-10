import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mingly/src/components/helpers.dart';

import '../controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final provider = context.watch<NotificationProvider>();
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            automaticallyImplyLeading: false,
            title: Text(
              'Notifications',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: RefreshIndicator(
              onRefresh: () => controller.getNotificationData(),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (controller.notifications.isEmpty) {
                  return CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            " No Notifications Found",
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return SafeArea(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0, bottom: 32),
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == controller.notifications.length - 1
                              ? 32.0
                              : 8.0,
                          top: 8.0,
                          left: 0,
                          right: 0,
                        ),
                        child: _NotificationItem(
                          icon: Icons.calendar_today,
                          title: notification.title.toString(),
                          subtitle: notification.message.toString(),
                          date: notification.createdAt.toString(),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String date;
  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatDateTime(date),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
