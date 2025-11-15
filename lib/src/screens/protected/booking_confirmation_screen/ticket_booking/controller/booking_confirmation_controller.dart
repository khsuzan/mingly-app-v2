import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/booking/ticket_booking.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';

import '../../../../../application/booking/ticket_success.dart';
import '../../../../../application/events/repo/events_repo.dart';

class TicketBookingConfirmationController extends GetxController {
  final EventsModel event;
  TicketBookingConfirmationController({required this.event});

  final eventRepo = EventsRepo();

  final promoValue = 0.0.obs;

  Future<void> buyTicketEvent(
    BuildContext context,
    Map<String, dynamic> data,
    int id,
  ) async {
    LoadingDialog.show(context);
    try {
      final response = await eventRepo.buyEventTicket(data, id);
      TicketBookingSuccess ticketBookingSuccess = TicketBookingSuccess.fromJson(
        response,
      );
      if (context.mounted) {
        context.push(
          "/payment-ticket",
          extra: ticketBookingSuccess.checkoutUrl,
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
