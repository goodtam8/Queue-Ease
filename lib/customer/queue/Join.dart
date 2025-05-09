import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/queue/Menu.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  String? _selectedSize; // Variable to hold the selected size
  String? _childrenSize;

  // List of party sizes
  final List<String> _partySizes = [
    '1-2 people',
    '3-4 people',
    '5-6 people',
    '7+ people',
  ];
  final List<String> _childrenSizes = [
    '0',
    '1',
    '2',
    '3+',
  ];
  Future<dynamic> join(String restname, String objectid) async {
    try {
      // First check if customer exists in the queue
      final checkResponse = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/queue/$restname/check/$objectid'),
      );

      final checkData = jsonDecode(checkResponse.body);

      if (checkResponse.statusCode == 200) {
        if (checkData['exists'] == true) {
          print(checkData['message']);
          return checkData['message']; // Customer already exists
        }
      } else if (checkResponse.statusCode == 404) {
        return checkData['message']; // Queue not found
      }

      // Proceed with joining queue if customer doesn't exist
      Map<String, dynamic> record = {
        'customerId': objectid,
        'numberOfPeople': _selectedSize,
        'status': "waiting",
        'name': restname,
        'children': _childrenSize,
      };

      var order = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/record'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(record),
      );

      final rid = jsonDecode(order.body);
      Map<String, dynamic> data = {
        'customerId': objectid,
        'numberOfPeople': _selectedSize,
        'rid': rid,
        'children': _childrenSize,
      };

      var response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/queue/$restname/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final message = jsonDecode(response.body);
      return message['message'];
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Widget partypicker() {
    return Container(
      width: 327,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1), // Background color
        borderRadius: BorderRadius.circular(24), // Border radius
      ),
      child: DropdownButton<String>(
        isExpanded: true, // Make the dropdown take the full width
        value: _selectedSize,
        hint: Text('Select party size'),
        items: _partySizes.map((String size) {
          return DropdownMenuItem<String>(
            value: size,
            child: Text(size),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSize = newValue; // Update the selected size
          });
        },
        underline: SizedBox(), // Hide the underline
      ),
    );
  }

  Widget childrenpicker() {
    return Container(
      width: 327,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1), // Background color
        borderRadius: BorderRadius.circular(24), // Border radius
      ),
      child: DropdownButton<String>(
        isExpanded: true, // Make the dropdown take the full width
        value: _childrenSize,
        hint: Text('Select Number of Children/Elderly'),
        items: _childrenSizes.map((String size) {
          return DropdownMenuItem<String>(
            value: size,
            child: Text(size),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _childrenSize = newValue; // Update the selected size
          });
        },
        underline: SizedBox(), // Hide the underline
      ),
    );
  }
  //add to the queue

  Widget joinbutton(Object rest) {
    return ElevatedButton(
      onPressed: () async {
        if (_selectedSize != null) {
          final _tokenValue = await storage.read(key: 'jwt');
          Map<String, dynamic> decodedToken =
              JwtDecoder.decode(_tokenValue as String);
          String oid = decodedToken["_id"].toString();
          String mess = await join((rest as Restaurant).name, oid);
          if (mess == "Customer is already in the queue") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('You are already in the queue'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                });
          } else {
            Navigator.pushNamed(
              context,
              '/qr',
              arguments: {
                'restaurant': rest,
                'id': oid,
                // Add more arguments as needed
              },
            );
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Please select the party size'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              });
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        fixedSize: const Size(327, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: const Color(0xFF1578E6), // Button color
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: 'Source Sans Pro',
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      child: const Text(
        "Join",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rest = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Topbar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            partypicker(),
            const SizedBox(
              height: 30.0,
            ),
            childrenpicker(),
            const SizedBox(
              height: 30.0,
            ),
            joinbutton(rest!)
          ],
        ),
      ),
    );
  }
}
