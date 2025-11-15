import 'package:flutter/material.dart';

class PromoCodeScreen extends StatelessWidget {
  const PromoCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final promoCodes = [
      {'code': 'SAVE10', 'desc': 'Save 10% on your order'},
      {'code': 'FREESHIP', 'desc': 'Free shipping on next order'},
      {'code': 'WELCOME5', 'desc': 'Get 5% off for new users'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo Code'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promoCodes.length,
        itemBuilder: (context, index) {
          final promo = promoCodes[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promo['code']!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          promo['desc']!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Return the selected code and go back
                      Navigator.of(context).pop(promo['code']);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}