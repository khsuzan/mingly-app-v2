import 'package:flutter/material.dart';
import 'package:mingly/src/application/booking/model/order_detail.dart';
import 'package:mingly/src/components/helpers.dart';

class ItemsSection extends StatelessWidget {
  final OrderDetailResponse orderDetail;

  const ItemsSection({required this.orderDetail, super.key});

  @override
  Widget build(BuildContext context) {
    final items = orderDetail.items ?? [];

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No items found.'),
      );
    }

    // Get customer info from first item (all items have same customer)
    final customerInfo = items.isNotEmpty ? items.first.customerInfo : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer info section (shown once at the top)
          if (customerInfo != null) ...[
            Text(
              'Booking for',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary.withAlpha(20),
                border: Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (customerInfo.fullName != null &&
                      customerInfo.fullName!.isNotEmpty)
                    Text(
                      customerInfo.fullName!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (customerInfo.email != null &&
                      customerInfo.email!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      customerInfo.email!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                  if (customerInfo.mobile != null &&
                      customerInfo.mobile!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      customerInfo.mobile!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Tickets section
          Text(
            'Your Tickets',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _buildTicketCard(context, items[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, OrderItem item, int index) {
    final hasSession = item.esession != null;
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.primary.withAlpha(20),
        border: Border(left: BorderSide(color: accentColor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket title
            Text(
              item.title ?? 'Ticket',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 12),

            // Session details if available (time and date)
            if (hasSession) ...[
              _buildSessionRow(item.esession!),
              const SizedBox(height: 12),
            ],

            // Divider
            Container(height: 1, color: Colors.grey.withAlpha(30)),
            const SizedBox(height: 12),

            // Quantity and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Qty',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (item.quantity ?? 1).toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${orderDetail.currency} ${item.subtotal?.toStringAsFixed(2) ?? "0.00"}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionRow(EventSession session) {
    final startTime = session.sessionStartTime ?? 'N/A';
    final endTime = session.sessionEndTime ?? 'N/A';
    final bookingDate = session.firstSessionDate ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time row
        Row(
          children: [
            const Icon(Icons.schedule, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${formatTimeToAmPm(startTime)} - ${formatTimeToAmPm(endTime)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Date row
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                bookingDate,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
