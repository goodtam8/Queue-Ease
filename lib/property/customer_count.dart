class DailyCustomerCount {
  final DateTime date;
  final int count;

  DailyCustomerCount({required this.date, required this.count});

  factory DailyCustomerCount.fromJson(Map<String, dynamic> json) {
    return DailyCustomerCount(
      date: DateTime.parse(json['_id']),
      count: json['count'],
    );
  }
}
