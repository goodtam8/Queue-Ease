import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
   return const Scaffold(
    appBar: Topbar(),
      body: Text("It is Calendar screen"),
    );
  }
}