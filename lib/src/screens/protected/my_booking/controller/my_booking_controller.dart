import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../application/booking/booking_list.dart';
import '../../../../application/booking/repo/booking_repo.dart';

class MyBookingController extends GetxController {
  final isLoading = false.obs;

  final reservationList = <BookingOrder>[].obs;

  final BookingOrdersRepo bookingOrdersRepo = BookingOrdersRepo();

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final response = await bookingOrdersRepo.getOrdersBooking();
      reservationList.assignAll(response);
    } catch (e, stack) {
      debugPrint("Error fetching bookings: $e");
      debugPrintStack(stackTrace: stack);
    }
  }
}
