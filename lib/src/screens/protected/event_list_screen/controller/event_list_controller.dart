import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';

class EventListController extends GetxController {
  final events = <EventsModel>[].obs;
  final isEventsLoading = false.obs;

  final EventsRepo eventsRepo = EventsRepo();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  void fetchEvents() async {
    try {
      isEventsLoading.value = true;
      final fetchedEvents = await eventsRepo.getEvents();
      events.assignAll(fetchedEvents);
      isEventsLoading.value = false;
    } catch (e) {
      debugPrint("Error fetching events: $e");
      isEventsLoading.value = false;
    }
  }
}
