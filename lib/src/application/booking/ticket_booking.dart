import '../events/model/event_details_model.dart';
import '../events/model/events_model.dart';

class TicketBooking {
  List<TicketBuyingInfo> items;
  String promoCode;
  TicketBooking({required this.items, required this.promoCode});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'promo_code': promoCode,
    };
  }
}



class TicketBookInfoArg {
  final EventsModel event;
  final EventDetailsModel eventDetail;
  final List<TicketBuyingInfo> tickets;
  final String promoCode;
  TicketBookInfoArg({
    required this.event,
    required this.eventDetail,
    required this.tickets,
    required this.promoCode,
  });
}

// class TicketBuyingInfo {
//   final String ticketName;
//   final int ticketId;
//   final double price;
//   final int quantity;

//   TicketBuyingInfo({
//     required this.ticketName,
//     required this.ticketId,
//     required this.price,
//     required this.quantity,
//   });

// }

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
