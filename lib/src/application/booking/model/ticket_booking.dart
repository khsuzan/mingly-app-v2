import '../../events/model/event_details_model.dart';
import '../../events/model/events_model.dart';

class TicketBooking {
  List<TicketBuyingInfo> items;
  String promoCode;
  String bookingDate;
  int sessionId;
  TicketBooking({
    required this.items,
    required this.promoCode,
    required this.bookingDate,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'promo_code': promoCode,
      'booking_date': bookingDate,
      'session': sessionId,
    };
  }
}

class TicketBookInfoArg {
  final EventsModel event;
  final EventDetailsModel eventDetail;
  final List<TicketBuyingInfo> tickets;
  final String promoCode;
  final dynamic session; // Selected session from SessionSelectionSheet
  final String? selectedDate; // Selected booking date (format: "Jan 31, 2025")

  TicketBookInfoArg({
    required this.event,
    required this.eventDetail,
    required this.tickets,
    required this.promoCode,
    this.session,
    this.selectedDate,
  });
}

class TableBookingInfoArg {
  final EventsModel event;
  final EventDetailsModel eventDetail;
  final List<TicketBuyingInfo> tables;
  final String promoCode;
  final Session session; // Selected session from SessionSelectionSheet
  final String? selectedDate; // Selected booking date (format: "Jan 31, 2025")
  final List<Session>? sessions; // All available sessions for re-selection

  TableBookingInfoArg({
    required this.event,
    required this.eventDetail,
    required this.tables,
    required this.promoCode,
    required this.session,
    this.selectedDate,
    this.sessions,
  });
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

  Map<String, dynamic> toJson() {
    return {'ticket_id': ticketId, 'quantity': quantity};
  }
}
