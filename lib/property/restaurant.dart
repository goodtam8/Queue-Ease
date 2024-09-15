import 'dart:convert';

class Restaurant {
  final String id;
  final String img;
  final String name;
  final String startTime;
  final String endTime;
  final String type;
  final bool outside;
  final int numOfTable;
  final String year;
  final String location;
  final int quota;
  final List<dynamic> menu;

  const Restaurant({
    required this.id,
    required this.img,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.outside,
    required this.numOfTable,
    required this.year,
    required this.location,
    required this.quota,
    required this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] as String? ?? '', // Provide a default value
      img: json['img'] as String? ?? '', // Provide a default value
      name: json['name'] as String? ?? '', // Provide a default value
      startTime: json['start_time'] as String? ?? '', // Provide a default value
      endTime: json['end_time'] as String? ?? '', // Provide a default value
      type: json['type'] as String? ?? '', // Provide a default value
      outside: json['outside'] as bool? ?? false, // Provide a default value
      numOfTable: json['numoftable'] as int? ?? 0, // Provide a default value
      year: json['year'] as String? ?? '', // Provide a default value
      location: json['location'] as String? ?? '', // Provide a default value
      quota: json['quota'] as int? ?? 0, // Provide a default value
      menu: json['menu'] as List<dynamic>? ?? [], // Provide a default value
    );
  }
}

Restaurant parseRestaurant(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;

  return Restaurant.fromJson(parsed);
}
