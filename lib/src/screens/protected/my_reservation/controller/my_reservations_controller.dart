import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/reservation/model/reservation_model.dart';
import 'package:mingly/src/application/reservation/repo/reservation_repo.dart';

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
}
