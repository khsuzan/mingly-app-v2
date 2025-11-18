import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/event_details_model.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../../../components/custom_loading_dialog.dart';
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

  Future<void> addToFavourite(BuildContext context, String id) async {
    try {
      LoadingDialog.show(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
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
        if (context.mounted) LoadingDialog.hide(context);
        return;
      }
      debugPrint(" Failed (${response.statusCode}): ${response.body}");
      if (context.mounted) LoadingDialog.hide(context);
    } catch (e) {
      debugPrint("Error: $e");
      if (context.mounted) LoadingDialog.hide(context);
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
