import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/venue_menu/model/venue_menu_model.dart';
import 'package:mingly/src/application/venues/model/venues_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VenuesRepo {
  Future<List<VenuesModel>> getVenues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.venuesUrl,
      authToken: prefs.getString("authToken") ?? "",
    );
    return response.map((e) => VenuesModel.fromJson(e)).toList();
  }

   Future<List<VenuesModel>> getFeaturedVenues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.venuesUrl + "?featured=true",
      authToken: prefs.getString("authToken") ?? "",
    );
    return response.map((e) => VenuesModel.fromJson(e)).toList();
  }

  Future<List<VenueMenuModel>> getVenueMenu(int venueId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      "/venue/$venueId/menues/",
      authToken: prefs.getString("authToken") ?? "",
    );
    return response.map((e) => VenueMenuModel.fromJson(e)).toList();
  }
}
