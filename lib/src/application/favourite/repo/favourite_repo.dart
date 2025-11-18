import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteRepo {
  Future<List<EventsModel>> getFavourite() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.favourite,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => EventsModel.fromJson(e)).toList();
  }
}
