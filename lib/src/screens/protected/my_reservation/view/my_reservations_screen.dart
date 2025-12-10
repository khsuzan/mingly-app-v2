import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/helpers.dart';
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
              onRefresh: () {
                controller.fetchReservations();
                return Future.delayed(Duration(milliseconds: 500));
              },
              child: Obx(() {
                if (controller.isLoading.value) {
                  return CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
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
                        child: Center(
                          child: Text(
                            "No orders found",
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
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
                        onPaymentsClick: () {
                          controller.payForReservation(context, {
                            "order_id": item.orderNumber,
                          }, item.venue?.id);
                        },
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
                        Text(
                          "Order: ${orderNumber ?? '-'}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(
                              (255 * 0.7).toInt(),
                            ),
                          ),
                        ),
                        Text(
                          formatDate(date ?? ''),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(
                              (255 * 0.6).toInt(),
                            ),
                          ),
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
                            color: theme.colorScheme.onSurface.withAlpha(
                              (255 * 0.7).toInt(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Total price and status
                      ],
                    ),
                  ),
                ),
                // Favorite icon
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // status chip
                if (status == 'pending' && paymentStatus == 'pending')
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow.withAlpha((255 * 0.1).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Not Confirmed Yet',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (status == 'confirmed' && paymentStatus == 'pending')
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha((255 * 0.1).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Pending Payment',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (status == 'confirmed' && paymentStatus == 'paid')
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha((255 * 0.1).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Confirmed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Text(""),
                Text(
                  "${currency ?? ''} ${(totalAmount ?? 0.0).toStringAsFixed(2)}",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
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
                      onPressed: () {
                        if (status == 'confirmed' &&
                            paymentStatus == 'pending') {
                          onPaymentsClick?.call();
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            status == 'confirmed' && paymentStatus == 'pending'
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withAlpha(
                                (255 * 0.5).toInt(),
                              ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.payment,
                            color:
                                status == 'confirmed' &&
                                    paymentStatus == 'pending'
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withAlpha(
                                    (255 * 0.5).toInt(),
                                  ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Pay Now",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  status == 'confirmed' &&
                                      paymentStatus == 'pending'
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withAlpha(
                                      (255 * 0.5).toInt(),
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
            if (status == 'confirmed' && paymentStatus == 'pending') ...[
              Divider(color: theme.colorScheme.primary.withAlpha(50)),
              Text(
                'Pay now to confirm your reservation',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
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
