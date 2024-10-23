import 'dart:convert';

class Queueing {
  final String id;
  final String restaurantName;
  final int currentPosition;
  final List<QueueItem> queueArray;

  const Queueing({
    required this.id,
    required this.restaurantName,
    required this.currentPosition,
    required this.queueArray,
  });

  factory Queueing.fromJson(Map<String, dynamic> json) {
    return Queueing(
      id: json['_id'] as String? ?? '',
      restaurantName: json['restaurantName'] as String? ?? '',
      currentPosition: json['currentPosition'] as int? ?? 0,
      queueArray: (json['queueArray'] as List<dynamic>? ?? [])
          .map((item) => QueueItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QueueItem {
  final String customerId;
  final dynamic numberOfPeople; // Can be int or String
  final int queueNumber;
  final DateTime checkInTime;

  const QueueItem({
    required this.customerId,
    required this.numberOfPeople,
    required this.queueNumber,
    required this.checkInTime,
  });

  factory QueueItem.fromJson(Map<String, dynamic> json) {
    // Check if the checkInTime is a valid string before parsing
    final checkInTimeString = json['checkInTime'] as String?;
    final checkInTime =
        checkInTimeString != null && checkInTimeString.isNotEmpty
            ? DateTime.parse(checkInTimeString)
            : DateTime(1970); // Default value if the string is null or empty

    return QueueItem(
      customerId: json['customerId'] as String? ?? '',
      numberOfPeople: json['numberOfPeople'], // This can be int or String
      queueNumber: json['queueNumber'] as int? ?? 0,
      checkInTime: checkInTime,
    );
  }
}

Queueing parseQueue(String responseBody) {
  final Map<String, dynamic> jsonMap = jsonDecode(responseBody);
  final Map<String, dynamic> queueData = jsonMap['queue'];
  return Queueing.fromJson(queueData);
}
