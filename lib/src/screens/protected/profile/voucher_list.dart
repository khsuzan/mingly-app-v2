import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/screens/protected/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class VoucherListScreen extends StatelessWidget {
  const VoucherListScreen({super.key});

  String formatDateTime(String utcString) {
    try {
      DateTime dateTime = DateTime.parse(utcString).toLocal();
      String datePart = DateFormat("dd").format(dateTime);
      String monthPart = DateFormat("MMM").format(dateTime).toUpperCase();
      String timePart = DateFormat("ha").format(dateTime).toUpperCase();
      return "$datePart $monthPart, $timePart";
    } catch (e) {
      return utcString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Vouchers"), centerTitle: true),
      body: provider.voucherList.isEmpty
          ? Center(child: Text("No Vouchers Available"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.voucherList.length,
              itemBuilder: (context, index) {
                final voucher = provider.voucherList[index];

                bool isUsed = provider.voucherList[index].used ?? false;
                Color cardColor = isUsed
                    ? Color.fromARGB(0, 62, 62, 63)
                    : const Color.fromARGB(255, 85, 84, 84);
                Color textColor = isUsed ? Colors.white : Colors.white;
                Color discountColor = isUsed ? Colors.white : Colors.green;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Voucher Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Voucher Code",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isUsed
                                    ? Colors.grey.shade400
                                    : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isUsed ? "Used" : "Active",
                                style: TextStyle(
                                  color: isUsed
                                      ? Colors.white
                                      : Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),
                        Text(
                          provider.voucherList[index].code.toString(),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Text(
                          provider.voucherList[index].description.toString(),
                          style: TextStyle(color: textColor, fontSize: 14),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount: ${provider.voucherList[index].discountPercent}% OFF",
                              style: TextStyle(
                                color: discountColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Expires: ${formatDateTime(provider.voucherList[index].expiryDate.toString())}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Divider(color: Colors.grey.shade300),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: isUsed
                                ? null
                                : () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: provider.voucherList[index].code
                                            .toString(),
                                      ),
                                    );
                                    CustomSnackbar.show(
                                      context,
                                      message:
                                          "Code copied: ${provider.voucherList[index].code}",
                                    );
                                  },
                            icon: const Icon(
                              Icons.copy,
                              size: 16,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Copy Code",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              backgroundColor: isUsed
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
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
