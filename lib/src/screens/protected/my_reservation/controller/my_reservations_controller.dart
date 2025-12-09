import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/reservation/model/reservation_model.dart';
import 'package:mingly/src/application/reservation/repo/reservation_repo.dart';

import '../../../../application/payment/model/payment_from.dart';
import '../../../../components/custom_loading_dialog.dart';

class MyReservationsController extends GetxController {
  final isLoading = false.obs;

  final reservationList = <ReservationModelResponse>[].obs;

  final ReservationRepo reservationRepo = ReservationRepo();

  @override
  void onInit() {
    super.onInit();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      isLoading.value = true;
      final response = await reservationRepo.getReservations();
      reservationList.value = response;
      isLoading.value = false;
    } catch (e, stack) {
      isLoading.value = false;
      debugPrint("Error fetching bookings: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> payForReservation(
    BuildContext context,
    Map<String, dynamic> data,
    int? venueId,
  ) async {
    LoadingDialog.show(context);
    try {
      final response = await reservationRepo.makePayment(data);
      if (context.mounted) {
        context.push(
          "/payment-screen",
          extra: PaymentFromArg(
            url: response.checkoutUrl,
            venueId: venueId,
            fromScreen: FromScreen.reservationPayment,
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
