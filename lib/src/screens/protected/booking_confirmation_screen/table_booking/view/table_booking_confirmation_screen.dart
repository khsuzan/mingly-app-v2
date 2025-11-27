import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/screens/protected/berverages/widget/table_card.dart';

import '../../../../../application/booking/ticket_booking.dart';
import '../../../../../application/events/model/event_details_model.dart';
import '../../../../../application/events/model/event_ticket_model.dart';
import '../../../../../components/custom_snackbar.dart';
import '../controller/table_booking_confirmation_controller.dart';

class TableBookingConfirmationScreen extends StatelessWidget {
  final TicketBookInfoArg info;
  const TableBookingConfirmationScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = info.event;
    final eventDetail = info.eventDetail;
    final tickets = info.tickets;
    return GetX<TableBookingConfirmationController>(
      init: TableBookingConfirmationController(tickets: tickets),
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
                        formatDayAndDate(eventDetail.firstSessionDate ?? ""),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.store, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Outlet', style: TextStyle(color: Colors.white)),
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
                  Row(
                    children: [
                      SvgPicture.asset("lib/assets/icons/Table.svg"),
                      SizedBox(width: 10),
                      Text(
                        'Table',
                        style: TextStyle(
                          color: const Color(0xFFFFFAE5),
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TableCard(
                    no: tickets.map((e) => e.ticketTitle).toList(),
                    price:
                        "\$${tickets.map((e) => e.unitPrice).reduce((value, element) => value + element)}",
                    tableCount: tickets.length.toString(),
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
                            promoCode: controller.promo.value.code != null
                                ? controller.promo.value.code!
                                : '',
                          ).toJson(),
                          event.id!,
                          event.venue!.id!,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TableBookInfo {
  final EventsModel event;
  final EventDetailsModel eventDetail;
  final List<EventsTicketModel> tables;
  TableBookInfo({
    required this.event,
    required this.eventDetail,
    required this.tables,
  });
}
