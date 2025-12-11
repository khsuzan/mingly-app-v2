class TicketBookingSuccess {
  final String message;
  final List<AvailableTicket> availableTickets;
  final int orderId;
  final double discountApplied;
  final int pointsEarned;
  final int totalPoints;
  final String checkoutUrl;

  TicketBookingSuccess({
    required this.message,
    required this.availableTickets,
    required this.orderId,
    required this.discountApplied,
    required this.pointsEarned,
    required this.totalPoints,
    required this.checkoutUrl,
  });

  factory TicketBookingSuccess.fromJson(Map<String, dynamic> json) {
    return TicketBookingSuccess(
      message: json['message'] as String? ?? '',
      availableTickets: (json['available_tickets'] as List<dynamic>?)
              ?.map((e) => AvailableTicket.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      orderId: json['order_id'] is int
          ? json['order_id'] as int
          : int.tryParse('${json['order_id']}') ?? 0,
      discountApplied: (json['discount_applied'] is num)
          ? (json['discount_applied'] as num).toDouble()
          : double.tryParse('${json['discount_applied']}') ?? 0.0,
      pointsEarned: json['points_earned'] is int
          ? json['points_earned'] as int
          : int.tryParse('${json['points_earned']}') ?? 0,
      totalPoints: json['total_points'] is int
          ? json['total_points'] as int
          : int.tryParse('${json['total_points']}') ?? 0,
      checkoutUrl: json['checkout_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'available_tickets': availableTickets.map((e) => e.toJson()).toList(),
        'order_id': orderId,
        'discount_applied': discountApplied,
        'points_earned': pointsEarned,
        'total_points': totalPoints,
        'checkout_url': checkoutUrl,
      };
}

class AvailableTicket {
  final int ticketId;
  final int remainingQty;
  final bool isSoldOut; // normalized to bool for convenience

  AvailableTicket({
    required this.ticketId,
    required this.remainingQty,
    required this.isSoldOut,
  });

  factory AvailableTicket.fromJson(Map<String, dynamic> json) {
    final raw = json['is_sold_out'];
    bool soldOut;
    if (raw is bool) {
      soldOut = raw;
    } else if (raw is num) {
      soldOut = raw.toInt() == 1;
    } else {
      soldOut = '$raw' == '1' || '$raw' == 'true';
    }

    return AvailableTicket(
      ticketId: json['ticket_id'] is int
          ? json['ticket_id'] as int
          : int.tryParse('${json['ticket_id']}') ?? 0,
      remainingQty: json['remaining_qty'] is int
          ? json['remaining_qty'] as int
          : int.tryParse('${json['remaining_qty']}') ?? 0,
      isSoldOut: soldOut,
    );
  }

  Map<String, dynamic> toJson() => {
        'ticket_id': ticketId,
        'remaining_qty': remainingQty,
        // convert bool back to 0/1 to match original API shape
        'is_sold_out': isSoldOut ? 1 : 0,
      };
}