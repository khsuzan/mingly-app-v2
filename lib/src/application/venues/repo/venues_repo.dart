import 'package:flutter/material.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/venue_menu/model/venue_menu_model.dart';
import 'package:mingly/src/application/venues/model/venues_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../venue_menu/model/menue_create.dart';

class VenuesRepo {
  VenuesRepo._();
  static final VenuesRepo _instance = VenuesRepo._();
  factory VenuesRepo() => _instance;

  Future<List<VenuesModel>> getVenues(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final mQuery = query.isNotEmpty
        ? '?${query.split('&').map((part) {
            if (part.isEmpty) return '';
            final i = part.indexOf('=');
            if (i < 0) return Uri.encodeQueryComponent(part);
            final k = part.substring(0, i);
            final v = part.substring(i + 1);
            return '${Uri.encodeQueryComponent(k)}=${Uri.encodeQueryComponent(v)}';
          }).where((s) => s.isNotEmpty).join('&')}'
        : '';
    final url = '${AppUrls.venuesUrl}$mQuery';
    debugPrint('VenuesRepo getVenues URL: $url');
    final response = await ApiService().getList(
      url,
      authToken: prefs.getString("authToken") ?? "",
    );
    return response.map((e) => VenuesModel.fromJson(e)).toList();
  }

  Future<List<VenuesModel>> getFeaturedVenues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      "${AppUrls.venuesUrl}?featured=true",
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

  /// Create an order (my menu checkout)
  Future<MenuCreateResponse> createMyMenuOrder(Map<String, dynamic> payload) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final auth = prefs.getString("authToken") ?? "";
    final response = await ApiService().postDataRegular(
      AppUrls.createOrder,
      payload,
      authToken: auth,
    );
    return MenuCreateResponse.fromJson(response);
  }
}
