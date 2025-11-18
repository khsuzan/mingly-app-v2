// lib/src/application/venue_menu/model/menue_create.dart

import 'dart:convert';

class MenuCreateResponse {
  final String message;
  final int orderId;
  final String orderNumber;
  final List<AvailableItem> availableItems;
  final double subtotal;
  final double totalAmount;
  final String checkoutUrl;

  const MenuCreateResponse({
    required this.message,
    required this.orderId,
    required this.orderNumber,
    required this.availableItems,
    required this.subtotal,
    required this.totalAmount,
    required this.checkoutUrl,
  });

  factory MenuCreateResponse.fromRawJson(String str) =>
      MenuCreateResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory MenuCreateResponse.fromJson(Map<String, dynamic> json) => MenuCreateResponse(
        message: json['message'] as String,
        orderId: json['order_id'] as int,
        orderNumber: json['order_number'] as String,
        availableItems: (json['available_items'] as List<dynamic>)
            .map((e) =>
                AvailableItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        totalAmount: (json['total_amount'] as num).toDouble(),
        checkoutUrl: json['checkout_url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'order_id': orderId,
        'order_number': orderNumber,
        'available_items': availableItems.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'total_amount': totalAmount,
        'checkout_url': checkoutUrl,
      };

  MenuCreateResponse copyWith({
    String? message,
    int? orderId,
    String? orderNumber,
    List<AvailableItem>? availableItems,
    double? subtotal,
    double? totalAmount,
    String? checkoutUrl,
  }) =>
      MenuCreateResponse(
        message: message ?? this.message,
        orderId: orderId ?? this.orderId,
        orderNumber: orderNumber ?? this.orderNumber,
        availableItems: availableItems ?? this.availableItems,
        subtotal: subtotal ?? this.subtotal,
        totalAmount: totalAmount ?? this.totalAmount,
        checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      );

  @override
  String toString() {
    return 'MenuCreate(message: $message, orderId: $orderId, orderNumber: $orderNumber, '
        'availableItems: $availableItems, subtotal: $subtotal, totalAmount: $totalAmount, '
        'checkoutUrl: $checkoutUrl)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuCreateResponse &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          orderId == other.orderId &&
          orderNumber == other.orderNumber &&
          listEquals(availableItems, other.availableItems) &&
          subtotal == other.subtotal &&
          totalAmount == other.totalAmount &&
          checkoutUrl == other.checkoutUrl;

  @override
  int get hashCode =>
      message.hashCode ^
      orderId.hashCode ^
      orderNumber.hashCode ^
      availableItems.hashCode ^
      subtotal.hashCode ^
      totalAmount.hashCode ^
      checkoutUrl.hashCode;
}

/// Simple list equality helper
bool listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

class AvailableItem {
  final int venueMenuItem;
  final int remainingQty;

  const AvailableItem({
    required this.venueMenuItem,
    required this.remainingQty,
  });

  factory AvailableItem.fromJson(Map<String, dynamic> json) => AvailableItem(
        venueMenuItem: json['venue_menu_item'] as int,
        remainingQty: json['remaining_qty'] as int,
      );

  Map<String, dynamic> toJson() => {
        'venue_menu_item': venueMenuItem,
        'remaining_qty': remainingQty,
      };

  AvailableItem copyWith({
    int? venueMenuItem,
    int? remainingQty,
  }) =>
      AvailableItem(
        venueMenuItem: venueMenuItem ?? this.venueMenuItem,
        remainingQty: remainingQty ?? this.remainingQty,
      );

  @override
  String toString() =>
      'AvailableItem(venueMenuItem: $venueMenuItem, remainingQty: $remainingQty)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvailableItem &&
          runtimeType == other.runtimeType &&
          venueMenuItem == other.venueMenuItem &&
          remainingQty == other.remainingQty;

  @override
  int get hashCode => venueMenuItem.hashCode ^ remainingQty.hashCode;
}