import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';

class Announcement extends StatefulWidget {
  const Announcement({super.key});

  @override
  State<Announcement> createState() => _AnnouncementState();
}

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _AnnouncementState extends State<Announcement> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  Widget inputtext(TextEditingController control, String field) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $field'; // Validation error message
          }
          return null; // Return null if the input is valid
        },
        controller: control,
        decoration: InputDecoration(
          hintText: "Enter your $field",
          border: const OutlineInputBorder(),
        ),
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Source Sans Pro',
          color: Colors.black, // Text color
          height: 1.0, // Line height
        ),
        cursorColor: Colors.black,
        maxLines: 8, // Cursor color
      ),
    );
  }

  Future<dynamic> postnoti() async {
    if (_formKey.currentState!.validate()) {
      //need to modify later
      Map<String, dynamic> data = {
        'registrationtoken':
            "d0JIAhSfRoS4j6tqZ50az4:APA91bGsWw99vhBU0bIfkdzuI4NtpiWIZAM9uhhmrPHuY1SgxGE7tyOwPmLeFDnr_Soqe_E51uZ0x5gHxlYZ6_2S1aWbjZHo-d2duyJknyJI-4R4tYqjwKvifyX_wibCV3_rjCMlHEiW",
        'title': title.text,
        'body': content.text,
      };
      try {
        var response = await http.post(
            Uri.parse('http://10.0.2.2:3000/api/rest/send'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data));

        print(response.body);
        return (response.statusCode);
      } catch (e) {
        print(e);
        return e.toString();
      }
    } else {
      return 400.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Topbar(),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Title',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8.0,
            ),
            inputtext(title, "Title"),
            const SizedBox(
              height: 15.0,
            ),
            const Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8.0,
            ),
            inputtext(content, "Content"),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: 8), // Horizontal padding
          fixedSize: const Size(302, 48), // Width and height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Rounded corners
          ),
          backgroundColor: const Color(0xFF1578E6), // Background color
          textStyle: const TextStyle(
            fontSize: 16,
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.w600,
            height: 1.5, // Line height
            color: Colors.white, // Text color
          ),
        ),
        onPressed: postnoti,
        child: const Text(
          "Submit",
          style: TextStyle(color: Colors.white),
        ), // Button label
      ),
    );
  }
}
