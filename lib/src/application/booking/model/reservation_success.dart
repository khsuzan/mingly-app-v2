class ReservationCheckoutSuccess {
  final String message;
  final int orderId;
  final String orderNumber;
  final String checkoutUrl;

  ReservationCheckoutSuccess({
    required this.message,
    required this.orderId,
    required this.orderNumber,
    required this.checkoutUrl,
  });

  factory ReservationCheckoutSuccess.fromJson(Map<String, dynamic> json) {
    return ReservationCheckoutSuccess(
      message: json['message'] ?? '',
      orderId: json['order_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      checkoutUrl: json['checkout_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'order_id': orderId,
      'order_number': orderNumber,
      'checkout_url': checkoutUrl,
    };
  }
}