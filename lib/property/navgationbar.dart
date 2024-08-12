import 'package:flutter/material.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart';
import 'package:fyp_mobile/teacher/profile.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here


class Navagation extends StatefulWidget {
  const Navagation({super.key});

  @override
  State<Navagation> createState() => _NavagationState();
}

class _NavagationState extends State<Navagation> {
  int currentPageIndex = 0;
  List<Widget> page = [const Home(), const Calendar(), const LeaveMan(), const Analysis(), const Teacher()];

  @override
  Widget build(BuildContext context) {

  
      return 
      
      
      
      
      
       Scaffold(
      backgroundColor: Colors.white,
      
      bottomNavigationBar:  NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month), label: 'Calendar'),
            NavigationDestination(icon: Icon(Icons.man), label: 'Leave'),
            NavigationDestination(
                icon: Icon(Icons.pie_chart), label: 'Attendance'),
            NavigationDestination(
                icon: Icon(Icons.file_copy_rounded), label: 'Profile'),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              
            });
          },
        
        ),
      body: page[currentPageIndex],
      
    );
  }
}
