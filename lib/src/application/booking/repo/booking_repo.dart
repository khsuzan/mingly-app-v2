
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/booking/booking_list.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingOrdersRepo {
  Future<List<BookingOrder>> getOrdersBooking() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.bookingOrders,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => BookingOrder.fromJson(e)).toList();
  }
}
