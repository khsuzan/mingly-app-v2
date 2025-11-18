import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';

import '../../../../application/booking/booking_list.dart';
import '../../../../application/booking/repo/booking_repo.dart';
import '../../../../application/payment/model/payment_from.dart';
import '../../../../components/custom_loading_dialog.dart';

class MyBookingController extends GetxController {
  final isLoading = false.obs;

  final reservationList = <BookingOrder>[].obs;

  final BookingOrdersRepo bookingOrdersRepo = BookingOrdersRepo();
  final EventsRepo eventsRepo = EventsRepo();

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final response = await bookingOrdersRepo.getOrdersBooking();
      reservationList.value = response;
      isLoading.value = false;
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint("Error fetching bookings: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> continueBooking(BuildContext context, String orderNumber) async {
    LoadingDialog.show(context);
    try {
      final response = await eventsRepo.continuePaymentEventTicket({
        'order_id': orderNumber,
      });
      if (context.mounted) {
        context.push(
          "/payment-screen",
          extra: PaymentFromArg(
            url: response.checkoutUrl,
            fromScreen: FromScreen.ticketBooking,
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
}
