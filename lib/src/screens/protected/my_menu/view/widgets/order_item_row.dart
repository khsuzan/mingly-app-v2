import 'package:flutter/material.dart';
import 'package:mingly/src/constant/app_urls.dart';

class OrderItemRow extends StatelessWidget {
  final dynamic item;

  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = (item == null || item.image == null || (item.image is String && (item.image as String).isEmpty)) ? null : item.image as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                AppUrls.imageUrl + imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 56,
                  height: 56,
                  color: theme.colorScheme.surfaceVariant,
                  child: Icon(Icons.fastfood, color: theme.hintColor),
                ),
              ),
            )
          else
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.fastfood, color: theme.hintColor),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item?.name ?? '-', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${item?.unitPrice ?? ''} x ${item?.quantity ?? 1}', style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(item?.totalAmount ?? item?.subtotal ?? '', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
