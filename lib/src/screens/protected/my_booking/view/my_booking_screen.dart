import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/my_booking/reservation_provider.dart';
import 'package:provider/provider.dart';

import '../controller/my_booking_controller.dart';

class MyReservationScreen extends StatelessWidget {
  const MyReservationScreen({super.key});

  //   @override
  //   Widget build(BuildContext context) {
  //     return ChangeNotifierProvider(
  //       create: (_) => ReservationProvider()..getFavouriteList(),
  //       child: _Layout(),
  //     );
  //   }
  // }

  // class _Layout extends StatelessWidget {
  //   const _Layout();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(MyBookingController());

    // final provider = context.watch<ReservationProvider>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Bookings',
                  style: TextStyle(
                    color: theme.colorScheme.surface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ✅ Fix: Wrap ListView with Expanded
            Obx(() {
              return controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: controller.reservationList.isEmpty
                          ? Center(child: Text("No reservation"))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              itemBuilder: (context, index) {
                                final item = controller.reservationList[index];
                                return InkWell(
                                  onTap: () => context.push('/event-detail'),
                                  child: _BookingOrderCard(
                                    orderNumber: item.orderNumber,
                                    title: item.event.eventName,
                                    location: item.event.venue.name,
                                    imagePath:
                                        item
                                            .event
                                            .images
                                            .firstOrNull
                                            ?.imageUrl ??
                                        '',
                                    date: formatDate(
                                      item.createdAt?.toIso8601String() ?? '',
                                    ),
                                    status: item.status,
                                    totalAmount: item.totalAmount,
                                    currency: item.currency,
                                    venueId: item.event.venue.id,
                                    ticketsCount: item.items.length,
                                    hasTables:false,
                                        // (item.tablesBooked != null &&
                                        // item.tablesBooked! > 0),
                                    onFavoritePressed: () {
                                      CustomSnackbar.show(
                                        context,
                                        message:
                                            "Added to favourites (mock action)",
                                      );
                                    },
                                  ),
                                );
                              },

                              itemCount: controller.reservationList.length,
                            ),
                    );
            }),
          ],
        ),
      ),
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
  final double totalAmount;
  final String currency;
  final int venueId;
  final int ticketsCount;
  final bool hasTables;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onTap;

  const _BookingOrderCard({
    required this.orderNumber,
    required this.title,
    required this.location,
    required this.imagePath,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.currency,
    required this.venueId,
    this.ticketsCount = 0,
    this.hasTables = false,
    this.onFavoritePressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = (imagePath.isEmpty)
        ? "https://www.directmobilityonline.co.uk/assets/img/noimage.png"
        : "${AppUrls.imageUrl}$imagePath";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                              Text(
                                "Order: $orderNumber",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(
                                date,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
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
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 4),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: theme.colorScheme.primary,
                      onPressed: onFavoritePressed,
                    ),
                  ),
                ],
              ),

              const Divider(height: 1),

              // Bottom row: Tickets | Tables | Menu
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
                          // navigate to booking tickets for this order
                          // route: /booking-tickets/{orderNumber}
                          context.push('/booking-tickets/$orderNumber');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.confirmation_num_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tickets (${ticketsCount})",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tables
                    Expanded(
                      child: TextButton(
                        onPressed: hasTables
                            ? () {
                                // navigate to tables for this order
                                // route: /booking-tables/{orderNumber}
                                context.push('/booking-tables/$orderNumber');
                              }
                            : () {
                                CustomSnackbar.show(
                                  context,
                                  message: "No tables booked for this order",
                                  backgroundColor: Colors.orange,
                                );
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: hasTables
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.table_restaurant,
                              color: hasTables
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text("Tables", style: theme.textTheme.bodySmall),
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
                          context.push('/venue-menu/$venueId');
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
      ),
    );
  }
}
