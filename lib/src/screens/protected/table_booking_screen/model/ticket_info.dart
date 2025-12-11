import 'package:mingly/src/application/events/model/event_ticket_model.dart';

class TableTicketInfo {
  int id;
  String title;
  bool isAvailable;
  double price;
  TableTicketInfo({
    required this.id,
    required this.title,
    required this.isAvailable,
    required this.price,
  });

  static fromTicketInfo(EventsTicketModel table) {
    return TableTicketInfo(
      id: table.id,
      title: table.title ?? "No Title",
      isAvailable: (table.isSoldOut != null && table.isSoldOut == 0),
      price: double.tryParse(table.price ?? "0") ?? 0,
    );
  }
}
