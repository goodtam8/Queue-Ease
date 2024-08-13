import 'package:flutter/material.dart';
import 'package:fyp_mobile/teacher/Home.dart';
import 'package:fyp_mobile/teacher/analysis.dart';
import 'package:fyp_mobile/teacher/calendar.dart';
import 'package:fyp_mobile/teacher/leave_man.dart';
import 'package:fyp_mobile/teacher/profile.dart';
import 'package:fyp_mobile/login.dart'; // Assuming storage is defined here


class StudentNavagation extends StatefulWidget {
  const StudentNavagation({super.key}) ;

  @override
  StudentNavagation_state createState() => StudentNavagation_state();
}

class StudentNavagation_state extends State<StudentNavagation> {
  
  int currentPageIndex = 0;
  int previousPageIndex = 0;
  List<Widget> page = [
    const Home(),
    const Calendar(),
    const LeaveMan(),
    const Analysis(),
     Teacher(onLogout:Widget.onLogout()},)
  ];
  void updateIndex(int index) {
    setState(() {
      previousPageIndex = currentPageIndex;
      currentPageIndex = index;
    });

   
  }

   void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  void addListener(void Function(int newIndex) handleIndexChange) {
    handleIndexChange(currentPageIndex);
  }

  void removeListener(void Function(int newIndex) handleIndexChange) {}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
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
          items:  [
            BottomNavigationBarItem(
                icon: Image.asset('university.png'), label: 'Home'),
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

GlobalKey<StudentNavagation_state> studentglobalnavkey = GlobalKey();
