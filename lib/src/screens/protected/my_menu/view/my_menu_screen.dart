import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/my_menu_controller.dart';
import 'widgets/order_card.dart';

class MyMenuScreen extends StatelessWidget {
  const MyMenuScreen({super.key});

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.toLocal();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  // UI helpers were moved into separate widgets for better organization.

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetX<MyMenuController>(
      init: MyMenuController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            title: Text(
              'My Menu',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child:
                  // Obx(() {
                  (controller.isLoading.value)
                  ? const Center(child: CircularProgressIndicator())
                  : controller.menuList.isEmpty
                  ? Center(
                      child: Text(
                        'No orders yet',
                        style: theme.textTheme.titleMedium,
                      ),
                    )
                  : Obx(() {
                      final expandedIndices = controller.expandedIndices;
                      debugPrint(expandedIndices.toString());
                      return ListView.separated(
                        itemCount: controller.menuList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final order = controller.menuList[index];
                          final isExpanded = expandedIndices.contains(index);
                          debugPrint(isExpanded.toString());
                          return OrderCard(
                            order: order,
                            isExpanded: isExpanded,
                            onTap: () {
                              if (isExpanded) {
                                controller.expandedIndices.remove(index);
                              } else {
                                controller.expandedIndices.add(index);
                              }
                            },
                            formattedDate: _formatDateTime(order.createdAt),
                          );
                        },
                      );
                    }),
            ),
          ),
        );
      },
    );
  }
}
