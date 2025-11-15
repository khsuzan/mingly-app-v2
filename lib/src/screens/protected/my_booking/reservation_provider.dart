import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mingly/src/application/favourite/model/favourite_model.dart';
import 'package:mingly/src/application/favourite/repo/favourite_repo.dart';
import 'package:mingly/src/application/reservation/model/reservation_model.dart';
import 'package:mingly/src/application/reservation/repo/reversaetion_repo.dart';
import 'package:http/http.dart' as http;
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationProvider extends ChangeNotifier {
  List<ReservationModel> reservationList = [];
  bool isLoading = false;

  Future<void> getFavouriteList() async {
    isLoading = true;
    notifyListeners();
    final response = await ReversaetionRepo().getReservation();
    if (response.isNotEmpty) {
      List<dynamic> data = response;
      for (var e in data) {
        reservationList.add(e);
      }
      isLoading = false;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> addToFavourite(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(
        Uri.parse(
          "${AppUrls.baseUrl}${AppUrls.addToFav}$id/",
        ), // ✅ include id and trailing slash
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${preferences.getString("authToken")}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint("Added to favourites: $data");
        return data;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        final data = jsonDecode(response.body);
        debugPrint("Added to favourites: $data");
        return data;
      } else {
        debugPrint(" Failed (${response.statusCode}): ${response.body}");
        return {
          "status": "error",
          "message": "Request failed with ${response.statusCode}",
        };
      }
    } catch (e) {
      debugPrint("Error: $e");
      return {"status": "error", "message": e.toString()};
    }
  }
}
