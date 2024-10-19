import 'package:flutter/material.dart';
import 'package:fyp_mobile/customer/Menu.dart';
import 'package:fyp_mobile/property/topbar.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  String? _selectedSize; // Variable to hold the selected size

  // List of party sizes
  final List<String> _partySizes = [
    '1-2 people',
    '3-4 people',
    '5-6 people',
    '7+ people',
  ];

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

  Widget joinbutton(Object rest) {
    return ElevatedButton(
      onPressed: () {
        if (_selectedSize != null) {
          Navigator.pushNamed(
            context,
            '/qr',
            arguments: {
              'restaurant': rest,
              'party': _selectedSize,
              // Add more arguments as needed
            },
          );
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
      child: Text(
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
            SizedBox(
              height: 30.0,
            ),
            partypicker(),
            SizedBox(
              height: 30.0,
            ),
            joinbutton(rest!)
          ],
        ),
      ),
    );
  }
}
