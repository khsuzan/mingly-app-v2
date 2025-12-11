class AdsImage {
  int? id;
  String? title;
  String? imageUrl;
  String? altText;
  String? caption;
  int? createdBy;
  String? createdByName;
  String? createdAt;
  String? updatedAt;

  AdsImage(
      {this.id,
      this.title,
      this.imageUrl,
      this.altText,
      this.caption,
      this.createdBy,
      this.createdByName,
      this.createdAt,
      this.updatedAt});

  AdsImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    altText = json['alt_text'];
    caption = json['caption'];
    createdBy = json['created_by'];
    createdByName = json['created_by_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image_url'] = imageUrl;
    data['alt_text'] = altText;
    data['caption'] = caption;
    data['created_by'] = createdBy;
    data['created_by_name'] = createdByName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
