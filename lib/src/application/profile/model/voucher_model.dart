class VoucherModel {
  String? code;
  double? discountPercent;
  String? description;
  String? expiryDate;
  bool? used;

  VoucherModel({
    this.code,
    this.discountPercent,
    this.description,
    this.expiryDate,
    this.used,
  });

  VoucherModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    discountPercent = json['discount_percent'];
    description = json['description'];
    expiryDate = json['expiry_date'];
    used = json['used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['discount_percent'] = discountPercent;
    data['description'] = description;
    data['expiry_date'] = expiryDate;
    data['used'] = used;
    return data;
  }
}
