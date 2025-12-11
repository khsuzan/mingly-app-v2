import 'package:flutter/foundation.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/booking/model/booking_list.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/order_detail.dart';

class BookingOrdersRepo {
  Future<List<BookingOrder>> getOrdersBooking() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getListOrThrow(
      AppUrls.bookingOrders,
      authToken: preferences.getString("authToken"),
    );
    final List<BookingOrder> results = [];
    for (final e in response) {
      try {
        final map = e as Map<String, dynamic>;
        // helpful debug log to inspect incoming payload keys
        // also print nested event name if available
        if (map['event'] is Map &&
            (map['event'] as Map).containsKey('event_name')) {}
        final order = BookingOrder.fromJson(map);
        results.add(order);
      } catch (err, st) {
        // log parse error and the raw item so it's easy to inspect
        // skip this item so other items still load
        debugPrint("Error parsing BookingOrder item: $err");
        debugPrintStack(stackTrace: st);
      }
    }
    return results;
  }

  Future<OrderDetailResponse> getOrderDetails(String orderNumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getOrThrow(
      AppUrls.bookingOrderDetailByOrderNumber.replaceFirst(
        ":order_number",
        orderNumber,
      ),
      authToken: preferences.getString("authToken"),
    );
    return OrderDetailResponse.fromJson(response);
  }
}
