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
  final dynamic imageable; // event.EventsModel or venue.VenuesModel
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
    final imageableJson = json['imageable'];
    dynamic imageableObj;
    if (imageableJson != null) {
      if (imageableType.toLowerCase().contains('eevents')) {
        imageableObj = event.EventsModel.fromJson(imageableJson as Map<String, dynamic>);
      } else if (imageableType.toLowerCase().contains('venues')) {
        imageableObj = venue.VenuesModel.fromJson(imageableJson as Map<String, dynamic>);
      } else {
        imageableObj = imageableJson;
      }
    }
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
      imageable: imageableObj,
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
    'imageable': imageable is event.EventsModel || imageable is venue.VenuesModel
        ? imageable.toJson()
        : imageable,
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

// ...existing code...
