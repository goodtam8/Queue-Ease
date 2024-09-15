import 'dart:convert';

class Timetable {
  final String id;
  final int staff_id;
  final List<String> Monday;
  final List<String> Tuesday;
  final List<String> Wednesday;
  final List<String> Thursday;
  final List<String> Friday;

  const Timetable({
    required this.id,
    required this.staff_id,
    required this.Monday,
    required this.Tuesday,
    required this.Wednesday,
    required this.Thursday,
    required this.Friday,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      staff_id: json['staff_id'] as int,
      id: json['_id'] as String,
      Monday: List<String>.from(json['Monday']),
      Tuesday: List<String>.from(json['Tuesday']),
      Wednesday: List<String>.from(json['Wednesday']),
      Thursday: List<String>.from(json['Thursday']),
      Friday: List<String>.from(json['Friday']),
    );
  }
}

Timetable parseTimetable(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;

  return Timetable.fromJson(parsed);
}