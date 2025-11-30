class PaymentFromArg {
  final String url;
  final int? venueId;
  final FromScreen fromScreen;
  PaymentFromArg({
    required this.url,
    this.venueId,
    required this.fromScreen,
  });
}

enum FromScreen { ticketBooking, tableBooking, menuBooking , reservationPayment  , membershipPayment }
