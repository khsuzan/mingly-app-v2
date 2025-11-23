import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../application/booking/booking_list.dart';
import '../../../../components/helpers.dart';
import '../../../../constant/app_urls.dart';
import '../../table_booking_screen/controller/table_booking_controller.dart';

class TableBookingDetail extends StatelessWidget {
  final BookingOrder booking;

  const TableBookingDetail({super.key, required this.booking});

  Widget _buildHeader(BuildContext context) {
    // Prefer explicit table image supplied by controller; otherwise use event image.
    final image = (booking.event.images.isNotEmpty
        ? booking.event.images.first.imageUrl
        : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: image != null && image.startsWith('http')
              ? Image.network(AppUrls.imageUrl + image, fit: BoxFit.cover)
              : const NoImage(),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.event.eventName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    '${booking.event.venue.name}, ${booking.event.venue.city}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableTile(BuildContext context, TableReservation t) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Table: ${t.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('Seats: ${t.description ?? ""}'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${booking.currency} ${((t.totalAmount ?? t.subtotal) ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<TableBookingController>(
      init: TableBookingController(eventId: '${booking.event.id}'),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            title: Text(
              'Booking Details',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order: ${booking.orderNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(booking.status.toUpperCase()),
                                    backgroundColor: theme.colorScheme.primary,
                                    side: BorderSide.none,
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      booking.paymentStatus.toUpperCase(),
                                    ),
                                    side: BorderSide.none,
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Created',
                                booking.createdAt != null
                                    ? formatDateTime(
                                        booking.createdAt!
                                            .toUtc()
                                            .toIso8601String(),
                                      )
                                    : '-',
                              ),
                              _buildInfoRow(
                                'Subtotal',
                                '${booking.currency} ${booking.subtotal.toStringAsFixed(2)}',
                              ),
                              _buildInfoRow(
                                'Total',
                                '${booking.currency} ${booking.totalAmount.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        'Tables',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (booking.tables.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('No table reservations found.'),
                        )
                      else
                        Column(
                          children: booking.tables
                              .map((t) => _buildTableTile(context, t))
                              .toList(),
                        ),

                      const SizedBox(height: 12),

                      const Text(
                        'Seating Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() {
                        final seatingPlan =
                            controller.detail.value.others?.seatingPlan;
                        return SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            '${AppUrls.imageUrl}$seatingPlan',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(
                                height: 100.h,
                                child: Center(
                                  child: Text("Seat plan not available"),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      const Text(
                        'Event details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.event.about,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(booking.event.description),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Venue',
                                '${booking.event.venue.name} (${booking.event.venue.city})',
                              ),
                              _buildInfoRow(
                                'Capacity',
                                booking.event.venue.capacity.toString(),
                              ),
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
      },
    );
  }
}
