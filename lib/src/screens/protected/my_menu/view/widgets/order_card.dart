import 'package:flutter/material.dart';
import 'status_chip.dart';
import 'order_item_row.dart';

class OrderCard extends StatelessWidget {
  final dynamic order;
  final bool isExpanded;
  final VoidCallback onTap;
  final String formattedDate;

  const OrderCard({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.onTap,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.orderNumber ?? 'Order #${order.id ?? '-'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerInfo?.name ?? '',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formattedDate,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${order.currency ?? ''} ${order.totalAmount ?? order.subtotal ?? ''}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((order.items ?? <dynamic>[]).isNotEmpty)
                              ...((order.items ?? <dynamic>[]) as List).map(
                                (item) => OrderItemRow(item: item),
                              ),
                            const Divider(color: Colors.white30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if ((order.notes ?? '').isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 6.0,
                                        ),
                                        child: Text(
                                          'Notes: ${order.notes}',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    Text(
                                      'Payment: ${order.paymentStatus ?? '-'}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Subtotal: ${order.currency ?? ''} ${order.subtotal ?? ''}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Total: ${order.currency ?? ''} ${order.totalAmount ?? ''}',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
