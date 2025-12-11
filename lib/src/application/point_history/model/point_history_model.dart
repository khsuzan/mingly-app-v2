class PointHistory {
  String? user;
  int? totalPoints;
  List<History>? history;

  PointHistory({this.user, this.totalPoints, this.history});

  PointHistory.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    totalPoints = json['total_points'];
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['total_points'] = totalPoints;
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class History {
  int? id;
  int? points;
  String? transactionType;
  String? description;
  String? createdAt;

  History(
      {this.id,
      this.points,
      this.transactionType,
      this.description,
      this.createdAt});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points'];
    transactionType = json['transaction_type'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['points'] = points;
    data['transaction_type'] = transactionType;
    data['description'] = description;
    data['created_at'] = createdAt;
    return data;
  }
}
