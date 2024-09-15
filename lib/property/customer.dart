import 'dart:convert';

class Customerper {
  final String id;
  final int uid;
  final String name;
  final String pw;
  final String gender;
  final int phone;
  final int year;

  const Customerper({
    required this.id,
    required this.uid,
    required this.name,
    required this.pw,
    required this.gender,
    required this.phone,
    required this.year,
  });

  factory Customerper.fromJson(Map<String, dynamic> json) {
    return Customerper(
      uid: json['uid'] != null
          ? json['uid'] as int
          : 0, // Provide a default value
      id: json['_id'] as String? ?? '', // Provide a default value
      name: json['name'] as String? ?? '',
      pw: json['pw'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      phone: json['phone_num'] != null
          ? json['phone_num'] as int
          : 0, // Provide a default value
      year: json['year'] != null
          ? json['year'] as int
          : 0, // Provide a default value
    );
  }
}

Customerper parseCustomer(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return Customerper.fromJson(parsed);
}
