class EventDetailsModel {
  int? id;
  String? eventName;
  String? description;
  String? city;
  String? firstSessionDate;
  String? sessionStartTime;
  String? sessionEndTime;
  String? requiredMembershipLevel;
  List<Images>? images;
  Others? others;

  EventDetailsModel({
    this.eventName,
    this.description,
    this.city,
    this.firstSessionDate,
    this.sessionStartTime,
    this.sessionEndTime,
    this.requiredMembershipLevel,
    this.images,
    this.others,
  });

  EventDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json["event_id"];
    eventName = json['event_name'];
    description = json['description'];
    city = json['city'];
    firstSessionDate = json['first_session_date'];
    sessionStartTime = json['session_start_time'];
    sessionEndTime = json['session_end_time'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['event_name'] = eventName;
    data['description'] = description;
    data['city'] = city;
    data['first_session_date'] = firstSessionDate;
    data['session_start_time'] = sessionStartTime;
    data['session_end_time'] = sessionEndTime;
    data['required_membership_level'] = requiredMembershipLevel;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (others != null) {
      data['others'] = others!.toJson();
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['thumbnail_image'] = this.thumbnailImage;
    data['bg_image'] = this.bgImage;
    data['image_gl'] = this.imageGl;
    data['seating_plan'] = this.seatingPlan;
    return data;
  }
}
