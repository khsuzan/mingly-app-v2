class OrderDetailResponse {
  final String? orderNumber;
  final Event? event;
  final String? status;
  final String? paymentStatus;
  final double? subtotal;
  final double? totalAmount;
  final double? discountAmount;
  final double? serviceCharge;
  final String? currency;
  final String? orderType;
  final String? promoCode;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem>? items;

  OrderDetailResponse({
    this.orderNumber,
    this.event,
    this.status,
    this.paymentStatus,
    this.subtotal,
    this.totalAmount,
    this.discountAmount,
    this.serviceCharge,
    this.currency,
    this.orderType,
    this.promoCode,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      orderNumber: json['order_number'] as String?,
      event: json['event'] != null ? Event.fromJson(json['event'] as Map<String, dynamic>) : null,
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      serviceCharge: (json['service_charge'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      orderType: json['order_type'] as String?,
      promoCode: json['promo_code'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      items: (json['items'] as List<dynamic>?)?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class Event {
  final int? id;
  final String? eventName;
  final String? about;
  final String? description;
  final String? currency;
  final List<EventImage>? images;
  final Venue? venue;

  Event({
    this.id,
    this.eventName,
    this.about,
    this.description,
    this.currency,
    this.images,
    this.venue,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int?,
      eventName: json['event_name'] as String?,
      about: json['about'] as String?,
      description: json['description'] as String?,
      currency: json['currency'] as String?,
      images: (json['images'] as List<dynamic>?)?.map((e) => EventImage.fromJson(e as Map<String, dynamic>)).toList(),
      venue: json['venue'] != null ? Venue.fromJson(json['venue'] as Map<String, dynamic>) : null,
    );
  }
}

class EventImage {
  final int? id;
  final String? imageUrl;
  final String? altText;
  final String? caption;
  final int? isFeatured;

  EventImage({
    this.id,
    this.imageUrl,
    this.altText,
    this.caption,
    this.isFeatured,
  });

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      id: json['id'] as int?,
      imageUrl: json['image_url'] as String?,
      altText: json['alt_text'] as String?,
      caption: json['caption'] as String?,
      isFeatured: json['is_featured'] as int?,
    );
  }
}

class Venue {
  final int? id;
  final String? name;
  final String? address;
  final String? city;
  final int? capacity;

  Venue({
    this.id,
    this.name,
    this.address,
    this.city,
    this.capacity,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      capacity: json['capacity'] as int?,
    );
  }
}

class OrderItem {
  final int? itemId;
  final int? ticketId;
  final String? title;
  final String? description;
  final String? type;
  final String? seatNumber;
  final int? quantity;
  final double? unitPrice;
  final double? subtotal;
  final double? totalAmount;
  final String? status;
  final DateTime? bookingDate;
  final CustomerInfo? customerInfo;
  final DateTime? createdAt;
  final EventSession? esession;

  OrderItem({
    this.itemId,
    this.ticketId,
    this.title,
    this.description,
    this.type,
    this.seatNumber,
    this.quantity,
    this.unitPrice,
    this.subtotal,
    this.totalAmount,
    this.status,
    this.bookingDate,
    this.customerInfo,
    this.createdAt,
    this.esession,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['item_id'] as int?,
      ticketId: json['ticket_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      seatNumber: json['seat_number'] as String?,
      quantity: json['quantity'] as int?,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      bookingDate: json['booking_date'] != null ? DateTime.parse(json['booking_date'] as String) : null,
      customerInfo: json['customer_info'] != null ? CustomerInfo.fromJson(json['customer_info'] as Map<String, dynamic>) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      esession: json['esession'] != null ? EventSession.fromJson(json['esession'] as Map<String, dynamic>) : null,
    );
  }
}

class CustomerInfo {
  final String? email;
  final String? mobile;
  final String? fullName;

  CustomerInfo({
    this.email,
    this.mobile,
    this.fullName,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      fullName: json['full_name'] as String?,
    );
  }
}

class EventSession {
  final int? id;
  final int? event;
  final String? sessionType;
  final String? occurrence;
  final List<dynamic>? daysOfWeek;
  final String? firstSessionDate;
  final String? lastSessionDate;
  final String? sessionStartTime;
  final String? sessionEndTime;
  final String? bookingStartDate;
  final String? bookingStartTime;
  final String? bookingEndDate;
  final String? bookingEndTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EventSession({
    this.id,
    this.event,
    this.sessionType,
    this.occurrence,
    this.daysOfWeek,
    this.firstSessionDate,
    this.lastSessionDate,
    this.sessionStartTime,
    this.sessionEndTime,
    this.bookingStartDate,
    this.bookingStartTime,
    this.bookingEndDate,
    this.bookingEndTime,
    this.createdAt,
    this.updatedAt,
  });

  factory EventSession.fromJson(Map<String, dynamic> json) {
    return EventSession(
      id: json['id'] as int?,
      event: json['event'] as int?,
      sessionType: json['session_type'] as String?,
      occurrence: json['occurrence'] as String?,
      daysOfWeek: json['days_of_week'] as List<dynamic>?,
      firstSessionDate: json['first_session_date'] as String?,
      lastSessionDate: json['last_session_date'] as String?,
      sessionStartTime: json['session_start_time'] as String?,
      sessionEndTime: json['session_end_time'] as String?,
      bookingStartDate: json['booking_start_date'] as String?,
      bookingStartTime: json['booking_start_time'] as String?,
      bookingEndDate: json['booking_end_date'] as String?,
      bookingEndTime: json['booking_end_time'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
}
