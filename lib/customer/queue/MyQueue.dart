import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/queue.dart';
import 'package:fyp_mobile/property/singleton/QueueService.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class Myqueue extends StatefulWidget {
  const Myqueue({super.key});

  @override
  State<Myqueue> createState() => _MyqueueState();
}

class _MyqueueState extends State<Myqueue> {
  final queueService = QueueService();

  Widget buttonrest() {
    return Container(
      // Positioning the card using Positioned widget inside a Stack
      width: 90,
      height: 16,
      decoration: BoxDecoration(
        color: Color(0xFF1578E6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
          child: Text(
        "Restaurant",
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  late Future<String?> _tokenValue;
  Widget queueinfo(String id) {
    return FutureBuilder(
        future: queueService.getQueue(id),
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
            return const Center(
                child: Text('You have not queue in a restaurant yet'));
          } else {
            List<Queueing> queuelist = snapshot.data!;
            return queuecard(queuelist, id);
          }
        });
  }

//add an algorithm to it
//if the status is finished then no display
  Widget queuecard(List<Queueing> data, String oid) {
    List<Widget> queuecard = [];
    DateTime now = DateTime.now().toUtc();
    for (var queue in data) {
      queuecard.add(Container(
        width: 400,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("$now"),
                  const SizedBox(
                    width: 10.0,
                  ),
                  buttonrest()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
                  const Spacer(),
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
                      backgroundColor: const Color(0xFF1578E6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8), // Horizontal padding

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(24), // Border radius
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
              ),
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
      appBar: const Topbar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            debugtoken()
          ],
        ),
      ),
    );
  }
}
