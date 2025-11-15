class TicketOrderItem {
  final int ticketId;
  final int quantity;

  TicketOrderItem({required this.ticketId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {"ticket_id": ticketId, "quantity": quantity};
  }
}

class TicketOrderRequest {
  final List<TicketOrderItem> items;
  final String? promoCode;

  TicketOrderRequest({required this.items, this.promoCode});

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
      if (promoCode != null && promoCode!.isNotEmpty) "promo_code": promoCode,
    };
  }
}
