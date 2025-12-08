import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final eventDetail = info.eventDetail;
    final tickets = info.tickets;
    return GetBuilder<TicketBookingConfirmationController>(
      init: TicketBookingConfirmationController(event: event, tickets: tickets),
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
              'Confirmation',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    event.eventName.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        //TODO: keep the date
                        "formatDayAndDate(eventDetail.firstSessionDate ?? "")",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.store, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Location', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text(
                      '${event.venue?.name}\nCity - ${event.venue?.city}',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: List.generate(tickets.length, (index) {
                              final ticket = tickets[index];
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Ticket  : ${tickets[index].quantity}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        tickets[index].unitPrice.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${ticket.quantity} x',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      Text(
                                        '${double.parse(tickets[index].unitPrice.toString()) * double.parse(ticket.quantity.toString())}',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                          const Divider(color: Colors.white24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(color: Colors.white),
                              ),
                              Obx(() {
                                return Text(
                                  controller.getTicketPriceInTotal.value
                                      .toStringAsFixed(2),
                                  style: TextStyle(color: Colors.white),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      ElevatedButton(
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
                          controller.applyPromoCode();
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                controller.getTicketPriceInTotal.value
                                    .toStringAsFixed(2),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Service Fee  (10%)',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                controller.getServiceFee.value.toStringAsFixed(
                                  2,
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Promo',
                                style: TextStyle(color: Colors.white),
                              ),
                              Obx(() {
                                return Text(
                                  '-${controller.promoValue.value}',
                                  style: TextStyle(color: Colors.white),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Divider(color: Colors.white24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grand Total',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Obx(() {
                                return Text(
                                  controller.getTotalPrice.value,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Proceed',
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
                          TicketBooking(
                            items: tickets,
                            promoCode: controller.promo.value.code ?? "",
                          ).toJson(),
                          event.id!,
                          event.venue!.id!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
