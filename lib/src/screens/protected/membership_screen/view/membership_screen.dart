import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/screens/protected/membership_screen/controller/membership_controller.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  Color _tierColor(String? tier) {
    switch (tier) {
      case 'lite':
        return Colors.grey.shade300;
      case 'vip_lite':
        return Colors.purple.shade200;
      case 'bronze':
        return const Color(0xffCD7F32);
      case 'silver':
        return const Color(0xffC0C0C0);
      case 'platinum':
        return const Color(0xffE5E4E2);
      default:
        return Colors.blueGrey;
    }
  }

  String _beautifyTier(String? tier) {
    if (tier == null) return '';
    return tier
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<MembershipController>(
      init: MembershipController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Membership Details',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RefreshIndicator(
              onRefresh: () {
                controller.fetchData();
                return Future.delayed(Duration(milliseconds: 500));
              },
              child: Obx(() {
                final list = controller.membershipList;
                final selected = controller.selectedIndex.value;
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
                return CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CarouselSlider.builder(
                            itemCount: list.length,
                            itemBuilder: (ctx, idx, realIdx) {
                              final pkg = list[idx];
                              return Card(
                                color: _tierColor(pkg.tier),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            child: Text(
                                              _beautifyTier(pkg.tier),
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ),
                                          if (controller.currentPackage.value !=
                                                  null &&
                                              controller
                                                      .currentPackage
                                                      .value!
                                                      .id ==
                                                  list[selected].id)
                                            SizedBox(width: 8),
                                          if (controller.currentPackage.value !=
                                                  null &&
                                              controller
                                                      .currentPackage
                                                      .value!
                                                      .id ==
                                                  list[selected].id)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              child: Text(
                                                "Active",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        pkg.productName?.toUpperCase() ?? '',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        pkg.description ?? '',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          if (pkg.price != null)
                                            Text(
                                              '${pkg.currency ?? ''} ${(pkg.price! / 100).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          if (pkg.interval != null) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              '/${pkg.interval}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 200,
                              enlargeCenterPage: true,
                              autoPlay: false,
                              viewportFraction: 0.8,
                              enlargeFactor: 0.2,
                              onPageChanged: controller.onCarouselChanged,
                              initialPage: selected,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Indicator dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(list.length, (idx) {
                              return Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: idx == selected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.primary.withAlpha(50),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),
                          // Features of selected package
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Features',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Card(
                                color: Colors.grey.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Obx(() {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if ((list[selected].features?.isEmpty ??
                                            true))
                                          const Text(
                                            'No features listed',
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ...?list[selected].features?.map(
                                          (f) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 2,
                                            ),
                                            child: Text(
                                              '• $f',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                        if (controller.currentPackage.value ==
                                            null)
                                          PrimaryButton(
                                            text: 'Upgrade Now',
                                            onPressed: () {
                                              controller.buyMembership(context);
                                            },
                                          ),
                                        if (controller.currentPackage.value !=
                                                null &&
                                            controller
                                                    .currentPackage
                                                    .value!
                                                    .id ==
                                                list[selected].id)
                                          PrimaryButton(
                                            text: 'Cancel Subscription',
                                            onPressed: () {
                                              controller.cancelMembership(
                                                context,
                                              );
                                            },
                                          ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
