class EventDetailsModel {
  int? id;
  String? eventName;
  String? description;
  String? city;
  String? requiredMembershipLevel;
  List<Images>? images;
  Others? others;
  List<Session>? sessions;

  EventDetailsModel({
    this.id,
    this.eventName,
    this.description,
    this.city,
    this.requiredMembershipLevel,
    this.images,
    this.others,
    this.sessions,
  });

  EventDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json["event_id"];
    eventName = json['event_name'];
    description = json['description'];
    city = json['city'];
    requiredMembershipLevel = json['required_membership_level'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['others'] != null) {
      others = Others.fromJson(json['others']);
    }
    if (json['sessions'] != null) {
      sessions = <Session>[];
      json['sessions'].forEach((v) {
        sessions!.add(Session.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['event_id'] = id;
    data['event_name'] = eventName;
    data['description'] = description;
    data['city'] = city;
    data['required_membership_level'] = requiredMembershipLevel;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (others != null) {
      data['others'] = others!.toJson();
    }
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Session {
  int? id;
  int? event;
  String? sessionType;
  String? occurrence;
  List<String>? daysOfWeek;
  String? firstSessionDate;
  String? lastSessionDate;
  String? sessionStartTime;
  String? sessionEndTime;
  String? bookingStartDate;
  String? bookingStartTime;
  String? bookingEndDate;
  String? bookingEndTime;
  String? createdAt;
  String? updatedAt;

  Session({
    this.id,
    this.event,
    this.sessionType,
    this.occurrence,
    this.daysOfWeek,
    this.firstSessionDate,
    this.lastSessionDate,
    this.sessionStartTime,
    this.sessionEndTime,
    this.bookingStartDate,
    this.bookingStartTime,
    this.bookingEndDate,
    this.bookingEndTime,
    this.createdAt,
    this.updatedAt,
  });

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'];
    sessionType = json['session_type'];
    occurrence = json['occurrence'];
    if (json['days_of_week'] != null) {
      daysOfWeek = List<String>.from(json['days_of_week']);
    }
    firstSessionDate = json['first_session_date'];
    lastSessionDate = json['last_session_date'];
    sessionStartTime = json['session_start_time'];
    sessionEndTime = json['session_end_time'];
    bookingStartDate = json['booking_start_date'];
    bookingStartTime = json['booking_start_time'];
    bookingEndDate = json['booking_end_date'];
    bookingEndTime = json['booking_end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['event'] = event;
    data['session_type'] = sessionType;
    data['occurrence'] = occurrence;
    data['days_of_week'] = daysOfWeek;
    data['first_session_date'] = firstSessionDate;
    data['last_session_date'] = lastSessionDate;
    data['session_start_time'] = sessionStartTime;
    data['session_end_time'] = sessionEndTime;
    data['booking_start_date'] = bookingStartDate;
    data['booking_start_time'] = bookingStartTime;
    data['booking_end_date'] = bookingEndDate;
    data['booking_end_time'] = bookingEndTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
class Others {
  int? id;
  String? thumbnailImage;
  String? bgImage;
  String? imageGl;
  String? seatingPlan;
  String? youtube;

  Others({
    this.id,
    this.thumbnailImage,
    this.bgImage,
    this.imageGl,
    this.seatingPlan,
    this.youtube,
  });

  Others.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumbnailImage = json['thumbnail_image'];
    bgImage = json['bg_image'];
    imageGl = json['image_gl'];
    seatingPlan = json['seating_plan'];
    youtube = json['youtube'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['thumbnail_image'] = thumbnailImage;
    data['bg_image'] = bgImage;
    data['image_gl'] = imageGl;
    data['seating_plan'] = seatingPlan;
    data['youtube'] = youtube;
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
