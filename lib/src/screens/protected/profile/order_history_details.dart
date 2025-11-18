import 'package:flutter/material.dart';
import 'package:mingly/src/screens/protected/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${provider.selectedOrder!.orderNumber.toString()}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event: ${provider.selectedOrder!.eventName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Status: ${provider.selectedOrder!.status}'),
            Text('Payment: ${provider.selectedOrder!.paymentStatus}'),
            Text(
              'Total: ${provider.selectedOrder!.totalAmount} ${provider.selectedOrder!.currency}',
            ),
            const SizedBox(height: 12),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: provider.selectedOrder!.items!.length,
                itemBuilder: (context, index) {
                  final item = provider.selectedOrder!.items![index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text('Seat: ${item.seatNumber}'),
                      subtitle: Text('Price: ${item.unitPrice}'),
                      trailing: Text(item.status.toString()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
