import 'dart:convert';

class EventSessionModel {
  final int id;
  final int event;
  final String sessionType;
  final String occurrence;
  final List<String> daysOfWeek;
  final DateTime firstSessionDate;
  final DateTime lastSessionDate;
  final String sessionStartTime;
  final String sessionEndTime;
  final DateTime bookingStartDate;
  final String bookingStartTime;
  final DateTime bookingEndDate;
  final String bookingEndTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventSessionModel({
    required this.id,
    required this.event,
    required this.sessionType,
    required this.occurrence,
    required this.daysOfWeek,
    required this.firstSessionDate,
    required this.lastSessionDate,
    required this.sessionStartTime,
    required this.sessionEndTime,
    required this.bookingStartDate,
    required this.bookingStartTime,
    required this.bookingEndDate,
    required this.bookingEndTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventSessionModel.fromJson(Map<String, dynamic> map) {
    int toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    DateTime toDate(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    }

    List<String> toDays(dynamic raw) {
      if (raw == null) return <String>[];
      String str;
      if (raw is String) {
        str = raw;
      } else {
        str = jsonEncode(raw);
      }
      final decoded = jsonDecode(str);
      if (decoded is List) {
        return decoded.map<String>((e) {
          return e.toString();
        }).toList();
      }
      return <String>[];
    }

    return EventSessionModel(
      id: toInt(map['id']),
      event: toInt(map['event']),
      sessionType: map['session_type']?.toString() ?? '',
      occurrence: map['occurrence']?.toString() ?? '',
      daysOfWeek: toDays(map['days_of_week']),
      firstSessionDate: toDate(map['first_session_date']),
      lastSessionDate: toDate(map['last_session_date']),
      sessionStartTime: map['session_start_time']?.toString() ?? '',
      sessionEndTime: map['session_end_time']?.toString() ?? '',
      bookingStartDate: toDate(map['booking_start_date']),
      bookingStartTime: map['booking_start_time']?.toString() ?? '',
      bookingEndDate: toDate(map['booking_end_date']),
      bookingEndTime: map['booking_end_time']?.toString() ?? '',
      createdAt: toDate(map['created_at']),
      updatedAt: toDate(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    String dateOnly(DateTime d) => d.toIso8601String().split('T').first;

    return {
      'id': id,
      'event': event,
      'session_type': sessionType,
      'occurrence': occurrence,
      'days_of_week': jsonEncode(daysOfWeek),
      'first_session_date': dateOnly(firstSessionDate),
      'last_session_date': dateOnly(lastSessionDate),
      'session_start_time': sessionStartTime,
      'session_end_time': sessionEndTime,
      'booking_start_date': dateOnly(bookingStartDate),
      'booking_start_time': bookingStartTime,
      'booking_end_date': dateOnly(bookingEndDate),
      'booking_end_time': bookingEndTime,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  String toJson() => jsonEncode(toMap());

  EventSessionModel copyWith({
    int? id,
    int? event,
    String? sessionType,
    String? occurrence,
    List<String>? daysOfWeek,
    DateTime? firstSessionDate,
    DateTime? lastSessionDate,
    String? sessionStartTime,
    String? sessionEndTime,
    DateTime? bookingStartDate,
    String? bookingStartTime,
    DateTime? bookingEndDate,
    String? bookingEndTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventSessionModel(
      id: id ?? this.id,
      event: event ?? this.event,
      sessionType: sessionType ?? this.sessionType,
      occurrence: occurrence ?? this.occurrence,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      firstSessionDate: firstSessionDate ?? this.firstSessionDate,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      sessionEndTime: sessionEndTime ?? this.sessionEndTime,
      bookingStartDate: bookingStartDate ?? this.bookingStartDate,
      bookingStartTime: bookingStartTime ?? this.bookingStartTime,
      bookingEndDate: bookingEndDate ?? this.bookingEndDate,
      bookingEndTime: bookingEndTime ?? this.bookingEndTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'EventSessionModel(id: $id, event: $event, sessionType: $sessionType)';
}