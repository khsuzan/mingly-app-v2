import 'package:flutter/material.dart';
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
                  // Session Details Card
                  _buildSessionDetailsCard(info),
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
                      child: PrimaryButton(
                        text:
                            'Buy Tickets (\$${controller.totalPrice.value.toStringAsFixed(2)})',
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
                              session: info.session,
                              selectedDate: info.selectedDate,
                            ),
                          );
                        },
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

  Widget _buildSessionDetailsCard(TicketBookInfoArg info) {
    final session = info.session;
    final selectedDate = info.selectedDate ?? 'Select Date';
    final sessionType = (session?.sessionType ?? 'single')
        .toString()
        .toLowerCase();

    String dateDisplay = selectedDate;
    String timeDisplay = '';
    String daysDisplay = '';

    if (session != null) {
      try {
        final startTime = session.sessionStartTime;
        final endTime = session.sessionEndTime;
        if (startTime != null && endTime != null) {
          timeDisplay =
              '${formatTimeToAmPm(startTime)} – ${formatTimeToAmPm(endTime)}';
        }

        if (sessionType == 'weekly' &&
            session.daysOfWeek is List &&
            session.daysOfWeek.isNotEmpty) {
          daysDisplay = session.daysOfWeek
              .map((d) => _capitalize(d))
              .join(', ');
        }
      } catch (_) {}
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2E2D2C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFD1B26F).withAlpha((255 * 0.3).toInt()), width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Type Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFFD1B26F).withAlpha((255 * 0.2).toInt()),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              sessionType.toUpperCase(),
              style: TextStyle(
                color: Color(0xFFD1B26F),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
          SizedBox(height: 8),
          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFFD1B26F), size: 16),
              SizedBox(width: 8),
              Text(
                dateDisplay,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (timeDisplay.isNotEmpty) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, color: Color(0xFFD1B26F), size: 16),
                SizedBox(width: 8),
                Text(
                  timeDisplay,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
          if (daysDisplay.isNotEmpty) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.repeat, color: Color(0xFFD1B26F), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    daysDisplay,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _TicketOption extends StatelessWidget {
  final String title;
  final String price;
  final int? qty;
  final int selectedQty;
  final bool soldOut;
  final String id;
  final Function(int) onSelectTicket;
  const _TicketOption({
    required this.title,
    required this.price,
    required this.id,
    this.qty,
    this.selectedQty = 0,
    this.soldOut = false,
    required this.onSelectTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2E2D2C),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selectedQty > 0 ? Color(0xFFD1B26F) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Ticket Info Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '\$$price',
                          style: TextStyle(
                            color: Color(0xFFD1B26F),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 12),
                        if (qty != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$qty left',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * 0.08).toInt()),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onTap: selectedQty > 0 ? () => onSelectTicket(-1) : null,
                    ),
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          selectedQty.toString(),
                          style: TextStyle(
                            color: Color(0xFFD1B26F),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onTap: (qty == null || selectedQty < qty!) ? () => onSelectTicket(1) : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: onTap != null ? Color(0xFFD1B26F) : Colors.white30,
            size: 16,
          ),
        ),
      ),
    );
  }
}
