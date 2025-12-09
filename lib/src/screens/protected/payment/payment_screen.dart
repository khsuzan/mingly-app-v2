import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/screens/protected/booking_summary/widget/custom_confirm_dialog.dart';
import 'package:mingly/src/screens/protected/event_list_screen/events_provider.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventsProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Payment Method',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Add new payment method button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  // Add new payment method action
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Add new payment method',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Mastercard section
            _buildPaymentSection(
              cardType: 'Mastercard',
              logoAsset:
                  'lib/assets/images/mastercard.png', // You'll need to add this asset
              cards: [
                PaymentCard(name: 'Tyler Howell', last4: '2355'),
                PaymentCard(name: 'Tyler Howell', last4: '2881'),
              ],
              isExpanded: true,
            ),

            SizedBox(height: 16),

            // Visa section
            _buildPaymentSection(
              cardType: 'Visa',
              logoAsset:
                  'lib/assets/images/visa.png', // You'll need to add this asset
              cards: [],
              isExpanded: false,
            ),

            Spacer(),

            // Pay button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD1B26F),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () async {
                  // LoadingDialog.show(context);
                  // final status = await eventProvider.buyTicketEvent(
                  //   eventProvider
                  //       .buildOrderRequest(
                  //         promoCode: eventProvider.promoCode ?? "",
                  //       )
                  //       .toJson(),
                  //   eventProvider.selectEventModel.id.toString(),
                  // );
                  // LoadingDialog.hide(context);

                  // if (status != null) {
                  //   showCustomConfirmDialogEventTicket(
                  //     context,
                  //     eventProvider.selectedTickets.length.toString(),
                  //     status["message"],
                  //   );
                  // }

                  // context.push('/booking-summary');
                },
                child: Text('Pay (\$${eventProvider.totalPrice})'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection({
    required String cardType,
    required String logoAsset,
    required List<PaymentCard> cards,
    required bool isExpanded,
  }) {
    return Column(
      children: [
        // Header with logo and expand/collapse
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Card logo placeholder (you can replace with actual logo)
              Container(width: 32, height: 20, child: Image.asset(logoAsset)),
              SizedBox(width: 12),
              Text(
                cardType,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),

        // Cards list (only show if expanded)
        if (isExpanded && cards.isNotEmpty) ...[
          SizedBox(height: 8),
          ...cards.map((card) => _buildPaymentCard(card)),
        ],
      ],
    );
  }

  Widget _buildPaymentCard(PaymentCard card) {
    String cardKey = '${card.name}_${card.last4}';
    bool isSelected = selectedPaymentMethod == cardKey;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Color(0xFFDAA520), width: 2)
            : null,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPaymentMethod = cardKey;
          });
        },
        child: Row(
          children: [
            // Card icon
            Container(
              width: 24,
              height: 16,

              child: SvgPicture.asset("lib/assets/icons/Payment.svg"),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '•••• •••• •••• ${card.last4}',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Selection indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color(0xFFDAA520) : Colors.grey.shade600,
                  width: 2,
                ),
                color: isSelected ? Color(0xFFDAA520) : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.black, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCard {
  final String name;
  final String last4;

  PaymentCard({required this.name, required this.last4});
}
