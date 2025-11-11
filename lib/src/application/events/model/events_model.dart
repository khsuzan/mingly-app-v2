
class EventsModel {
  int? id;
  String? eventName;
  String? about;
  String? description;
  String? currency;
  List<Images>? images;
  String? venueName;
  String? venueCity;
  int? venueCapacity;

  EventsModel({
    this.id,
    this.eventName,
    this.about,
    this.description,
    this.currency,
    this.images,
    this.venueName,
    this.venueCity,
    this.venueCapacity,
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
    venueName = json['venue_name'];
    venueCity = json['venue_city'];
    venueCapacity = json['venue_capacity'];
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
    data['venue_name'] = venueName;
    data['venue_city'] = venueCity;
    data['venue_capacity'] = venueCapacity;
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
