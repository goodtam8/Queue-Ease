import 'dart:convert';
class Queue {
  final String id;
  final String restaurantName;
  final int currentPosition;
  final List<dynamic> queueArray; // You can replace dynamic with a specific type if needed

  const Queue({
    required this.id,
    required this.restaurantName,
    required this.currentPosition,
    required this.queueArray,
  });

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      id: json['_id'] as String? ?? '',
      restaurantName: json['restaurantName'] as String? ?? '',
      currentPosition: json['currentPosition'] as int? ?? 0,
      queueArray: json['queueArray'] as List<dynamic>? ?? [],
    );
  }
}

Queue parseQueue(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return Queue.fromJson(parsed['queue']);
}
