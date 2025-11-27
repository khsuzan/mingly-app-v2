import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/home/model/adds_image_model.dart';
import 'package:mingly/src/application/home/model/featured_model.dart';
import 'package:mingly/src/application/home/model/leader_board_model.dart';
import 'package:mingly/src/application/venues/model/venues_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../events/model/events_model.dart';

class HomeRepo {
  Future<List<LeaderBoardModel>> getLeaderBoard() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.leaderBoard,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => LeaderBoardModel.fromJson(e)).toList();
  }

  Future<List<VenuesModel>> getFeaturedVenues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      '${AppUrls.venuesUrl}?featured=true',
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => VenuesModel.fromJson(e)).toList();
  }

  Future<List<EventsModel>> getPopularEvents() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      '${AppUrls.eventsUrl}?popular=true',
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => EventsModel.fromJson(e)).toList();
  }

  Future<List<FeaturedModel>> getFeatured() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.featuredSection,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => FeaturedModel.fromJson(e)).toList();
  }

  Future<List<AdsImage>> getAdsImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.getAdsImage,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => AdsImage.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> updagradePlan(Map<String, dynamic> data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().postData(
      AppUrls.updagradePlan,
      data,
      authToken: preferences.getString("authToken"),
    );
    return response;
  }

  Future<List<EventsModel>> getRecommendation(String location) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getListOrThrow(
      "${AppUrls.getRecomendedEvent}?location=$location",
      authToken: preferences.getString("authToken"),
    );

    return response.map<EventsModel>((e) {
      return EventsModel.fromJson(e);
    }).toList();
  }
}
