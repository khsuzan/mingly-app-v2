class EventTicketModelResponse {
  final int id;
  final String status;
  final EventsTicketModel ticketInfo;
  EventTicketModelResponse({
    required this.id,
    required this.status,
    required this.ticketInfo,
  });
  factory EventTicketModelResponse.fromJson(Map<String, dynamic> json) {
    return EventTicketModelResponse(
      id: json['id'] as int,
      status: json['status'] as String,
      ticketInfo: EventsTicketModel.fromJson(
        json['ticket_info'] as Map<String, dynamic>,
      ),
    );
  }
}

class EventsTicketModel {
  final int id;
  String? title;
  String? price;
  int? totalTicketQty;
  int? isHasBookingLimit;
  int? ticketLimit;
  int? isHasAllowKids;
  String? description;
  int? isOffer;
  Null startOfferDateTime;
  Null endOfferDateTime;
  String? offerValue;
  int? availableSales;
  int? isSoldOut;
  String? createdAt;
  String? updatedAt;
  Null ticketType;
  int? event;
  int? commission;
  int? tax;
  int? promocode;

  EventsTicketModel({
    required this.id,
    this.title,
    this.price,
    this.totalTicketQty,
    this.isHasBookingLimit,
    this.ticketLimit,
    this.isHasAllowKids,
    this.description,
    this.isOffer,
    this.startOfferDateTime,
    this.endOfferDateTime,
    this.offerValue,
    this.availableSales,
    this.isSoldOut,
    this.createdAt,
    this.updatedAt,
    this.ticketType,
    this.event,
    this.commission,
    this.tax,
    this.promocode,
  });

  factory EventsTicketModel.fromJson(Map<String, dynamic> json) {
    return EventsTicketModel(
      id: json['id'] as int,
      title: json['title'] as String?,
      price: json['price'] as String?,
      totalTicketQty: json['total_ticket_qty'] as int?,
      isHasBookingLimit: json['is_has_booking_limit'] as int?,
      ticketLimit: json['ticket_limit'] as int?,
      isHasAllowKids: json['is_has_allow_kids'] as int?,
      description: json['description'] as String?,
      isOffer: json['is_offer'] as int?,
      startOfferDateTime: json['start_offer_date_time'],
      endOfferDateTime: json['end_offer_date_time'],
      offerValue: json['offer_value'] as String?,
      availableSales: json['available_sales'] as int?,
      isSoldOut: json['is_sold_out'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      ticketType: json['ticket_type'],
      event: json['event'] as int?,
      commission: json['commission'] as int?,
      tax: json['tax'] as int?,
      promocode: json['promocode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['total_ticket_qty'] = totalTicketQty;
    data['is_has_booking_limit'] = isHasBookingLimit;
    data['ticket_limit'] = ticketLimit;
    data['is_has_allow_kids'] = isHasAllowKids;
    data['description'] = description;
    data['is_offer'] = isOffer;
    data['start_offer_date_time'] = startOfferDateTime;
    data['end_offer_date_time'] = endOfferDateTime;
    data['offer_value'] = offerValue;
    data['available_sales'] = availableSales;
    data['is_sold_out'] = isSoldOut;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['ticket_type'] = ticketType;
    data['event'] = event;
    data['commission'] = commission;
    data['tax'] = tax;
    data['promocode'] = promocode;
    return data;
  }
}
