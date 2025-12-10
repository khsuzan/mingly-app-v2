class VenueMenuModel {
  int? id;
  int? venueId;
  String? image;
  String? name;
  String? description;
  String? price;
  int? quantity;

  VenueMenuModel({
    this.id,
    this.venueId,
    this.image,
    this.name,
    this.description,
    this.price,
    this.quantity,
  });

  VenueMenuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    venueId = json['venue_id'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['venue_id'] = venueId;
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['quantity'] = quantity;
    return data;
  }
}
