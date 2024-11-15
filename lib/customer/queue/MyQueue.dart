import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/queue.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Myqueue extends StatefulWidget {
  const Myqueue({super.key});

  @override
  State<Myqueue> createState() => _MyqueueState();
}

class _MyqueueState extends State<Myqueue> {
  Future<List<Queueing>> getqueue(String id) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$id/verify'),
        headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body);

    return listFromJson(data['exists']);
  }

  late Future<String?> _tokenValue;
  Widget queueinfo(String id) {
    return FutureBuilder(
        future: getqueue(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/update');
                },
                child: const Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            print("hi there is the error occur");
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Queueing> queuelist = snapshot.data!;
            return queuecard(queuelist, id);
          }
        });
  }

  Widget queuecard(List<Queueing> data, String oid) {
    List<Widget> queuecard = [];
    DateTime now = DateTime.now().toUtc();
    for (var queue in data) {
      queuecard.add(Container(
        width: 343,
        height: 96,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text("$now"),
                ElevatedButton(onPressed: () {}, child: Text("restaurant")),
              ],
            ),
            Row(
              children: [
                Text(
                  "hi ${queue.restaurantName}",
                  style: const TextStyle(
                    color: Color(0xFF030303),
                    fontSize: 14,
                    fontFamily: 'Source Sans Pro',
                    fontWeight: FontWeight.w700,
                    height:
                        1.29, // This is equivalent to lineHeight of 18px with fontSize 14px
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/qr2',
                      arguments: {
                        'restaurant': queue.restaurantName,
                        'id': oid,
                        // Add more arguments as needed
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1578E6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8), // Horizontal padding

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24), // Border radius
                    ),
                    elevation: 0, // No shadow
                  ),
                  child: const Text(
                    "View",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Source Sans Pro',
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ));
    }

    return Column(
      children: queuecard,
    );
  }

  Widget debugtoken() {
    return FutureBuilder<String?>(
        future: _tokenValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/update');
                },
                child: const Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            print("hi there is the error occur");
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> decodedToken =
                JwtDecoder.decode(snapshot.data as String);
            String oid = decodedToken["_id"].toString();
            return queueinfo(oid);
          }
        });
  }

  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: Column(
        children: [debugtoken()],
      ),
    );
  }
}
