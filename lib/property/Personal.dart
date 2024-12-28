import 'dart:convert';

class personal {
  final String id;
  final int sid;
  final String name;
  final String pw;
  final String gender;
  final String email;
  final int phone;

  const personal({
    required this.id,
    required this.sid,
    required this.name,
    required this.pw,
    required this.gender,
    required this.email,
    required this.phone,
  });

  factory personal.fromJson(Map<String, dynamic> json) {
    return personal(
      sid: json['sid'] as int,
      id: json['_id'] as String,
      name: json['name'] as String,
      pw: json['pw'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      phone: json['phone'] as int,
    );
  }
}

personal parsepersonal(String responseBody) {
  final parsed = (jsonDecode(responseBody)) as Map<String, dynamic>;

  return personal.fromJson(parsed);
}
