import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../application/events/model/event_details_model.dart';
import '../../../../application/events/repo/events_repo.dart';

class BookedTableDetailController extends GetxController {
  final detail = EventDetailsModel().obs;
  final EventsRepo eventsRepo = EventsRepo();

  final String id; // event id
  BookedTableDetailController({required this.id});
  @override
  void onInit() {
    super.onInit();
    fetchDetail();
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
