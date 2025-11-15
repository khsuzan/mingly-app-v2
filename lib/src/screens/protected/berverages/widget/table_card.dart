import 'package:flutter/material.dart';

class TableCard extends StatelessWidget {
  final List<String> no;
  final String price;
  final String tableCount;

  const TableCard({
    super.key,
    required this.no,
    required this.price,
    required this.tableCount,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: Color(0xFF2E2D2C),
        shape: RoundedRectangleBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("No : "),
                    no.isEmpty
                        ? Text("No chairs selected")
                        : Text(no.join(", ")),
                  ],
                ),
                _buildRow("Minimum Charge :", price),
                const SizedBox(height: 20),
                const Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                _buildRow("Table :", tableCount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8E7A72),
            fontSize: 14,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w500,
            height: 1.43,
          ),
        ),

        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
