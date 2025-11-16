import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/venue_menu/model/my_menue_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenueRepo {
  Future<List<MyMenuModel>> getBottle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.myMenu,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => MyMenuModel.fromJson(e)).toList();
  }
}
