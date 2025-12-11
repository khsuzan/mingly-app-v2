class BottleModel {
  int? id;
  String? brand;
  String? keepingDate;
  String? expiredDate;
  int? quantity;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  BottleModel({
    this.id,
    this.brand,
    this.keepingDate,
    this.expiredDate,
    this.quantity,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  BottleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    keepingDate = json['keeping_date'];
    expiredDate = json['expired_date'];
    quantity = json['quantity'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['keeping_date'] = keepingDate;
    data['expired_date'] = expiredDate;
    data['quantity'] = quantity;
    data['image_url'] = imageUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
