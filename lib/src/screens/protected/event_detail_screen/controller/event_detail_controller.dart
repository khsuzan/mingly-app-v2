import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/event_details_model.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../../../constant/app_urls.dart';

class EventDetailController extends GetxController {
  final String id;
  EventDetailController({required this.id});

  final detail = EventDetailsModel().obs;

  final EventsRepo eventsRepo = EventsRepo();

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
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

  void fetchDetail() async {
    try {
      final response = await eventsRepo.getEventsDetails(id);
      detail.value = response;
    } catch (e) {
      debugPrint("Error fetching event details: $e");
    }
  }
}
