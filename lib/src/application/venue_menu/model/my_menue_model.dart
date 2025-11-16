import 'package:mingly/src/application/venues/model/venues_model.dart';

class MyMenuModel {
  int? id;
  String? orderNumber;
  int? createdBy;
  dynamic user;
  VenuesModel? venue;
  dynamic vendor;
  String? status;
  String? paymentStatus;
  String? subtotal;
  String? discountAmount;
  String? taxAmount;
  String? totalAmount;
  String? currency;
  String? paymentMethod;
  String? transactionId;
  String? billingAddress;
  String? deliveryType;
  String? deliveryAddress;
  String? notes;
  CustomerInfo? customerInfo;
  bool? isPaidOnline;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<MenuItem>? items;

  MyMenuModel({
    this.id,
    this.orderNumber,
    this.createdBy,
    this.user,
    this.venue,
    this.vendor,
    this.status,
    this.paymentStatus,
    this.subtotal,
    this.discountAmount,
    this.taxAmount,
    this.totalAmount,
    this.currency,
    this.paymentMethod,
    this.transactionId,
    this.billingAddress,
    this.deliveryType,
    this.deliveryAddress,
    this.notes,
    this.customerInfo,
    this.isPaidOnline,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory MyMenuModel.fromJson(Map<String, dynamic> json) => MyMenuModel(
        id: json['id'] as int?,
        orderNumber: json['order_number'] as String?,
        createdBy: json['created_by'] as int?,
        user: json['user'],
        venue: json['venue'],
        vendor: json['vendor'],
        status: json['status'] as String?,
        paymentStatus: json['payment_status'] as String?,
        subtotal: json['subtotal'] as String?,
        discountAmount: json['discount_amount'] as String?,
        taxAmount: json['tax_amount'] as String?,
        totalAmount: json['total_amount'] as String?,
        currency: json['currency'] as String?,
        paymentMethod: json['payment_method'],
        transactionId: json['transaction_id'],
        billingAddress: json['billing_address'],
        deliveryType: json['delivery_type'] as String?,
        deliveryAddress: json['delivery_address'],
        notes: json['notes'] as String?,
        customerInfo: json['customer_info'] != null
            ? CustomerInfo.fromJson(json['customer_info'] as Map<String, dynamic>)
            : null,
        isPaidOnline: json['is_paid_online'] as bool?,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
        items: json['items'] != null
            ? (json['items'] as List).map((e) => MenuItem.fromJson(e as Map<String, dynamic>)).toList()
            : <MenuItem>[],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'created_by': createdBy,
        'user': user,
        'venue': venue,
        'vendor': vendor,
        'status': status,
        'payment_status': paymentStatus,
        'subtotal': subtotal,
        'discount_amount': discountAmount,
        'tax_amount': taxAmount,
        'total_amount': totalAmount,
        'currency': currency,
        'payment_method': paymentMethod,
        'transaction_id': transactionId,
        'billing_address': billingAddress,
        'delivery_type': deliveryType,
        'delivery_address': deliveryAddress,
        'notes': notes,
        'customer_info': customerInfo?.toJson(),
        'is_paid_online': isPaidOnline,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'items': items?.map((e) => e.toJson()).toList(),
      };
}

class CustomerInfo {
  String? name;
  String? phone;

  CustomerInfo({this.name, this.phone});

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
        name: json['name'] as String?,
        phone: json['phone'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
      };
}

class MenuItem {
  String? name;
  String? description;
  String? image;
  String? unitPrice;
  int? quantity;
  String? subtotal;
  String? discountAmount;
  String? taxAmount;
  String? totalAmount;
  dynamic metadata;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? venueMenuItem;

  MenuItem({
    this.name,
    this.description,
    this.image,
    this.unitPrice,
    this.quantity,
    this.subtotal,
    this.discountAmount,
    this.taxAmount,
    this.totalAmount,
    this.metadata,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.venueMenuItem,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        name: json['name'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
        unitPrice: json['unit_price'] as String?,
        quantity: json['quantity'] as int?,
        subtotal: json['subtotal'] as String?,
        discountAmount: json['discount_amount'] as String?,
        taxAmount: json['tax_amount'] as String?,
        totalAmount: json['total_amount'] as String?,
        metadata: json['metadata'],
        status: json['status'] as String?,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
        venueMenuItem: json['venue_menu_item'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'image': image,
        'unit_price': unitPrice,
        'quantity': quantity,
        'subtotal': subtotal,
        'discount_amount': discountAmount,
        'tax_amount': taxAmount,
        'total_amount': totalAmount,
        'metadata': metadata,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'venue_menu_item': venueMenuItem,
      };
}