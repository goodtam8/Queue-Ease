import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final double lat;
  final double lng;
  final double rating;
  final int total;

  const Restaurant(
      {required this.id,
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
      required this.lat,
      required this.lng,
      required this.rating,
      required this.total});
  static List<Restaurant> listFromJson(List<dynamic> json) {
    return json.map((item) => Restaurant.fromJson(item)).toList();
  }

  LatLng get coordinate => LatLng(this.lat, this.lng);

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        id: json['_id'] is Map
            ? (json['_id'] as Map<String, dynamic>)['oid'] as String? ?? ''
            : json['_id'] as String? ?? '',
        img: json['img'] as String? ?? '', // Provide a default value
        name: json['name'] as String? ?? '', // Provide a default value
        startTime:
            json['start_time'] as String? ?? '', // Provide a default value
        endTime: json['end_time'] as String? ?? '', // Provide a default value
        type: json['type'] as String? ?? '', // Provide a default value
        outside: json['outside'] as bool? ?? false, // Provide a default value
        numOfTable: json['numoftable'] as int? ?? 0, // Provide a default value
        year: json['year'].toString() ?? '', // Provide a default value
        location: json['location'] as String? ?? '', // Provide a default value
        quota: json['quota'] as int? ?? 0, // Provide a default value
        menu: json['menu'] as List<dynamic>? ?? [], // Provide a default value
        lat: json['lat'] ?? 0,
        lng: json['lng'] ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ??
            3.0, // Use null-aware operator and default value
        total: json['total'] ?? 5);
  }
}

Restaurant parseRestaurant(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;

  return Restaurant.fromJson(parsed);
}
