class TableTicketModel {
  List<Tables>? tables;
  String? slotStart;
  String? slotEnd;
  SessionInfo? sessionInfo;

  TableTicketModel({
    this.tables,
    this.slotStart,
    this.slotEnd,
    this.sessionInfo,
  });

  TableTicketModel.fromJson(Map<String, dynamic> json) {
    if (json['tables'] != null) {
      tables = <Tables>[];
      json['tables'].forEach((v) {
        tables!.add(Tables.fromJson(v));
      });
    }
    slotStart = json['slot_start'];
    slotEnd = json['slot_end'];
    sessionInfo = json['session_info'] != null
        ? SessionInfo.fromJson(json['session_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tables != null) {
      data['tables'] = tables!.map((v) => v.toJson()).toList();
    }
    data['slot_start'] = slotStart;
    data['slot_end'] = slotEnd;
    if (sessionInfo != null) {
      data['session_info'] = sessionInfo!.toJson();
    }
    return data;
  }
}

class Tables {
  int? id;
  String? seatStatus;
  String? availabilityStatus;
  String? tcketNumber;
  double? x;
  double? y;
  double? w;
  double? h;
  String? shape;
  List<String>? chairs;
  String? image;
  double? price;
  int? tableId;

  Tables({
    this.id,
    this.seatStatus,
    this.availabilityStatus,
    this.tcketNumber,
    this.x,
    this.y,
    this.w,
    this.h,
    this.shape,
    this.chairs,
    this.image,
    this.price,
    this.tableId,
  });

  Tables.fromJson(Map<String, dynamic> json) {
    id = json['seat_id'];
    seatStatus = json['seat_status'];
    availabilityStatus = json['availability_status'];
    tcketNumber = json['tcket_number'];
    x = json['x'];
    y = json['y'];
    w = json['w'];
    h = json['h'];
    shape = json['shape'];
    chairs = json['chairs']?.cast<String>();
    image = json['set_image'];
    price = json["price"];
    tableId = json["table_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seat_status'] = seatStatus;
    data['availability_status'] = availabilityStatus;
    data['tcket_number'] = tcketNumber;
    data['x'] = x;
    data['y'] = y;
    data['w'] = w;
    data['h'] = h;
    data['shape'] = shape;
    data['chairs'] = chairs;
    data['set_image'] = image;
    data["table_id"] = tableId;
    return data;
  }
}

class SessionInfo {
  String? sessionStart;
  String? sessionEnd;
  String? selectedDate;

  SessionInfo({this.sessionStart, this.sessionEnd, this.selectedDate});

  SessionInfo.fromJson(Map<String, dynamic> json) {
    sessionStart = json['session_start'];
    sessionEnd = json['session_end'];
    selectedDate = json['selected_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_start'] = sessionStart;
    data['session_end'] = sessionEnd;
    data['selected_date'] = selectedDate;
    return data;
  }
}
