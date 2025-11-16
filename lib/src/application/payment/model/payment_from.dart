class PaymentFromArg {
  final String url;
  final int venueId;
  final FromScreen fromScreen;
  PaymentFromArg({
    required this.url,
    required this.venueId,
    required this.fromScreen,
  });
}

enum FromScreen { ticketBooking, tableBooking }
