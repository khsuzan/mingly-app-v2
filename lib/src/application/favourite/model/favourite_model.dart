class FavouriteModel {
  int? id;
  int? event;
  String? eventName;
  String? eventPicture;
  String? address;
  String? city;
  String? state;
  String? country;
  String? addedAt;

  FavouriteModel({
    this.id,
    this.event,
    this.eventName,
    this.eventPicture,
    this.address,
    this.city,
    this.state,
    this.country,
    this.addedAt,
  });

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'];
    eventName = json['event_name'];
    eventPicture = json['event_picture'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    addedAt = json['added_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['event'] = event;
    data['event_name'] = eventName;
    data['event_picture'] = eventPicture;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['added_at'] = addedAt;
    return data;
  }
}
