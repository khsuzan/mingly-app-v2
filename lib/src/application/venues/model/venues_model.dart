class VenuesModel {
  int id = 0;
  List<Images>? images;
  String? name;
  String? description;
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  double? latitude;
  double? longitude;
  int? capacity;
  String? contactEmail;
  String? contactPhone;
  String? websiteUrl;
  String? status;
  bool? isFeatured;
  String? directionUrl;
  String? picture;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  OpeningHours? openingHours;

  VenuesModel({
    required this.id,
    this.images,
    this.name,
    this.description,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.capacity,
    this.contactEmail,
    this.contactPhone,
    this.websiteUrl,
    this.status,
    this.isFeatured,
    this.directionUrl,
    this.picture,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.openingHours,
  });

  VenuesModel.fromJson(Map<String, dynamic> json) {
    id = json['id']!;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    name = json['name'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postal_code'];
    latitude = json['latitude'] is String
      ? double.tryParse(json['latitude'])
      : (json['latitude'] != null ? (json['latitude'] as num).toDouble() : null);
    longitude = json['longitude'] is String
      ? double.tryParse(json['longitude'])
      : (json['longitude'] != null ? (json['longitude'] as num).toDouble() : null);
    capacity = json['capacity'];
    contactEmail = json['contact_email'];
    contactPhone = json['contact_phone'];
    websiteUrl = json['website_url'];
    status = json['status'];
    isFeatured = json['is_featured'] is bool
        ? json['is_featured']
        : json['is_featured'] == 1;
    directionUrl = json['direction_url'];
    picture = json['picture'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    if (json['meta'] != null) {
      openingHours = OpeningHours.fromJson(json['meta']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['description'] = description;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['postal_code'] = postalCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['capacity'] = capacity;
    data['contact_email'] = contactEmail;
    data['contact_phone'] = contactPhone;
    data['website_url'] = websiteUrl;
    data['status'] = status;
    data['is_featured'] = isFeatured;
    data['direction_url'] = directionUrl;
    data['picture'] = picture;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    if (openingHours != null) {
      data['meta'] = openingHours!.toJson();
    }
    return data;
  }
}

class Images {
  int? id;
  String? imageUrl;
  String? altText;
  String? caption;
  int? isFeatured;

  Images({this.id, this.imageUrl, this.altText, this.caption, this.isFeatured});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    altText = json['alt_text'];
    caption = json['caption'];
    isFeatured = json['is_featured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    data['alt_text'] = altText;
    data['caption'] = caption;
    data['is_featured'] = isFeatured;
    return data;
  }
}

class OpeningHours {
  String? open;
  String? close;
  List<String>? openingDays;

  OpeningHours({this.open, this.close, this.openingDays});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    open = json['opening_hour'];
    close = json['closing_hour'];
    openingDays = List<String>.from(json['opening_days'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['opening_hour'] = open;
    data['closing_hour'] = close;
    data['opening_days'] = openingDays;
    return data;
  }
}
