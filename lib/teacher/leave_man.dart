import 'package:flutter/material.dart';

class LeaveMan extends StatefulWidget {
  const LeaveMan({super.key});

  @override
  State<LeaveMan> createState() => _LeaveManState();
}

class _LeaveManState extends State<LeaveMan> {
  @override
  Widget build(BuildContext context) {
 return const Scaffold(
      body: Text("It is leave management screen"),
    );  }
}