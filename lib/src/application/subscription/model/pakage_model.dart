// ignore_for_file: no_leading_underscores_for_local_identifiers

class UserPackageModel{
  final PakageModel? data;
  UserPackageModel({this.data});

  factory UserPackageModel.fromJson(Map<String, dynamic> json) {
    return UserPackageModel(
      data: json['data'] != null ? PakageModel.fromJson(json['data']) : null,
    );
  }
}


class PakageModel {
  int? id;
  String? productName;
  double? price;
  String? currency;
  String? interval;
  String? description;
  List<String>? features;
  String? tier;
  int? position;
  DateTime? createdAt;
  DateTime? updatedAt;

  PakageModel({
    this.id,
    this.productName,
    this.price,
    this.currency,
    this.interval,
    this.description,
    this.features,
    this.tier,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  factory PakageModel.fromJson(Map<String, dynamic> json) {
    double? _parsePrice(dynamic p) {
      if (p == null) return null;
      if (p is num) return p.toDouble();
      if (p is String) return double.tryParse(p.replaceAll(',', ''));
      return null;
    }

    DateTime? _parseDate(dynamic d) {
      if (d == null) return null;
      if (d is DateTime) return d;
      return DateTime.tryParse(d.toString());
    }

    int? _parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return PakageModel(
      id: _parseInt(json['id']),
      productName: json['product_name']?.toString(),
      price: _parsePrice(json['price']),
      currency: json['currency']?.toString(),
      interval: json['interval']?.toString(),
      description: json['description']?.toString(),
      features: json['features'] != null ? List<String>.from(json['features']) : null,
      tier: json['tier']?.toString(),
      position: _parseInt(json['position']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }
}
