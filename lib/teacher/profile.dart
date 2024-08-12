import 'package:flutter/material.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here
import 'package:fyp_mobile/property/navgationbar.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart'; // Assuming storage is defined here

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
    int currentPageIndex = 0;
  List<Widget> page = [const Home(), const Calendar(), const LeaveMan(), const Analysis(), const Teacher()];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      
      body: Text("it is profile screen"),
      
    );
  }
}
