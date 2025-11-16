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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['venue_id'] = this.venueId;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}
