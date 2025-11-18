import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_snackbar.dart';

import '../../../../constant/app_urls.dart';
import '../controller/my_reservations_controller.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<MyReservationsController>(
      init: MyReservationsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: Text(
              'My Reservations',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            centerTitle: true,
            elevation: 1,
            backgroundColor: theme.scaffoldBackgroundColor,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchReservations();
                return Future.delayed(Duration(seconds: 1));
              },
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
                if (controller.reservationList.isEmpty) {
                  return CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text("No orders found")),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  itemBuilder: (context, index) {
                    if (index == controller.reservationList.length) {
                      return const SizedBox(height: 80); // footer gap
                    }
                    final item = controller.reservationList[index];
                    return InkWell(
                      // onTap: () => context.push('/event-detail'),
                      child: _ReservationOrderCard(
                        orderNumber: item.orderNumber,
                        title: item.venue?.name,
                        location: item.venue?.city,
                        imagePath: item.venue?.images?.firstOrNull?.imageUrl,
                        date: item.createdAt,
                        status: item.status,
                        paymentStatus: item.paymentStatus,
                        totalAmount: item.totalAmount,
                        currency: item.currency,
                        venueId: item.venue?.id,
                        onVenueMenuClick: () {},
                        onPaymentsClick: () {},
                      ),
                    );
                  },

                  itemCount: controller.reservationList.length + 1,
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class _ReservationOrderCard extends StatelessWidget {
  final String? orderNumber;
  final String? title;
  final String? location;
  final String? imagePath;
  final String? date;
  final String? status;
  final String? paymentStatus;
  final double? totalAmount;
  final String? currency;
  final int? venueId;
  final VoidCallback? onPaymentsClick;
  final VoidCallback? onVenueMenuClick;

  const _ReservationOrderCard({
    required this.orderNumber,
    required this.title,
    required this.location,
    required this.imagePath,
    required this.date,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.currency,
    required this.venueId,
    this.onPaymentsClick,
    this.onVenueMenuClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imgPath = imagePath ?? '';
    final imageUrl = (imgPath.isEmpty)
        ? "https://www.directmobilityonline.co.uk/assets/img/noimage.png"
        : "${AppUrls.imageUrl}$imgPath";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            // Top row: image + details + favorite
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order number and date row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Order: ${orderNumber ?? '-'}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            ),
                            Text(
                              date ?? '',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Event title
                        Text(
                          title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Location / venue
                        Text(
                          location ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Total price and status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${currency ?? ''} ${(totalAmount ?? 0.0).toStringAsFixed(2)}",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // status chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (status ?? '').toLowerCase() == 'confirmed'
                                    ? Colors.green.shade100
                                    : (status ?? '').toLowerCase() == 'pending'
                                    ? Colors.orange.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                (status ?? 'unknown').toUpperCase(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Favorite icon
              ],
            ),

            const Divider(height: 1, color: Colors.white24),

            // Bottom row: Tickets | Tables | Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Tickets
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pendingStatusText(paymentStatus) ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tables
                  Expanded(
                    child: TextButton(
                      onPressed: onPaymentsClick,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            pendingStatusText(paymentStatus) == "Unpaid"
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.payment,
                            color: pendingStatusText(paymentStatus) == "Unpaid"
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Pay Now",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  pendingStatusText(paymentStatus) == "Unpaid"
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Menu
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // navigate to venue menu by id
                        // route: /venue-menu/{venueId}
                        onVenueMenuClick?.call();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Text("Menu", style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? pendingStatusText(String? text) {
    final t = text?.trim().toLowerCase() ?? '';
    switch (t) {
      case 'pending':
        return 'Unpaid';
      case 'paid':
        return 'Paid';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return text;
    }
  }
}
