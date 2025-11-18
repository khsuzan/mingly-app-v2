import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/point_history/model/point_history_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointHistoryRepo {
  Future<PointHistory> getPointHistory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getOrThrow(
      AppUrls.pointHistory,
      authToken: preferences.getString("authToken"),
    );
    if (response.isNotEmpty) {
      return PointHistory.fromJson(response);
    }
    return PointHistory.fromJson(response);
  }
}
