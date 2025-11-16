import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/payment/model/payment_from.dart';

import '../../../../../application/booking/ticket_booking.dart';
import '../../../../../application/booking/ticket_success.dart';
import '../../../../../application/events/repo/events_repo.dart';
import '../../../../../components/custom_loading_dialog.dart';

class TableBookingConfirmationController extends GetxController {
  final inputController = TextEditingController();
  final promoCodeApplied = false.obs;

  void applyPromoCode() {}

  void setPromoCode(String promoCode) {
    inputController.text = promoCode;
  }

  final eventRepo = EventsRepo();

  final promoValue = 0.0.obs;

  Future<void> buyTicketEvent(
    BuildContext context,
    Map<String, dynamic> data,
    int eventId,
    int venueId,
  ) async {
    LoadingDialog.show(context);
    try {
      final response = await eventRepo.buyEventTicket(data, eventId);
      TicketBookingSuccess ticketBookingSuccess = TicketBookingSuccess.fromJson(
        response,
      );
      if (context.mounted) {
        context.push(
          "/payment-screen",
          extra: PaymentFromArg(
            url: ticketBookingSuccess.checkoutUrl,
            venueId: venueId,
            fromScreen: FromScreen.tableBooking,
          ),
        );
      }
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    } catch (e, stack) {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      debugPrint("Error buying tickets: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  String getTotalPrice(List<TicketBuyingInfo> tickets) {
    return tickets
        .fold<double>(0.0, (prev, t) => prev + (t.unitPrice * t.quantity))
        .toStringAsFixed(2);
  }
}
