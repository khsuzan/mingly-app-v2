
class BookingOrder {
  final String orderNumber;
  final int eventId;
  final String eventName;
  final Event event;
  final String status;
  final String paymentStatus;
  final double subtotal;
  final double totalAmount;
  final String currency;
  final DateTime? createdAt;
  final List<Item> items;

  BookingOrder({
    required this.orderNumber,
    required this.eventId,
    required this.eventName,
    required this.event,
    required this.status,
    required this.paymentStatus,
    required this.subtotal,
    required this.totalAmount,
    required this.currency,
    required this.createdAt,
    required this.items,
  });

  factory BookingOrder.fromJson(Map<String, dynamic> json) {
    return BookingOrder(
      orderNumber: json['order_number'] as String,
      eventId: (json['event_id'] as num).toInt(),
      eventName: json['event_name'] as String,
      event: Event.fromJson(json['event'] as Map<String, dynamic>),
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      currency: json['currency'] as String,
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
      items: (json['items'] as List<dynamic>).map((e) => Item.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class Event {
  final int id;
  final String eventName;
  final String about;
  final String description;
  final String currency;
  final List<EventImage> images;
  final Venue venue;

  Event({
    required this.id,
    required this.eventName,
    required this.about,
    required this.description,
    required this.currency,
    required this.images,
    required this.venue,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: (json['id'] as num).toInt(),
      eventName: json['event_name'] as String,
      about: json['about'] as String,
      description: json['description'] as String,
      currency: json['currency'] as String,
      images: (json['images'] as List<dynamic>).map((e) => EventImage.fromJson(e as Map<String, dynamic>)).toList(),
      venue: Venue.fromJson(json['venue'] as Map<String, dynamic>),
    );
  }
}

class EventImage {
  final int id;
  final String imageUrl;
  final String? altText;
  final String? caption;
  final int isFeatured;

  EventImage({
    required this.id,
    required this.imageUrl,
    this.altText,
    this.caption,
    required this.isFeatured,
  });

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      id: (json['id'] as num).toInt(),
      imageUrl: json['image_url'] as String,
      altText: json['alt_text'] as String?,
      caption: json['caption'] as String?,
      isFeatured: (json['is_featured'] as num).toInt(),
    );
  }
}

class Venue {
  final int id;
  final String name;
  final String city;
  final int capacity;

  Venue({
    required this.id,
    required this.name,
    required this.city,
    required this.capacity,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      city: json['city'] as String,
      capacity: (json['capacity'] as num).toInt(),
    );
  }
}

class Item {
  final int ticketId;
  final String seatNumber;
  final double unitPrice;
  final double subtotal;
  final double totalAmount;
  final String status;

  Item({
    required this.ticketId,
    required this.seatNumber,
    required this.unitPrice,
    required this.subtotal,
    required this.totalAmount,
    required this.status,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      ticketId: (json['ticket_id'] as num).toInt(),
      seatNumber: json['seat_number'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
    );
  }
}