import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/event_ticket_model.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:collection/collection.dart';

import '../../../../application/events/model/event_details_model.dart';
import '../../../../application/events/model/event_session_model.dart';

class TableBookingController extends GetxController {
  final detail = EventDetailsModel().obs;

  final EventsRepo eventsRepo = EventsRepo();

  final String eventId;
  TableBookingController({required this.eventId});

  final _sessionTimes = <EventSessionModel>[].obs;

  final RxInt selectedSessionIndex = (0).obs;

  EventSessionModel? get selectedSession =>
      _sessionTimes.isEmpty ||
          _sessionTimes.length <= selectedSessionIndex.value
      ? null
      : _sessionTimes[selectedSessionIndex.value];

  RxMap<String, List<EventSessionModel>> get groupedSessionsByDate => groupBy(
    _sessionTimes,
    (EventSessionModel s) => formatDate(s.firstSessionDate.toIso8601String()),
  ).obs;

  List<EventSessionModel> get timeSlots {
    if (_sessionTimes.isEmpty || selectedSessionIndex.value < 0) return [];
    final selectedDate = formatDate(
      _sessionTimes[selectedSessionIndex.value].firstSessionDate
          .toIso8601String(),
    );
    final slots = groupedSessionsByDate[selectedDate] ?? [];
    slots.sort((a, b) => a.sessionStartTime.compareTo(b.sessionStartTime));
    return slots;
  }

  final isEventDetailLoading = false.obs;
  final isSessionTimesLoading = false.obs;

  final RxList<EventTicketModelResponse> tables = <EventTicketModelResponse>[].obs;

  final Rx<EventSessionModel?> selectedTimeSlot = Rx<EventSessionModel?>(null);

  // selected for booking
  RxList<EventsTicketModel> selectedTables = <EventsTicketModel>[].obs;

  RxList<EventTicketModelResponse> get filteredList => tables;

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
    fetchAvailableSessions();
  }

  void selectTimeSlot(EventSessionModel session) {
    selectedTimeSlot.value = session;
    fetchTablesTickets();
  }

  void fetchDetail() async {
    try {
      isEventDetailLoading.value = true;
      final response = await eventsRepo.getEventsDetails(eventId);
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
      final response = await eventsRepo.getEventSessions(eventId);
      debugPrint("Fetched ${response.length} sessions for event ID $eventId");
      _sessionTimes.assignAll(response);
      isSessionTimesLoading.value = false;
    } catch (e, stack) {
      debugPrint("Error fetching available session details: $e");
      debugPrint("Stack trace: $stack");
      isSessionTimesLoading.value = false;
    }
  }

  void updateDateSelection(String date) {
    final sessions = groupedSessionsByDate[date];
    if (sessions != null && sessions.isNotEmpty) {
      selectedSessionIndex.value = _sessionTimes.indexOf(sessions.first);
    }
  }

  void fetchTablesTickets() async {
    try {
      if (selectedSession == null) return;
      final response = await eventsRepo.getTablesTickets(
        eventId: eventId,
        date: _toDate(selectedSession!.firstSessionDate.toIso8601String()),
        time: selectedSession!.sessionStartTime,
      );
      tables.assignAll(response);
    } catch (e) {
      debugPrint("Error fetching table tickets: $e");
    }
  }

  String _toDate(String isoString) {
    final dateTime = DateTime.parse(isoString);
    return "${dateTime.year.toString().padLeft(4, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.day.toString().padLeft(2, '0')}";
  }

  void toggleTableSelection(EventsTicketModel table) {
    if (selectedTables.contains(table)) {
      selectedTables.remove(table);
    } else {
      selectedTables.add(table);
    }
  }
}
