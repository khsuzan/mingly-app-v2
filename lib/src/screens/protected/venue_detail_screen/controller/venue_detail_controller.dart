import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';
import 'package:mingly/src/application/venues/repo/venues_repo.dart';

import '../../../../application/events/model/events_model.dart';
import '../../../../application/venues/model/venues_model.dart';

class VenueDetailController extends GetxController {
  // VenuesModel venue;

  final eventsList = <EventsModel>[].obs;
  final EventsRepo eventsRepo = EventsRepo();

  final VenuesModel model;

  VenueDetailController(this.model);

  @override
  void onInit() {
    super.onInit();
    fetchEventsById(model.id.toInt());
  }

  Future<void> fetchEventsById(int venueId) async {
    try {
      final response = await eventsRepo.getEventsById(venueId);
      if (response.isNotEmpty) {
        eventsList.value = response;
      }
    } catch (e) {
      debugPrint('Error fetching events by venue ID: $e');
    }
  }
}
