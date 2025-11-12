import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/application/reservation/model/reservation_model.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReversaetionRepo {
  Future<List<ReservationModel>> getReservation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await ApiService().getList(
      AppUrls.reservation,
      authToken: preferences.getString("authToken"),
    );
    return response.map((e) => ReservationModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> addFavourite(String id) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(
        Uri.parse("${AppUrls.baseUrl}favourite/$id/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${preferences.getString("authToken")}",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Added to favourites: $data");
        return data;
      } else {
        debugPrint("Failed (${response.statusCode}): ${response.body}");
        return {
          "success": false,
          "status": response.statusCode,
          "message": "Failed to add favourite",
          "body": response.body,
        };
      }
    } catch (e) {
      debugPrint(" Error: $e");
      return {"success": false, "error": e.toString()};
    }
  }
}
