import '../../events/model/events_model.dart' as event;
import '../../venues/model/venues_model.dart' as venue;

/// Represents a featured entry which can point to either an Event or a Venue
class FeaturedModel {
  final int id;
  final String title;
  final String imageUrl;
  final String? altText;
  final String? caption;
  final String imageableType;
  final int createdBy;
  final String createdByName;
  final Imageable? imageable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FeaturedModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.altText,
    this.caption,
    required this.imageableType,
    required this.createdBy,
    required this.createdByName,
    this.imageable,
    this.createdAt,
    this.updatedAt,
  });

  factory FeaturedModel.fromJson(Map<String, dynamic> json) {
    final imageableType = (json['imageable_type'] as String?) ?? '';
    final imageableJson = json['imageable'] as Map<String, dynamic>?;

    return FeaturedModel(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      imageUrl: (json['image_url'] ?? '') as String,
      altText: json['alt_text'] as String?,
      caption: json['caption'] as String?,
      imageableType: imageableType,
      createdBy: json['created_by'] is int
          ? json['created_by'] as int
          : int.tryParse('${json['created_by']}') ?? 0,
      createdByName: (json['created_by_name'] ?? '') as String,
      imageable: imageableJson != null
          ? Imageable.fromJson(imageableType, imageableJson)
          : null,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image_url': imageUrl,
    'alt_text': altText,
    'caption': caption,
    'imageable_type': imageableType,
    'created_by': createdBy,
    'created_by_name': createdByName,
    'imageable': imageable?.toJson(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() =>
      'FeaturedModel(id: $id, title: $title, type: $imageableType)';
}

/// Base type for the polymorphic `imageable` payload.
abstract class Imageable {
  Map<String, dynamic> toJson();

  /// Creates the correct Imageable subtype depending on the reported type.
  /// The API sometimes uses "eevents" (events) or "venues".
  static Imageable? fromJson(String imageableType, Map<String, dynamic> json) {
    final lower = imageableType.toLowerCase();
    if (lower.contains('eevents')) {
      return ImageableEvent.fromJson(json);
    } else if (lower.contains('venues')) {
      return ImageableVenue.fromJson(json);
    } else {
      // Unknown type: return a generic wrapper
      return ImageableUnknown(json);
    }
  }
}

/// Represents an event-like imageable payload.
class ImageableEvent implements Imageable {
  final int id;
  final String? eventName;
  final String? about;
  final String? description;
  final String? currency;
  final List<ImageData> images;
  final String? venueName;
  final String? venueCity;
  final int? venueCapacity;

  ImageableEvent({
    required this.id,
    this.eventName,
    this.about,
    this.description,
    this.currency,
    this.images = const [],
    this.venueName,
    this.venueCity,
    this.venueCapacity,
  });

  factory ImageableEvent.fromJson(Map<String, dynamic> json) {
    final imagesJson = (json['images'] as List<dynamic>?) ?? [];
    return ImageableEvent(
      id: json['id'] as int,
      eventName: json['event_name'] as String?,
      about: json['about'] as String?,
      description: json['description'] as String?,
      currency: json['currency'] as String?,
      images: imagesJson
          .map((e) => ImageData.fromJson(e as Map<String, dynamic>))
          .toList(),
      venueName: json['venue_name'] as String?,
      venueCity: json['venue_city'] as String?,
      venueCapacity: json['venue_capacity'] is int
          ? json['venue_capacity'] as int
          : int.tryParse('${json['venue_capacity']}'),
    );
  }

  event.EventsModel toEventsModel() {
    return event.EventsModel(
      id: id,
      eventName: eventName,
      about: about,
      description: description,
      currency: currency,
      images: images.isNotEmpty
          ? images.map((i) => event.Images.fromJson(i.toJson())).toList()
          : null,
      venue: (venueName == null && venueCity == null && venueCapacity == null)
          ? null
          : event.Venue(
              name: venueName,
              city: venueCity,
              capacity: venueCapacity,
            ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'event_name': eventName,
    'about': about,
    'description': description,
    'currency': currency,
    'images': images.map((i) => i.toJson()).toList(),
    'venue_name': venueName,
    'venue_city': venueCity,
    'venue_capacity': venueCapacity,
  };
}

/// Represents a venue-like imageable payload.
class ImageableVenue implements Imageable {
  final int id;
  final List<ImageData> images;
  final String? name;
  final String? description;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? latitude;
  final String? longitude;
  final int? capacity;
  final String? contactEmail;
  final String? contactPhone;
  final String? websiteUrl;
  final String? status;
  final bool? isFeatured;
  final String? directionUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? createdBy;

  ImageableVenue({
    required this.id,
    this.images = const [],
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
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory ImageableVenue.fromJson(Map<String, dynamic> json) {
    final imagesJson = (json['images'] as List<dynamic>?) ?? [];
    return ImageableVenue(
      id: json['id'] as int,
      images: imagesJson
          .map((e) => ImageData.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      capacity: json['capacity'] is int
          ? json['capacity'] as int
          : int.tryParse('${json['capacity']}'),
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      websiteUrl: json['website_url'] as String?,
      status: json['status'] as String?,
      isFeatured: json['is_featured'] is bool
          ? json['is_featured'] as bool
          : (json['is_featured'] != null
                ? json['is_featured'].toString().toLowerCase() == 'true'
                : null),
      directionUrl: json['direction_url'] as String?,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      createdBy: json['created_by'] is int
          ? json['created_by'] as int
          : int.tryParse('${json['created_by']}'),
    );
  }
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    // Handle integer timestamps (seconds or milliseconds)
    if (value is int) {
      final millis = value > 1000000000000 ? value : value * 1000;
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }

    final str = value.toString();
    // Try ISO parse
    try {
      return DateTime.parse(str);
    } catch (_) {
      // If it's numeric in string form, try to interpret as timestamp
      final intVal = int.tryParse(str);
      if (intVal != null) {
        final millis = intVal > 1000000000000 ? intVal : intVal * 1000;
        return DateTime.fromMillisecondsSinceEpoch(millis);
      }
      return null;
    }
  }

  venue.VenuesModel toVenuesModel() {
    return venue.VenuesModel(
      id: id,
      images: images.isNotEmpty
          ? images.map((i) => venue.Images.fromJson(i.toJson())).toList()
          : null,
      name: name,
      description: description,
      address: address,
      city: city,
      state: state,
      country: country,
      postalCode: postalCode,
      latitude: latitude,
      longitude: longitude,
      capacity: capacity,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      websiteUrl: websiteUrl,
      status: status,
      isFeatured: isFeatured,
      directionUrl: directionUrl,
      picture: images.isNotEmpty ? images.first.imageUrl : null,
      createdAt: createdAt?.toIso8601String(),
      updatedAt: updatedAt?.toIso8601String(),
      createdBy: createdBy,
      openingHours: null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'images': images.map((i) => i.toJson()).toList(),
    'name': name,
    'description': description,
    'address': address,
    'city': city,
    'state': state,
    'country': country,
    'postal_code': postalCode,
    'latitude': latitude,
    'longitude': longitude,
    'capacity': capacity,
    'contact_email': contactEmail,
    'contact_phone': contactPhone,
    'website_url': websiteUrl,
    'status': status,
    'is_featured': isFeatured,
    'direction_url': directionUrl,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'created_by': createdBy,
  };
}

/// Generic fallback for unknown imageable types
class ImageableUnknown implements Imageable {
  final Map<String, dynamic> raw;

  ImageableUnknown(this.raw);

  @override
  Map<String, dynamic> toJson() => raw;
}

/// Simple image object used by both events and venues
class ImageData {
  final int id;
  final String imageUrl;
  final String? altText;
  final String? caption;
  final int? isFeatured;

  ImageData({
    required this.id,
    required this.imageUrl,
    this.altText,
    this.caption,
    this.isFeatured,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    id: json['id'] as int,
    imageUrl: (json['image_url'] ?? '') as String,
    altText: json['alt_text'] as String?,
    caption: json['caption'] as String?,
    isFeatured: json['is_featured'] is int
        ? json['is_featured'] as int
        : int.tryParse('${json['is_featured']}'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'image_url': imageUrl,
    'alt_text': altText,
    'caption': caption,
    'is_featured': isFeatured,
  };
}
