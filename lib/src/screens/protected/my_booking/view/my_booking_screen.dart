import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';

import '../controller/my_booking_controller.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<MyBookingController>(
      init: MyBookingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            automaticallyImplyLeading: false,
            title: Text(
              'My Booking List',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchBookings();
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
                    return _BookingOrderCard(
                      orderNumber: item.orderNumber,
                      title: item.event.eventName,
                      location: item.event.venue.name,
                      imagePath: item.event.images.firstOrNull?.imageUrl ?? '',
                      date: formatDate(item.createdAt?.toIso8601String() ?? ''),
                      status: item.status,
                      paymentStatus: item.paymentStatus,
                      totalAmount: item.totalAmount,
                      currency: item.currency,
                      venueId: item.event.venue.id,
                      ticketsCount: item.tickets.firstOrNull?.quantity ?? 0,
                      tablesCount: item.tables.length,
                      onTicketsClick: () {
                        context.push('/ticket-booking-detail', extra: item);
                      },
                      onTablesClick: () {
                        context.push('/table-booking-detail', extra: item);
                      },
                      onVenueMenuClick: () {
                        context.push('/venue-menu', extra: item.event.venue.id);
                      },
                      continueBooking: () {
                        controller.continueBooking(
                          context,
                          item.orderNumber,
                          item.event.venue.id,
                        );
                      },
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

class _BookingOrderCard extends StatelessWidget {
  final String orderNumber;
  final String title;
  final String location;
  final String imagePath;
  final String date;
  final String status;
  final String paymentStatus;
  final double totalAmount;
  final String currency;
  final int venueId;
  final int ticketsCount;
  final int tablesCount;
  final VoidCallback? onTicketsClick;
  final VoidCallback? onTablesClick;
  final VoidCallback? onVenueMenuClick;
  final VoidCallback? continueBooking;

  const _BookingOrderCard({
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
    this.ticketsCount = 0,
    this.tablesCount = 0,
    this.onTicketsClick,
    this.onTablesClick,
    this.onVenueMenuClick,
    this.continueBooking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = "${AppUrls.imageUrl}$imagePath";

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
                    errorBuilder: (ctx, err, st) =>
                        SizedBox(width: 110, height: 110, child: NoImage()),
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
                                "Order: $orderNumber",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    (255 * 0.7).toInt(),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              date,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withAlpha(
                                  (255 * 0.6).toInt(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Event title
                        Text(
                          title,
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
                          location,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(
                              (255 * 0.7).toInt(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Total price and status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$currency ${totalAmount.toStringAsFixed(2)}",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              status,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: status.toLowerCase() == "confirmed"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.w600,
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
            if (status.toLowerCase() != 'cancelled')
              const Divider(height: 1, color: Colors.white24),

            if (paymentStatus.toLowerCase() != 'paid' &&
                status.toLowerCase() != 'cancelled')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(
                          (255 * 0.1).toInt(),
                        ),
                      ),
                      child: Text('Unpaid'),
                    ),
                    PrimaryButtonSmall(
                      text: 'Pay Now',
                      onPressed: () {
                        continueBooking?.call();
                      },
                    ),
                  ],
                ),
              ),
            // Bottom row: Tickets | Tables | Menu
            if (paymentStatus.toLowerCase() == 'paid')
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Tickets
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          onTicketsClick?.call();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: ticketsCount > 0
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withAlpha(
                                  (255 * 0.5).toInt(),
                                ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.confirmation_num_outlined,
                              color: ticketsCount > 0
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withAlpha(
                                      (255 * (255 * 0.5).toInt()),
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tickets",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: ticketsCount > 0
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface.withAlpha(
                                        (255 * (255 * 0.5).toInt()),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tables
                    Expanded(
                      child: TextButton(
                        onPressed: tablesCount > 0
                            ? () {
                                onTablesClick?.call();
                              }
                            : () {
                                CustomSnackbar.show(
                                  context,
                                  message: "No tables booked for this order",
                                  backgroundColor: Colors.orange,
                                );
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: tablesCount > 0
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withAlpha(
                                  (255 * 0.5).toInt(),
                                ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.table_restaurant,
                              color: tablesCount > 0
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withAlpha(
                                      (255 * 0.5).toInt(),
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tables",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: tablesCount > 0
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withAlpha(
                                        (255 * (255 * 0.5).toInt()),
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
}
