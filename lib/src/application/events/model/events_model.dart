
class EventsModel {
  int? id;
  String? eventName;
  String? about;
  String? description;
  String? currency;
  List<Images>? images;
  Venue? venue;

  EventsModel({
    this.id,
    this.eventName,
    this.about,
    this.description,
    this.currency,
    this.images,
    this.venue,
  });

  EventsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    about = json['about'];
    description = json['description'];
    currency = json['currency'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['venue'] != null) {
      venue = Venue.fromJson(json['venue']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['event_name'] = eventName;
    data['about'] = about;
    data['description'] = description;
    data['currency'] = currency;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (venue != null) {
      data['venue'] = venue!.toJson();
    }
    return data;
  }
}

class Venue {
  int? id;
  String? name;
  String? address;
  String? city;
  int? capacity;

  Venue({this.id, this.name, this.city, this.capacity});

  Venue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    capacity = json['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['city'] = city;
    data['capacity'] = capacity;
    return data;
  }
}

class Images {
  int? id;
  String? imageUrl;
  String? altText;
  String? caption;
  int? isFeatured;

  Images({
    this.id,
    this.imageUrl,
    this.altText,
    this.caption,
    this.isFeatured,
  });

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
