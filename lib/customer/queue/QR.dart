import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/queue/Menu.dart';
import 'package:fyp_mobile/property/queue.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/singleton/QueueService.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:http/http.dart' as http;

class Qr extends StatefulWidget {
  const Qr({super.key});

  @override
  State<Qr> createState() => _QrState();
}

class _QrState extends State<Qr> {
  Widget order(String name, String id) {
    return FutureBuilder(
        future: getrestdetail(name),
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
            Restaurant detail = snapshot.data!;
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Order(
                      restaurant: detail.id,
                      id: id,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                fixedSize: const Size(107, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                backgroundColor:
                    const Color(0xFF1578E6), // Equivalent to #1578e6
                elevation: 0,
              ),
              child: const Text(
                "Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Source Sans Pro',
                  fontWeight: FontWeight.w600, // Equivalent to fontWeight: 600
                  height: 24 / 16, // lineHeight: 24px / fontSize: 16px
                ),
              ),
            );
          }
        });
  }

  // Added new homeButton widget
  Widget homeButton() {
    return ElevatedButton(
      onPressed: () {
        // Pop to return to the home screen
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        fixedSize: const Size(160, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF4CAF50), // Green color
        elevation: 0,
      ),
      child: const Text(
        "Back to Restuarant ",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Source Sans Pro',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  final QueueService queueService = QueueService();

  Widget queuecondition(String name) {
    return FutureBuilder(
        future: queueService.queuedetail(name),
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
            Queueing data = snapshot.data!; // You now have your 'personal' data
            int position = data.currentPosition;
            return Positioned(
              child: Container(
                width: 226,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  children: [
                    Text("Current Queue Number:${data.currentPosition}"),
                    Text(
                        "People Waiting in the queue:${data.queueArray.length}"),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget deletebutton(String name, String id) {
    return ElevatedButton(
      onPressed: () async {
        await delete(name, id);
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: const Color(0xFFE63946), // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0, // No shadow
      ),
      child: const Text(
        "Leave Queue",
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Source Sans Pro',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.5, // Line height equivalent
        ),
      ),
    );
  }

  Future<Restaurant> getrestdetail(String name) async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/rest/${name}'),
        headers: {'Content-Type': 'application/json'});

    return parseRestaurant(response.body);
  }

  Future<dynamic> delete(String name, String id) async {
    try {
      var search = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$id/search/$name'),
        headers: {'Content-Type': 'application/json'},
      );
      final rid = jsonDecode(search.body);

      var response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/queue/$name/leave/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      var deleterecord = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/record/$rid'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);
      return (response.statusCode);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  String? qrdata;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;

    final rest = args['restaurant'];// change from here now is the name 
    final id = args['id'];
    qrdata = id;
    final restName = rest.name; // Extract the name from Restaurant object

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrettyQrView.data(data: qrdata!),
          const SizedBox(height: 16), // Add spacing
          order(restName, id),
          const SizedBox(height: 12), // Add spacing
          deletebutton(restName, id),
          const SizedBox(height: 12), // Add spacing
          homeButton(), // Added new home button
          const SizedBox(height: 16), // Add spacing
          queuecondition(restName)
        ],
      ),
    );
  }
}
