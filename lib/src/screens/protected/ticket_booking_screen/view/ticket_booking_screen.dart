import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/booking/ticket_booking.dart';
import '../../../../components/helpers.dart';
import '../controller/ticket_booking_controller.dart';

class TicketBookingScreen extends StatelessWidget {
  final TicketBookInfoArg info;
  const TicketBookingScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = info.event;
    final eventDetail = info.eventDetail;

    return GetBuilder<TicketBookingController>(
      init: TicketBookingController(id: event.id.toString()),
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
            title: Text(
              'Buy Ticket',
              style: TextStyle(
                color: const Color(0xFFFFFAE5),
                fontSize: 18,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                height: 1.56,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    event.eventName.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 24),
                  Obx(() {
                    return Column(
                      children: [
                        if (controller.eventTicketList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "No tickets available",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (controller.eventTicketList.isNotEmpty)
                          ...List.generate(controller.eventTicketList.length, (
                            index,
                          ) {
                            final ticket = controller.eventTicketList[index];
                            return _TicketOption(
                              id: ticket.ticketId.toString(),
                              title: ticket.ticketTitle,
                              price: ticket.unitPrice.toString(),
                              soldOut: ticket.totalTicketQty == 0,
                              qty: ticket.totalTicketQty,
                              selectedQty: ticket.quantity,
                              onSelectTicket: (changeBy) =>
                                  controller.onSelectTicket(ticket, changeBy),
                            );
                          }),
                      ],
                    );
                  }),

                  const Spacer(),
                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD1B26F),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          context.push(
                            "/booking-confirmation",
                            extra: TicketBookInfoArg(
                              event: event,
                              eventDetail: eventDetail,
                              tickets: controller.eventTicketList
                                  .where((t) => t.quantity > 0)
                                  .toList(),
                              promoCode: '',
                            ),
                          );
                        },
                        child: Text(
                          'Buy Tickets (\$${controller.totalPrice.value.toStringAsFixed(2)})',
                        ),
                      ),
                    );
                  }),
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

class _TicketOption extends StatelessWidget {
  final String title;
  final String price;
  final int? qty;
  final int selectedQty;
  final bool soldOut;
  final bool showFire;
  final String id;
  final Function(int) onSelectTicket;
  const _TicketOption({
    required this.title,
    required this.price,
    required this.id,
    this.qty,
    this.selectedQty = 0,
    this.soldOut = false,
    this.showFire = false,
    required this.onSelectTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        color: Color(0xFF2E2D2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Row(
            children: [
              Text(title, style: const TextStyle(color: Colors.white)),
              if (showFire) ...[
                const SizedBox(width: 4),
                Text('26#128293', style: TextStyle(fontSize: 16)),
              ],
            ],
          ),
          subtitle: qty != null
              ? Text(
                  '\$$price\nTotal Tickets: $qty',
                  style: const TextStyle(color: Colors.white54),
                )
              : Text('\$$price', style: const TextStyle(color: Colors.white54)),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 36.h,
                  height: 36.h,
                  child: InkWell(
                    onTap: () {
                      onSelectTicket(-1);
                    },
                    child: const Icon(Icons.chevron_left, color: Colors.white),
                  ),
                ),
                Text(selectedQty.toString(), style: TextStyle(fontSize: 18.sp)),
                SizedBox(
                  width: 36.h,
                  height: 36.h,
                  child: InkWell(
                    onTap: () {
                      onSelectTicket(1);
                    },
                    child: const Icon(Icons.chevron_right, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
