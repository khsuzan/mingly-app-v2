import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../application/booking/booking_list.dart';
import '../../../../components/helpers.dart';
import '../../../../constant/app_urls.dart';

class BookedTicketDetailScreen extends StatelessWidget {
  final BookingOrder booking;
  const BookedTicketDetailScreen({super.key, required this.booking});

  Widget _buildHeader(BuildContext context) {
    final image = booking.event.images.firstOrNull?.imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: image != null
              ? Image.network(
                  AppUrls.imageUrl + image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const NoImage(),
                )
              : const NoImage(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
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

  Widget _buildTicketTile(BuildContext context, Ticket t) {
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
                    'Ticket #${t.ticketId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  if (t.seatNumber.isNotEmpty) Text('Seat: ${t.seatNumber}'),
                  Text('Qty: ${t.quantity ?? 1}'),
                  const SizedBox(height: 6),
                  Text(
                    '${booking.currency} ${t.unitPrice.toStringAsFixed(2)} each',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${booking.currency} ${t.totalAmount.toStringAsFixed(2)}',
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                    'Tickets',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (booking.tickets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text('No tickets found.'),
                    )
                  else
                    Column(
                      children: booking.tickets
                          .map((t) => _buildTicketTile(context, t))
                          .toList(),
                    ),

                  const SizedBox(height: 12),
                  const Text(
                    'Event details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            style: const TextStyle(fontWeight: FontWeight.w600),
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
  }
}
