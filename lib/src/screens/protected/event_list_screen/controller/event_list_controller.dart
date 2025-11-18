import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';

class EventListController extends GetxController {
  final events = <EventsModel>[].obs;
  final isEventsLoading = false.obs;

  final int? venueId;
  late final Rx<EventListFilters> filters;
  EventListController({this.venueId}) {
    filters = EventListFilters(venueId: venueId).obs;
  }

  final EventsRepo eventsRepo = EventsRepo();

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void setDate(DateTime? date) {
    filters.update((val) {
      val?.date = date != null ? _toDate(date) : null;
    });
    fetchEvents();
  }

  void setQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      filters.update((val) {
        val?.query = query;
      });
      fetchEvents();
    });
  }

  String _toDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void fetchEvents() async {
    try {
      isEventsLoading.value = true;
      final fetchedEvents = await eventsRepo.getEvents(
        filters.value.toQueryParams(),
      );
      events.assignAll(fetchedEvents);
      isEventsLoading.value = false;
    } catch (e) {
      debugPrint("Error fetching events: $e");
      isEventsLoading.value = false;
    }
  }
}

class EventListFilters {
  int? venueId;
  String? date;
  String? query;
  EventListFilters({this.venueId, this.date, this.query});

  String toQueryParams() {
    final params = <String>[];
    if (venueId != null) {
      params.add('venue_id=$venueId');
    }
    if (date != null && date!.isNotEmpty) {
      params.add('date=$date');
    }
    if (query != null && query!.isNotEmpty) {
      params.add('event_name=$query');
    }
    return params.join('&');
  }
}
