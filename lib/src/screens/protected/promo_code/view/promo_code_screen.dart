import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/helpers.dart';

import '../controller/promo_code_controller.dart';

class PromoCodeScreen extends StatelessWidget {
  const PromoCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<PromoCodeController>(
      init: PromoCodeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            automaticallyImplyLeading: false,
            title: Text(
              'Promo Codes',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () {
              controller.fetchPromoCodes();
              return Future.delayed(const Duration(milliseconds: 800));
            },
            child: Obx(() {
              if (controller.isLoading.value) {
                return CustomScrollView(
                  slivers: [
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                );
              }
              if (controller.promoCodes.isEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No promo codes available',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                );
              }
              final codes = controller.promoCodes;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: codes.length,
                itemBuilder: (context, index) {
                  final promo = codes[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: theme.colorScheme.primary.withAlpha(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promo.code ?? "",
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${promo.discountValue ?? ''} OFF",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          PrimaryButton(
                            text: 'Apply',
                            onPressed: () => context.pop(promo),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}
