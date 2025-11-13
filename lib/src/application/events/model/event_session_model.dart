import 'dart:convert';

class EventSessionModel {
  final int id;
  final int event;
  final String sessionType;
  final String occurrence;
  final List<int> daysOfWeek;
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

  factory EventSessionModel.fromMap(Map<String, dynamic> map) {
    int _toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    DateTime _toDate(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    }

    List<int> _toDays(dynamic raw) {
      if (raw == null) return <int>[];
      String str;
      if (raw is String) {
        str = raw;
      } else {
        str = jsonEncode(raw);
      }
      final decoded = jsonDecode(str);
      if (decoded is List) {
        return decoded.map<int>((e) {
          if (e is int) return e;
          return int.tryParse(e.toString()) ?? 0;
        }).toList();
      }
      return <int>[];
    }

    return EventSessionModel(
      id: _toInt(map['id']),
      event: _toInt(map['event']),
      sessionType: map['session_type']?.toString() ?? '',
      occurrence: map['occurrence']?.toString() ?? '',
      daysOfWeek: _toDays(map['days_of_week']),
      firstSessionDate: _toDate(map['first_session_date']),
      lastSessionDate: _toDate(map['last_session_date']),
      sessionStartTime: map['session_start_time']?.toString() ?? '',
      sessionEndTime: map['session_end_time']?.toString() ?? '',
      bookingStartDate: _toDate(map['booking_start_date']),
      bookingStartTime: map['booking_start_time']?.toString() ?? '',
      bookingEndDate: _toDate(map['booking_end_date']),
      bookingEndTime: map['booking_end_time']?.toString() ?? '',
      createdAt: _toDate(map['created_at']),
      updatedAt: _toDate(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    String _dateOnly(DateTime d) => d.toIso8601String().split('T').first;

    return {
      'id': id,
      'event': event,
      'session_type': sessionType,
      'occurrence': occurrence,
      'days_of_week': jsonEncode(daysOfWeek),
      'first_session_date': _dateOnly(firstSessionDate),
      'last_session_date': _dateOnly(lastSessionDate),
      'session_start_time': sessionStartTime,
      'session_end_time': sessionEndTime,
      'booking_start_date': _dateOnly(bookingStartDate),
      'booking_start_time': bookingStartTime,
      'booking_end_date': _dateOnly(bookingEndDate),
      'booking_end_time': bookingEndTime,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory EventSessionModel.fromJson(String source) =>
      EventSessionModel.fromMap(jsonDecode(source));

  String toJson() => jsonEncode(toMap());

  EventSessionModel copyWith({
    int? id,
    int? event,
    String? sessionType,
    String? occurrence,
    List<int>? daysOfWeek,
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