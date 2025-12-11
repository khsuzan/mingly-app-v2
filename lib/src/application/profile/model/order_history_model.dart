class OrderHistoryModel {
  List<Orders>? orders;

  OrderHistoryModel({this.orders});

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String? orderNumber;
  int? eventId;
  String? eventName;
  String? status;
  String? paymentStatus;
  double? subtotal;
  double? totalAmount;
  String? currency;
  String? createdAt;
  List<Items>? items;

  Orders({
    this.orderNumber,
    this.eventId,
    this.eventName,
    this.status,
    this.paymentStatus,
    this.subtotal,
    this.totalAmount,
    this.currency,
    this.createdAt,
    this.items,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    orderNumber = json['order_number'];
    eventId = json['event_id'];
    eventName = json['event_name'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    subtotal = json['subtotal'];
    totalAmount = json['total_amount'];
    currency = json['currency'];
    createdAt = json['created_at'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_number'] = orderNumber;
    data['event_id'] = eventId;
    data['event_name'] = eventName;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['subtotal'] = subtotal;
    data['total_amount'] = totalAmount;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? ticketId;
  String? seatNumber;
  double? unitPrice;
  double? subtotal;
  double? totalAmount;
  String? status;

  Items({
    this.ticketId,
    this.seatNumber,
    this.unitPrice,
    this.subtotal,
    this.totalAmount,
    this.status,
  });

  Items.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    seatNumber = json['seat_number'];
    unitPrice = json['unit_price'];
    subtotal = json['subtotal'];
    totalAmount = json['total_amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_id'] = ticketId;
    data['seat_number'] = seatNumber;
    data['unit_price'] = unitPrice;
    data['subtotal'] = subtotal;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    return data;
  }
}
