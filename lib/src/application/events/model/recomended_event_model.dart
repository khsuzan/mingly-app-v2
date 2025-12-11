class RecomendedEventModel {
  List<Recommendations>? recommended;

  RecomendedEventModel({this.recommended});

  RecomendedEventModel.fromJson(Map<String, dynamic> json) {
    if (json['recommended_events'] != null) {
      recommended = <Recommendations>[];
      json['recommended_events'].forEach((v) {
        recommended!.add(Recommendations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recommended != null) {
      data['recommended_events'] = recommended!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class Recommendations {
  int? id;
  String? eventName;
  String? about;
  String? description;
  String? currency;
  String? picture;
  int? totalBookings;
  List<Images>? images;
  String? venueName;
  String? venueCity;
  int? venueCapacity;

  Recommendations({
    this.id,
    this.eventName,
    this.about,
    this.description,
    this.currency,
    this.picture,
    this.totalBookings,
    this.images,
    this.venueName,
    this.venueCity,
    this.venueCapacity,
  });

  Recommendations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    about = json['about'];
    description = json['description'];
    currency = json['currency'];
    picture = json['picture'];
    totalBookings = json['total_bookings'];
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
    data['picture'] = picture;
    data['total_bookings'] = totalBookings;
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
  String? thumbnailImage;
  String? bgImage;
  String? imageGl;
  String? seatingPlan;

  Images({
    this.id,
    this.thumbnailImage,
    this.bgImage,
    this.imageGl,
    this.seatingPlan,
  });

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumbnailImage = json['thumbnail_image'];
    bgImage = json['bg_image'];
    imageGl = json['image_gl'];
    seatingPlan = json['seating_plan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['thumbnail_image'] = thumbnailImage;
    data['bg_image'] = bgImage;
    data['image_gl'] = imageGl;
    data['seating_plan'] = seatingPlan;
    return data;
  }
}
