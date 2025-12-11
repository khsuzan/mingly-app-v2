import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/booking/repo/booking_repo.dart';

import '../../../../application/booking/model/order_detail.dart';
import '../../../../application/events/model/event_details_model.dart';
import '../../../../application/events/repo/events_repo.dart';

class BookedDetailController extends GetxController {
  final eventDetail = EventDetailsModel().obs;
  final orderDetail = OrderDetailResponse().obs;
  final EventsRepo eventsRepo = EventsRepo();
  final BookingOrdersRepo bookingOrdersRepo = BookingOrdersRepo();

  final String eventId; // event id
  final String orderNumber; // order number
  BookedDetailController({required this.eventId, required this.orderNumber});
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    fetchDetail();
    fetchOrderDetail();
  }

  void fetchDetail() async {
    try {
      final response = await eventsRepo.getEventsDetails(eventId);
      eventDetail.value = response;
    } catch (e) {
      debugPrint("Error fetching event details: $e");
    }
  }

  void fetchOrderDetail() async {
    try {
      final response = await bookingOrdersRepo.getOrderDetails(orderNumber);
      orderDetail.value = response;
    } catch (e) {
      debugPrint("Error fetching event details: $e");
    }
  }
}
