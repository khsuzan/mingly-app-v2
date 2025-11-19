import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/notification/model/notification_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo {
  Future<List<Notifications>> getNotifcation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getData(
      AppUrls.notification,
      authToken: preferences.getString("authToken"),
    );
    return NotificationModel.fromJson(response).notifications ?? [];
  }
}
