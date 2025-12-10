import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/events/model/event_ticket_model.dart';
import 'package:mingly/src/application/events/repo/events_repo.dart';

import '../../../../application/booking/ticket_booking.dart';
import '../../../../application/events/model/event_details_model.dart';
import '../../../../application/events/model/event_session_model.dart';
import '../../../../components/helpers.dart';

class TableBookingController extends GetxController {
  final detail = EventDetailsModel().obs;

  final EventsRepo eventsRepo = EventsRepo();

  late Rx<TableBookingInfoArg> bookingArgs;
  TableBookingController({required TableBookingInfoArg argument}) {
    bookingArgs = argument.obs;
  }

  String get eventId => bookingArgs.value.event.id!.toString();

  final RxInt selectedSessionIndex = (0).obs;

  final isEventDetailLoading = false.obs;
  final isSessionTimesLoading = false.obs;

  final RxList<EventTicketModelResponse> tables =
      <EventTicketModelResponse>[].obs;

  final Rx<EventSessionModel?> selectedTimeSlot = Rx<EventSessionModel?>(null);

  // selected for booking
  RxList<EventsTicketModel> selectedTables = <EventsTicketModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
    fetchTablesTickets();

    ever(selectedSessionIndex, (_) {
      fetchTablesTickets();
    });
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

  void fetchTablesTickets() async {
    try {
      final bookingDate = formatBookingDateForBackend(
        bookingArgs.value.selectedDate!,
      );
      final sessionId = bookingArgs.value.session.id.toString();

      final response = await eventsRepo.getTablesTickets(
        eventId: eventId,
        date: bookingDate,
        sessionId: sessionId,
      );
      tables.assignAll(response);
    } catch (e) {
      debugPrint("Error fetching table tickets: $e");
    }
  }

  void toggleTableSelection(EventsTicketModel table) {
    if (selectedTables.contains(table)) {
      selectedTables.remove(table);
    } else {
      selectedTables.add(table);
    }
  }

  void updateSessionAndRefetch(dynamic newSession, String newDate) {
    bookingArgs.value = TableBookingInfoArg(
      event: bookingArgs.value.event,
      eventDetail: bookingArgs.value.eventDetail,
      tables: bookingArgs.value.tables,
      promoCode: bookingArgs.value.promoCode,
      session: newSession,
      selectedDate: newDate,
      sessions: bookingArgs.value.sessions,
    );
    selectedTables.clear();
    fetchTablesTickets();
  }
}
