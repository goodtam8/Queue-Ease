
/// Model class representing a dining record
class DineRecord {
  final String id;
  final String customerId;
  final String numberOfPeople;
  final String status;
  final String name;
  final DateTime createdAt;

  DineRecord({
    required this.id,
    required this.customerId,
    required this.numberOfPeople,
    required this.status,
    required this.name,
    required this.createdAt,
  });

  /// Creates a DineRecord from JSON
  factory DineRecord.fromJson(Map<String, dynamic> json) {
    // Handle MongoDB ObjectId format
    String id;
    if (json['_id'] is String) {
      id = json['_id'];
    } else if (json['_id'] is Map && json['_id'].containsKey('\$oid')) {
      id = json['_id']['\$oid'];
    } else {
      id = json['_id'].toString();
    }

    // Handle MongoDB date format
    DateTime createdAt;
    if (json['createdAt'] is String) {
      createdAt = DateTime.parse(json['createdAt']);
    } else if (json['createdAt'] is Map && json['createdAt'].containsKey('\$date')) {
      createdAt = DateTime.parse(json['createdAt']['\$date']);
    } else {
      createdAt = DateTime.now();
    }

    return DineRecord(
      id: id,
      customerId: json['customerId'] ?? '',
      numberOfPeople: json['numberOfPeople'] ?? '',
      status: json['status'] ?? '',
      name: json['name'] ?? '',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'numberOfPeople': numberOfPeople,
      'status': status,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}