import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/screens/protected/booking_confirmation_screen/ticket_booking/controller/booking_confirmation_controller.dart';

import '../../../../../application/booking/ticket_booking.dart';
import '../../../../../components/helpers.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final TicketBookInfoArg info;
  const BookingConfirmationScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = info.event;
    final tickets = info.tickets;
    final session = info.session;
    final selectedDate = info.selectedDate ?? 'TBD';

    return GetBuilder<TicketBookingConfirmationController>(
      init: TicketBookingConfirmationController(tickets: tickets),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Order Confirmation',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Event Header
                    Text(
                      event.eventName.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Session & Order Details Card
                    _buildSessionDetailsCard(session, selectedDate),
                    const SizedBox(height: 16),
                    // Venue Information
                    _buildVenueCard(event),
                    const SizedBox(height: 16),
                    // Tickets Section
                    Text(
                      'Tickets',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTicketsCard(tickets, controller),
                    const SizedBox(height: 16),
                    // Promo Code Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Promo Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: controller.promoFocusNode,
                            controller: controller.promoCodeController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade900,
                              prefixIcon: const Icon(
                                Icons.card_giftcard,
                                color: Colors.white54,
                              ),
                              hintText: 'Enter promo code',
                              hintStyle: const TextStyle(color: Colors.white54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 8,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(() {
                          final label = controller.promoCodeApplied.value
                              ? 'Applied'
                              : 'Apply';
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade900,
                              foregroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                            onPressed: () {
                              if (controller.promoCodeApplied.value) {
                                return;
                              }
                              controller.promoFocusNode.unfocus();
                              controller.applyPromoCode(context);
                            },
                            child: Text(label),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Price Breakdown Card
                    _buildPriceBreakdownCard(controller, theme),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Proceed to Payment',
                        onPressed: () {
                          if (event.id == null) {
                            CustomSnackbar.show(
                              context,
                              message: 'Event ID is missing.',
                            );
                            return;
                          }
                          controller.buyTicketEvent(
                            context,
                            items: tickets,
                            bookingDate: formatBookingDateForBackend(
                              selectedDate,
                            ),
                            promoCode: controller.promo.value.code ?? "",
                            event: event,
                            sessionId: session.id!,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSessionDetailsCard(dynamic session, String selectedDate) {
    String sessionType = 'Select Session';
    String timeDisplay = '';

    if (session != null) {
      try {
        sessionType = (session.sessionType ?? 'select_session')
            .toString()
            .toUpperCase();
        final startTime = session.sessionStartTime;
        final endTime = session.sessionEndTime;
        if (startTime != null && endTime != null) {
          timeDisplay =
              '${formatTimeToAmPm(startTime)} – ${formatTimeToAmPm(endTime)}';
        }
      } catch (_) {}
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2E2D2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFD1B26F).withAlpha((255 * 0.3).toInt()),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Session Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFFD1B26F).withAlpha((255 * 0.2).toInt()),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sessionType,
                  style: TextStyle(
                    color: Color(0xFFD1B26F),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFFD1B26F), size: 16),
              SizedBox(width: 10),
              Text(
                selectedDate,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (timeDisplay.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.schedule, color: Color(0xFFD1B26F), size: 16),
                SizedBox(width: 10),
                Text(
                  timeDisplay,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVenueCard(EventsModel event) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2E2D2C),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Color(0xFFD1B26F), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.venue?.name ?? 'Venue',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  event.venue?.city ?? 'City',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsCard(
    List<TicketBuyingInfo> tickets,
    TicketBookingConfirmationController controller,
  ) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(tickets.length, (index) {
              final ticket = tickets[index];
              final totalPrice =
                  double.parse(ticket.unitPrice.toString()) *
                  double.parse(ticket.quantity.toString());
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.ticketTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${ticket.quantity} x \$${ticket.unitPrice}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Color(0xFFD1B26F),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  if (index < tickets.length - 1) ...[
                    SizedBox(height: 12),
                    Divider(color: Colors.white24, height: 1),
                    SizedBox(height: 12),
                  ],
                ],
              );
            }),
            const SizedBox(height: 12),
            Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Tickets',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Obx(() {
                  return Text(
                    '\$${controller.getTicketPriceInTotal.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Color(0xFFD1B26F),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdownCard(
    TicketBookingConfirmationController controller,
    ThemeData theme,
  ) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _buildPriceRow(
              label: 'Subtotal',
              amount: controller.getTicketPriceInTotal.value.toStringAsFixed(2),
              isBold: false,
            ),
            const SizedBox(height: 8),
            _buildPriceRow(
              label: 'Service Fee (10%)',
              amount: controller.getServiceFee.value.toStringAsFixed(2),
              isBold: false,
            ),
            const SizedBox(height: 8),
            Obx(() {
              return _buildPriceRow(
                label: 'Promo Discount',
                amount: '-${controller.promoValue.value}',
                isBold: false,
                isDiscount: controller.promoValue.value > 0 ? true : false,
              );
            }),
            const SizedBox(height: 12),
            Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 12),
            Obx(() {
              return _buildPriceRow(
                label: 'Grand Total',
                amount: controller.getTotalPrice.value,
                isBold: true,
                color: theme.colorScheme.primary,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String amount,
    bool isBold = false,
    bool isDiscount = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 15 : 13,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isDiscount ? Color(0xFFD1B26F) : (color ?? Colors.white),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 15 : 13,
          ),
        ),
      ],
    );
  }
}
