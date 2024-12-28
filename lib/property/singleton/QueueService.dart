import 'dart:convert';

import 'package:fyp_mobile/property/queue.dart';
import 'package:http/http.dart' as http;

class QueueService {
  static final QueueService _instance = QueueService._internal();

  factory QueueService() {
    return _instance;
  }

  QueueService._internal();
  Future<bool> checkqueue(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/check/$name'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return data['exists'];
  }

  Future<List<Queueing>> getQueue(String id) async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/queue/$id/verify"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return listFromJson(data['exists']);
      } else if (response.statusCode == 404) {
        // Handle 404 error (resource not found)
        throw Exception('Queue not found for the given ID: $id');
      } else {
        // Handle other error cases
        throw Exception(
            'Error fetching queue data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle any other exceptions that may occur
      rethrow;
    }
  }
    Future<Queueing> queuedetail(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$name'),
        headers: {'Content-Type': 'application/json'});
    return parseQueue(response.body);
  }
}
