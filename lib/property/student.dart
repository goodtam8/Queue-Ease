import 'dart:convert';

class Studentper {
  final String id;
  final int sid;
  final String name;
  final String pw;
  final String gender;
  final int phone;
  final int year;

  const Studentper({
    required this.id,
    required this.sid,
    required this.name,
    required this.pw,
    required this.gender,
    required this.phone,
    required this.year
  });

  factory Studentper.fromJson(Map<String, dynamic> json) {
    return Studentper(
      sid: json['sid'] as int,
      id: json['_id'] as String,
      name: json['name'] as String,
      pw: json['pw'] as String,
      gender: json['gender'] as String,
      phone: json['phone_num'] as int,
      year:json['year'] as int 
    );
  }
}
Studentper parsestudent(String responseBody) {
  final parsed = (jsonDecode(responseBody))as Map<String, dynamic>;

  return Studentper.fromJson(parsed);
}
