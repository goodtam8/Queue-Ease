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
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $field'; // Validation error message
        } else if (int.tryParse(value) == null) {
          return 'Please input a valid $field';
        }
        return null; // Return null if the input is valid
      },
      controller: control,
      decoration: InputDecoration(
        hintText: "Enter your $field", border: const OutlineInputBorder(),

        filled: true,
        fillColor: const Color(0xFFF1F1F1), // Background color
        contentPadding: const EdgeInsets.symmetric(horizontal: 8), // Padding
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8), // Hint text color
          fontSize: 14, // Font size
          fontFamily: 'Source Sans Pro', // Font family
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        fontFamily: 'Source Sans Pro',
        color: Colors.black, // Text color
        height: 1.0, // Line height
      ),
      cursorColor: Colors.black,
      maxLines: 8, // Cursor color
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onPressed: () {
          // Define button action here
        },
        child: const Text(
          "Submit",
          style: TextStyle(color: Colors.white),
        ), // Button label
      ),
    );
  }
}
