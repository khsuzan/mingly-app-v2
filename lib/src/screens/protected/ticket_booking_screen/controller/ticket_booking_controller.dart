import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../application/events/repo/events_repo.dart';

class TicketBookingController extends GetxController {
  final RxList<TicketBuyingInfo> eventTicketList = <TicketBuyingInfo>[].obs;

  final eventRepo = EventsRepo();

  final RxDouble totalPrice = 0.0.obs;

  final String id;
  TicketBookingController({required this.id});

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  void fetchTickets() async {
    try {
      final response = await eventRepo.getEventTicket(id);
      eventTicketList.assignAll(
        response
            .map(
              (e) => TicketBuyingInfo(
                ticketId: e.id,
                ticketTitle: e.title ?? "",
                totalTicketQty: e.totalTicketQty ?? 0,
                quantity: 0,
                unitPrice: double.tryParse(e.price ?? '0') ?? 0.0,
              ),
            )
            .toList(),
      );
    } catch (e) {
      debugPrint("Error fetching tickets: $e");
    }
  }

  void onSelectTicket(TicketBuyingInfo model, int changeBy) {
    final ticketIndex = eventTicketList.indexWhere(
      (t) => t.ticketId == model.ticketId,
    );
    if (ticketIndex != -1) {
      final ticket = eventTicketList[ticketIndex];
      final newQuantity = max(0, ticket.quantity + changeBy);
      if (newQuantity > -1) {
        eventTicketList[ticketIndex] = ticket.copyWith(quantity: newQuantity);
      }
    }
    totalPrice.value = eventTicketList.fold(
      0.0,

      (prev, t) => prev + (t.unitPrice * t.quantity),
    );
  }
}

class TicketBuyingInfo {
  int ticketId;
  String ticketTitle;
  int totalTicketQty;
  int quantity;
  double unitPrice;

  TicketBuyingInfo({
    required this.ticketId,
    required this.ticketTitle,
    required this.totalTicketQty,
    required this.quantity,
    required this.unitPrice,
  });

  TicketBuyingInfo copyWith({
    int? ticketId,
    String? ticketTitle,
    int? totalTicketQty,
    int? quantity,
    double? unitPrice,
  }) {
    return TicketBuyingInfo(
      ticketId: ticketId ?? this.ticketId,
      ticketTitle: ticketTitle ?? this.ticketTitle,
      totalTicketQty: totalTicketQty ?? this.totalTicketQty,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
