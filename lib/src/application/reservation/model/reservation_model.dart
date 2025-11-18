import 'package:mingly/src/application/venues/model/venues_model.dart';

class ReservationModelResponse {
  String? orderNumber;
  VenuesModel? venue;
  String? status;
  String? paymentStatus;
  double? subtotal;
  double? totalAmount;
  String? currency;
  String? createdAt;
  String? orderType;

  ReservationModelResponse({
    this.orderNumber,
    this.venue,
    this.status,
    this.paymentStatus,
    this.subtotal,
    this.totalAmount,
    this.currency,
    this.createdAt,
    this.orderType,
  });

  factory ReservationModelResponse.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      if (v is num) return v.toDouble();
      return null;
    }

    return ReservationModelResponse(
      orderNumber: json['order_number'] as String?,
      venue: json['venue'] != null ? VenuesModel.fromJson(json['venue']) : null,
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      subtotal: _toDouble(json['subtotal']),
      totalAmount: _toDouble(json['total_amount']),
      currency: json['currency'] as String?,
      createdAt: json['created_at'] as String?,
      orderType: json['order_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_number': orderNumber,
      'venue': venue?.toJson(),
      'status': status,
      'payment_status': paymentStatus,
      'subtotal': subtotal,
      'total_amount': totalAmount,
      'currency': currency,
      'created_at': createdAt,
      'order_type': orderType,
    };
  }
}