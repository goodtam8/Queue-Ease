import 'dart:convert';

class Tabledb {
  final String id;
  final int tableNum;
  final String status;
  final String belong;
  final String type;

  const Tabledb({
    required this.id,
    required this.tableNum,
    required this.status,
    required this.belong,
    required this.type
  });

   static List<Tabledb> listFromJson(List<dynamic> json) {
    return json.map((item) => Tabledb.fromJson(item)).toList();
  }

  factory Tabledb.fromJson(Map<String, dynamic> json) {
    return Tabledb(
      id: json['_id'] as String? ?? '', // Provide a default value
      tableNum: json['table_num'] as int? ?? 0, // Provide a default value
      status: json['status'] as String? ?? '', // Provide a default value
      belong: json['belong'] as String? ?? '', // Provide a default value
      type: json['type'] as String? ?? '1-2 people',
    );
  }
}


