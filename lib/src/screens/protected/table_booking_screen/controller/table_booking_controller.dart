import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';

import '../../../../application/events/model/event_details_model.dart';
import '../../../../application/events/model/event_session_model.dart';

class TableBookingController extends GetxController {
  final detail = EventDetailsModel().obs;

  final EventsRepo eventsRepo = EventsRepo();

  final String id;
  TableBookingController({required this.id});

  final sessionTimes = <EventSessionModel>[].obs;

  final RxInt selectedSessionIndex = (-1).obs;

  EventSessionModel get selectedSession => sessionTimes[selectedSessionIndex.value];

  final isEventDetailLoading = false.obs;
  final isSessionTimesLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
    fetchAvailableSessions();
  }

  void fetchDetail() async {
    try {
      isEventDetailLoading.value = true;
      final response = await eventsRepo.getEventsDetails(id);
      detail.value = response;
      isEventDetailLoading.value = false;
    } catch (e) {
      debugPrint("Error fetching event details: $e");
      isEventDetailLoading.value = false;
    }
  }

  void fetchAvailableSessions() async {
    try {
      isSessionTimesLoading.value = true;
      final response = await eventsRepo.getEventSessions(id);
      sessionTimes.assignAll(response);
      isSessionTimesLoading.value = false;
    } catch (e) {
      debugPrint("Error fetching event details: $e");
      isSessionTimesLoading.value = false;
    }
  }
}
