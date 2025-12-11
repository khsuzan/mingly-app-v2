import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/promo_code/model/promo_code_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromoCodeRepo {
  Future<List<PromoCodeModel>> getPromoCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await ApiService()
        .getList(  AppUrls.promoCodeUrl,authToken: prefs.getString('authToken') ?? '',);

    if (response.isNotEmpty) {
      List<PromoCodeModel> data = (response)
          .map((e) => PromoCodeModel.fromJson(e))
          .toList();
      return data;
    } else {
      return [];
    }
  }
}
