import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/screens/protected/berverages/widget/table_card.dart';

import '../../../../../application/events/model/event_details_model.dart';
import '../../../../../application/events/model/event_ticket_model.dart';
import '../controller/table_booking_confirmation_controller.dart';

class TableBookingConfirmationScreen extends StatelessWidget {
  final TableBookInfo bookingInfo;
  const TableBookingConfirmationScreen({super.key, required this.bookingInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = TableBookingConfirmationController();
    // final eventProvider = context.watch<EventsProvider>();
    // final venueProvider = context.watch<VenueProvider>();
    final event = bookingInfo.event;
    final eventDetail = bookingInfo.eventDetail;
    final tables = bookingInfo.tables;
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
                no: tables.map((e) => e.title ?? "").toList(),
                price:
                    "\$${tables.map((e) => double.tryParse(e.price ?? "0") ?? 0).reduce((value, element) => value + element)}",
                tableCount: tables.length.toString(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Promo Code',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (!controller.promoCodeApplied.value)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          // eventProvider.getPromoCode(value);
                          // eventProvider.calculateTotalAmountWithPromo(value);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "lib/assets/icons/Promo.svg",
                            ),
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
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () {
                        controller.applyPromoCode();
                        //eventProvider.addPromoValue();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              if (controller.promoCodeApplied.value)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {},
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "lib/assets/icons/Promo.svg",
                            ),
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
                          vertical: 16,
                        ),
                      ),
                      onPressed: () {
                        controller.applyPromoCode();
                      },
                      child: const Text('Applied'),
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
                          Text("${10}", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Promo', style: TextStyle(color: Colors.white)),
                          Text("${0}", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text("${10}", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1B26F),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    // LoadingDialog.show(context);

                    // final status = await eventProvider.buyTableTicketEvent(
                    //   eventProvider.tableBooking.toJson(),
                    //   eventProvider.selectEventModel.id.toString(),
                    // );
                    // LoadingDialog.hide(context);

                    // if (status["success"] == true &&
                    //     status["checkout_url"] != null) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => StripePaymentWebViewTable(
                    //         url: status["checkout_url"],
                    //       ),
                    //     ),
                    //   ).then((e) {
                    //     showCustomConfirmDialogEventTicket(
                    //       context,
                    //       eventProvider.selectedTickets.length.toString(),
                    //       "table booking successfully",
                    //     );
                    //   });
                    // } else {
                    //   CustomSnackbar.show(
                    //     context,
                    //     message: "Getting some error",
                    //     backgroundColor: Colors.red,
                    //   );
                    // }
                  },
                  child: const Text('Proceed'),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
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
