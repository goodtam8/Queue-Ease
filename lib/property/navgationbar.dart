import 'package:flutter/material.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart';
import 'package:fyp_mobile/teacher/profile.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here


class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;
  List<Widget> page = [
    const Home(),
    const Calendar(),
    const LeaveMan(),
    const Analysis(),
    const Teacher()
  ];
  void updateIndex(int index){
    setState(() {
      currentPageIndex=index;
    });
  }

  Map<String, Widget> routes = {
    'home': const Home(),
    'calendar': const Calendar(),
    'leave': const LeaveMan(),
    'analysis': const Analysis(),
    'profile': const Teacher()
  };

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:true
     ,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Navigator(
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) => page[currentPageIndex],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.blue), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month, color: Colors.blue),
                label: 'Calendar'),
            BottomNavigationBarItem(
                icon: Icon(Icons.man, color: Colors.blue), label: 'Leave'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart, color: Colors.blue),
                label: 'Analysis'),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_copy_rounded, color: Colors.blue),
                label: 'Profile'),
          ],
          currentIndex: currentPageIndex,
          onTap: (int index) {
            updateIndex(index);
          },
        ),
      ),
    );
  }
}

GlobalKey<_NavigationState> globalNavigationBarKey = GlobalKey();
