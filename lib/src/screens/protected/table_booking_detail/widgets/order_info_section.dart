import 'package:flutter/material.dart';
import 'package:mingly/src/application/booking/model/order_detail.dart';
import 'package:mingly/src/components/helpers.dart';

class OrderInfoSection extends StatelessWidget {
  final OrderDetailResponse orderDetail;

  const OrderInfoSection({required this.orderDetail, super.key});

  Color _getStatusColor(String? status) {
    final lowerStatus = (status ?? '').toLowerCase();
    if (lowerStatus.contains('completed') ||
        lowerStatus.contains('confirmed')) {
      return Colors.green;
    } else if (lowerStatus.contains('pending')) {
      return Colors.orange;
    } else if (lowerStatus.contains('cancelled')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  Color _getPaymentStatusColor(String? status) {
    final lowerStatus = (status ?? '').toLowerCase();
    if (lowerStatus.contains('paid')) {
      return Colors.green;
    } else if (lowerStatus.contains('pending')) {
      return Colors.orange;
    } else if (lowerStatus.contains('failed')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order #${orderDetail.orderNumber ?? "N/A"}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(orderDetail.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (orderDetail.status ?? 'N/A').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getPaymentStatusColor(orderDetail.paymentStatus),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  (orderDetail.paymentStatus ?? 'N/A').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Order Date',
            orderDetail.createdAt != null
                ? formatDateTime(
                    orderDetail.createdAt!.toUtc().toIso8601String(),
                  )
                : 'N/A',
          ),
          _buildInfoRow(
            'Subtotal',
            '${orderDetail.currency ?? "N/A"} ${orderDetail.subtotal?.toStringAsFixed(2) ?? "0.00"}',
          ),
          if (orderDetail.discountAmount != null &&
              orderDetail.discountAmount! > 0)
            _buildInfoRow(
              'Discount',
              '-${orderDetail.currency ?? "N/A"} ${orderDetail.discountAmount!.toStringAsFixed(2)}',
            ),
          if (orderDetail.serviceCharge != null &&
              orderDetail.serviceCharge! > 0)
            _buildInfoRow(
              'Service Charge',
              '${orderDetail.currency ?? "N/A"} ${orderDetail.serviceCharge!.toStringAsFixed(2)}',
            ),
          Divider(height: 16, color: Colors.grey.withAlpha(30)),
          _buildInfoRow(
            'Total Amount',
            '${orderDetail.currency ?? "N/A"} ${orderDetail.totalAmount?.toStringAsFixed(2) ?? "0.00"}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                fontSize: isBold ? 14 : 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
