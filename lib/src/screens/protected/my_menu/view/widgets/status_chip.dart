import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String? status;

  const StatusChip({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = (status ?? 'unknown').toUpperCase();
    Color bg;
    final s = status?.toLowerCase() ?? '';
    if (s.isEmpty) {
      bg = theme.colorScheme.surfaceVariant;
    } else if (s.contains('completed') || s.contains('delivered')) {
      bg = Colors.green.shade100;
    } else if (s.contains('pending') || s.contains('processing')) {
      bg = Colors.orange.shade100;
    } else if (s.contains('cancel') || s.contains('failed')) {
      bg = Colors.red.shade100;
    } else {
      bg = theme.colorScheme.surfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
