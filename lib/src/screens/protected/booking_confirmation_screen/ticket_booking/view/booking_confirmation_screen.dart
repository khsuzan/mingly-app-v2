import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/screens/protected/booking_summary/widget/custom_confirm_dialog.dart';
import 'package:mingly/src/screens/protected/event_list_screen/events_provider.dart';
import 'package:mingly/src/screens/protected/payment/payment_strrpe.dart';
import 'package:mingly/src/screens/protected/profile_screen/profile_provider.dart';
import 'package:provider/provider.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventProvider = context.watch<EventsProvider>();
    final profileProvider = context.watch<ProfileProvider>();
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
              const SizedBox(height: 8),
              const Text(
                'Personal details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              profileProvider.profileModel == null ||
                      profileProvider.profileModel.data == null
                  ? Center(child: CircularProgressIndicator())
                  : Card(
                      color: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          profileProvider.profileModel.data!.fullName
                              .toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileProvider.profileModel.data!.mobile
                                  .toString(),
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'tyler.howell@gmail.com',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () => context.push("/personal-info"),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              Text(
                eventProvider.selectEventModel.eventName.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.calendar_today, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Fri, 26 Jan 2025',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 32),
                child: Text(
                  'Open gate at 20:00',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
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
                  '${eventProvider.selectEventModel.venue?.city}\nCity - ${eventProvider.selectEventModel.venue?.city}',
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
                        children: List.generate(
                          eventProvider.selectedTickets.length,
                          (index) {
                            final ticket = eventProvider.selectedTickets[index];
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ticket  : ${eventProvider.getTicketName(int.parse(ticket.ticketId.toString()))}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      eventProvider.getTicketPrice(
                                        int.parse(ticket.ticketId),
                                      ),
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
                                      '${double.parse(eventProvider.getTicketPrice(int.parse(ticket.ticketId))) * double.parse(ticket.quantity.toString())}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const Divider(color: Colors.white24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: TextStyle(color: Colors.white)),
                          Text(
                            eventProvider.getTotalPrice(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        String promo = profileProvider.getPromoValue(value);
                        eventProvider.calculateTotalAmountWithPromo(promo);
                        eventProvider.getPromoCode(value);
                      },
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
                      eventProvider.addPromoValue();
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
                            eventProvider.getTotalPrice(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Promo', style: TextStyle(color: Colors.white)),
                          Text(
                            '${eventProvider.promoValue}',
                            style: TextStyle(color: Colors.white),
                          ),
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
                          Text(
                            (double.parse(eventProvider.getTotalPrice()) -
                                    eventProvider.promoValue)
                                .toString(),

                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Full Payment', style: TextStyle(color: Colors.black)),
                    Text(
                      (double.parse(eventProvider.getTotalPrice()) -
                              eventProvider.promoValue)
                          .toString(),

                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
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
                    LoadingDialog.show(context);
                    final status = await eventProvider.buyTicketEvent(
                      eventProvider
                          .buildOrderRequest(
                            promoCode: eventProvider.promoCode ?? "",
                          )
                          .toJson(),
                      eventProvider.selectEventModel.id.toString(),
                    );
                    LoadingDialog.hide(context);

                    if (status["message"] == "Booking Successful" &&
                        status["checkout_url"] != null) {
                      // Navigate to payment
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StripePaymentWebView(
                            url: status["checkout_url"],
                            message: status["message"],
                          ),
                        ),
                      ).then((success) {
                        if (success == true) {
                          showCustomConfirmDialogEventTicket(
                            context,
                            context
                                .read<EventsProvider>()
                                .selectedTickets
                                .length
                                .toString(),
                            status["message"],
                          );
                        }
                      });

                      // showCustomConfirmDialogEventTicket(
                      //   context,
                      //   eventProvider.selectedTickets.length.toString(),
                      //   "table booking successfully",
                      // );

                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (_) => StripePaymentWebView(
                      //                 url: status["checkout_url"],
                      //                 message: status["message"],
                      //               ),
                      //             ),
                      //           );

                      //             showCustomConfirmDialogEventTicket(
                      //   context,
                      //   context.read<EventsProvider>().selectedTickets.length.toString(),
                      //   widget.message!,
                      // );
                    } else {
                      CustomSnackbar.show(
                        context,
                        message: "Getting some error",
                        backgroundColor: Colors.red,
                      );
                    }
                    // if (status != null) {
                    //
                    // }
                  },
                  child: const Text('Proceed'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
